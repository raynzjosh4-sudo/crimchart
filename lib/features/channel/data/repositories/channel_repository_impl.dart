import 'package:crimchart/core/di/injection.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/db/chart_native_db.dart';
import '../../domain/repositories/channel_repository.dart';
import '../../domain/entities/channel_entity.dart';
import '../sources/channel_remote_source.dart';
import '../../../../profile/models/charter_model.dart';

@LazySingleton(as: ChannelRepository)
class ChannelRepositoryImpl implements ChannelRepository {
  final ChannelRemoteSource remoteSource;

  ChannelRepositoryImpl(this.remoteSource);

  @override
  Future<Either<Failure, ChannelEntity>> createChannel(
    Map<String, dynamic> channelData, {
    String? avatarUrl,
  }) async {
    try {
      final channel = await remoteSource.createChannel(
        channelData,
        avatarUrl: avatarUrl,
      );

      // 👑 INSTANT LOCAL CACHING: Make it immediately available offline!
      await ChartNativeDB.instance.cacheFullChannelProfile(channel);

      return Right(channel);
    } on ServerException catch (e) {
      debugPrint('❌ [Repository] Supabase Error: ${e.message}');
      return Left(ServerFailure(e.message));
    } catch (e, stack) {
      debugPrint('❌ [Repository] Drift/Local Error: $e\n$stack');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChannelEntity>> updateChannel(
    String channelId,
    Map<String, dynamic> channelData, {
    String? avatarUrl,
  }) async {
    try {
      final channel = await remoteSource.updateChannel(
        channelId,
        channelData,
        avatarUrl: avatarUrl,
      );

      // 👑 SYNC LOCAL CACHE IMMEDIATELY (Upsert logic to ensure it exists)
      await ChartNativeDB.instance.cacheFullChannelProfile(channel);

      return Right(channel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChannelEntity>>> getChannels(
    String filter, {
    int page = 0,
  }) async {
    try {
      final channels = await remoteSource.getChannels(filter, page: page);
      return Right(channels);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<ChannelEntity>> watchChannels(String filter) {
    return remoteSource.watchChannels(filter);
  }

  @override
  Future<List<ChannelEntity>> getOfflineFirstChannels(String filter) async {
    // 1. ⚡ INSTANT LOCAL LOAD (Drift Engine)
    final rows = await ChartNativeDB.instance.getCachedChannels();

    // Map the raw rows to your Dart entities
    List<ChannelEntity> localChannels = rows
        .map((json) => ChannelEntity.fromLocalCache(json))
        .toList();

    // 2. ☁️ BACKGROUND SYNC (Supabase)
    // We don't await this blocking the UI. We let it run asynchronously.
    _syncChannelsFromCloud(filter);

    if (filter == 'joined') {
      final currentUserId = Supabase.instance.client.auth.currentUser?.id;
      // We do a best-effort client-side filter of the cache
      return localChannels.where((ch) {
        final isMine = ch.creatorId == currentUserId;
        final isInvited = ch
            .isCharted; // Cached isCharted might be accurate enough for offline
        return isMine || isInvited;
      }).toList();
    } else if (filter == 'private') {
      return localChannels.where((ch) => ch.isPrivate).toList();
    }

    return localChannels;
  }

  Future<void> _syncChannelsFromCloud(String filter) async {
    try {
      final remoteData = await remoteSource.getChannels(filter);

      // 👑 WIPE ZOMBIES: Clear the current filter's cache so deleted channels disappear locally
      await ChartNativeDB.instance.clearSyncedPosts(
        channelId: filter == 'private'
            ? 'private'
            : (filter == 'public' ? 'public' : null),
      );

      for (final ch in remoteData) {
        await ChartNativeDB.instance.cacheFullChannelProfile(ch);
      }
      debugPrint(
        '☁️ [Sync] Successfully purged zombies and re-synced ${remoteData.length} channels for filter: $filter',
      );
    } catch (e) {
      debugPrint(
        '☁️ [Sync] Could not fetch channels (Offline mode active). Error: $e',
      );
    }
  }

  @override
  Future<Either<Failure, List<CharterModel>>> getChannelMembers(
    String channelId,
  ) async {
    try {
      final members = await remoteSource.getChannelMembers(channelId);
      return Right(members);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendInvitation({
    required String sourceChannelId,
    required String targetChannelId,
    String? channelName,
    String? channelImageUrl,
    String? channelTitle,
  }) async {
    try {
      final userId = remoteSource.currentUserId;
      if (userId == null) return Left(ServerFailure('User not authenticated'));

      // 👑 1. SAVE LOCALLY (Zero lag, even offline)
      final nativeDb = getIt<ChartNativeDB>();
      await nativeDb.upsertChannelInvitation({
        'id': '${sourceChannelId}_${targetChannelId}',
        'senderId': userId,
        'sourceChannelId': sourceChannelId,
        'targetChannelId': targetChannelId,
        'createdAt': DateTime.now().toIso8601String(),
        'isPending': 1,
      });

      // 👑 2. SYNC TO CLOUD
      await remoteSource.sendInvitation(
        senderId: userId,
        sourceChannelId: sourceChannelId,
        targetChannelId: targetChannelId,
        channelName: channelName,
        channelImageUrl: channelImageUrl,
        channelTitle: channelTitle,
      );

      // Mark synced locally
      await nativeDb.upsertChannelInvitation({
        'id': '${sourceChannelId}_${targetChannelId}',
        'senderId': userId,
        'sourceChannelId': sourceChannelId,
        'targetChannelId': targetChannelId,
        'createdAt': DateTime.now().toIso8601String(),
        'isPending': 0,
      });

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Set<String>> getInvitedChannelIds(String targetChannelId) async {
    final nativeDb = getIt<ChartNativeDB>();
    return await nativeDb.getInvitedChannelIds(targetChannelId);
  }

  @override
  Future<void> resetUnreadCount(String channelId) async {
    await remoteSource.resetUnreadCount(channelId);
  }

  @override
  Future<void> resetUnreadMomentsCount(String channelId) async {
    await remoteSource.resetUnreadMomentsCount(channelId);
  }
}
