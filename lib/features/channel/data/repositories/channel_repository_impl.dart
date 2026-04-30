import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/db/chart_native_db.dart';
import 'package:sqflite/sqflite.dart';
import '../../domain/repositories/channel_repository.dart';
import '../../domain/entities/channel_entity.dart';
import '../sources/channel_remote_source.dart';

@LazySingleton(as: ChannelRepository)
class ChannelRepositoryImpl implements ChannelRepository {
  final ChannelRemoteSource remoteSource;

  ChannelRepositoryImpl(this.remoteSource);

  @override
  Future<Either<Failure, ChannelEntity>> createChannel(Map<String, dynamic> channelData, {String? avatarUrl}) async {
    try {
      final channel = await remoteSource.createChannel(channelData, avatarUrl: avatarUrl);
      return Right(channel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChannelEntity>> updateChannel(String channelId, Map<String, dynamic> channelData, {String? avatarUrl}) async {
    try {
      final channel = await remoteSource.updateChannel(channelId, channelData, avatarUrl: avatarUrl);
      
      // 👑 SYNC LOCAL CACHE IMMEDIATELY (Upsert logic to ensure it exists)
      final db = await ChartNativeDB.instance.database;
      await db.insert('channel_cache', {
        'id': channel.id,
        'creator_id': channel.creatorId,
        'name': channel.name,
        'description': channel.description,
        'avatarUrl': channel.avatarUrl,
        'memberCount': channel.memberCount,
        'unreadCount': channel.unreadCount,
        'leaderAvatarUrl': channel.leaderAvatarUrl,
        'creatorAvatarUrl': channel.creatorAvatarUrl,
        'isCharted': channel.isCharted ? 1 : 0,
        'isPrivate': channel.isPrivate ? 1 : 0,
        'age_restriction': channel.age_restriction ?? 'All Ages',
        'members_other_channels': channel.members_other_channels ?? 0,
        'members_following': channel.members_following ?? 1,
        'join_method': channel.join_method ?? 'invite',
        'prevent_leaving': channel.prevent_leaving ?? 0,
        'country_restrictions': channel.country_restrictions ?? '["Global"]',
        'allow_commenting_by': channel.allow_commenting_by ?? 'all',
        'isPending': 0,
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      return Right(channel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChannelEntity>>> getChannels(String filter) async {
    try {
      final channels = await remoteSource.getChannels(filter);
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
    // 1. ⚡ INSTANT LOCAL LOAD (C++ Engine)
    final db = await ChartNativeDB.instance.database;
    final rows = await db.query(
      'channel_cache',
      orderBy: 'name ASC',
      limit: 50,
    );
    
    // Map the raw SQLite rows to your Dart entities
    List<ChannelEntity> localChannels = rows.map((json) => ChannelEntity.fromLocalCache(json)).toList();

    // 2. ☁️ BACKGROUND SYNC (Supabase)
    // We don't await this blocking the UI. We let it run asynchronously.
    _syncChannelsFromCloud(filter);

    return localChannels;
  }

  Future<void> _syncChannelsFromCloud(String filter) async {
    try {
      final remoteData = await remoteSource.getChannels(filter);
      
      final db = await ChartNativeDB.instance.database;
      final batch = db.batch();

      // 👑 WIPE ZOMBIES: Clear the current filter's cache so deleted channels disappear locally
      if (filter == 'private') {
        batch.delete('channel_cache', where: 'isPrivate = 1 AND isPending = 0');
      } else if (filter == 'public') {
        batch.delete('channel_cache', where: 'isPrivate = 0 AND isPending = 0');
      } else {
        batch.delete('channel_cache', where: 'isPending = 0');
      }

      for (final ch in remoteData) {
        batch.insert('channel_cache', {
          'id': ch.id,
          'name': ch.name,
          'description': ch.description,
          'avatarUrl': ch.avatarUrl,
          'memberCount': ch.memberCount,
          'unreadCount': ch.unreadCount,
          'leaderAvatarUrl': ch.leaderAvatarUrl,
          'creatorAvatarUrl': ch.creatorAvatarUrl,
          'isCharted': ch.isCharted ? 1 : 0,
          'isPrivate': ch.isPrivate ? 1 : 0,
          'isPending': 0,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
      debugPrint('☁️ [Sync] Successfully purged zombies and re-synced ${remoteData.length} channels for filter: $filter');
    } catch (e) {
      debugPrint('☁️ [Sync] Could not fetch channels (Offline mode active). Error: $e');
    }
  }
}





























