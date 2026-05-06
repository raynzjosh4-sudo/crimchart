import 'package:crown/features/showcase/chart_toast.dart';
import 'package:crown/posting/application/posting_service.dart';
import 'package:crown/posting/models/media_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../domain/entities/channel_message_entity.dart';
import '../../../core/db/chart_native_db.dart';
import '../../../core/di/injection.dart';
import '../../auth/application/auth_controller.dart';
import '../data/sources/channel_remote_source.dart';
import 'dart:async';

part 'channel_messages_provider.g.dart';

final channelMessagesLoadingProvider = StateProvider.family<bool, String>(
  (ref, channelId) => false,
);
final channelMessagesErrorProvider = StateProvider.family<String?, String>(
  (ref, channelId) => null,
);
final channelMessagesHasMoreProvider = StateProvider.family<bool, String>(
  (ref, channelId) => true,
);

@riverpod
class ChannelMessages extends _$ChannelMessages {
  ChartNativeDB get _nativeDb => getIt<ChartNativeDB>();
  final List<ChannelMessageEntity> _memoryMessages = [];
  final _controller = StreamController<List<ChannelMessageEntity>>.broadcast();
  StreamSubscription? _syncSubscription;

  @override
  Stream<List<ChannelMessageEntity>> build(String channelId) async* {
    // 1. Initial Load from local DB (newest 10)
    final initialRows = await _nativeDb.getChannelMessages(
      channelId,
      limit: 10,
    );
    _memoryMessages.clear();
    _memoryMessages.addAll(
      initialRows
          .map((row) => ChannelMessageEntity.fromMap(row))
          .toList()
          .reversed,
    );
    yield List.from(_memoryMessages);

    // 2. Start background sync
    _remoteSync();

    ref.onDispose(() {
      _syncSubscription?.cancel();
      _controller.close();
    });

    yield* _controller.stream;
  }

  void _remoteSync() {
    final remoteSource = getIt<ChannelRemoteSource>();
    _syncSubscription = remoteSource.streamChannelMessages(channelId).listen((
      messages,
    ) async {
      bool changed = false;
      for (final msg in messages) {
        final entity = ChannelMessageEntity.fromMap(msg);

        // Add to memory if not present
        if (!_memoryMessages.any((m) => m.id == entity.id)) {
          _memoryMessages.add(entity);
          _memoryMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          changed = true;

          // Save to local DB & Trim
          await _nativeDb.upsertChannelMessage(msg);
          await _nativeDb.trimChannelMessages(
            channelId: channelId,
            keepCount: 10,
          );
        }
      }
      if (changed) {
        _controller.add(List.from(_memoryMessages));
      }
    });
  }

  /// 👑 MEMORY-ONLY PAGINATION: Fetches older messages and keeps them in RAM
  Future<void> loadMore() async {
    final isLoading = ref.read(channelMessagesLoadingProvider(channelId));
    final hasMore = ref.read(channelMessagesHasMoreProvider(channelId));

    if (isLoading || !hasMore) return;

    ref.read(channelMessagesLoadingProvider(channelId).notifier).state = true;
    ref.read(channelMessagesErrorProvider(channelId).notifier).state = null;

    try {
      // 1. Get the oldest message timestamp we have in memory
      DateTime? oldestTimestamp;
      if (_memoryMessages.isNotEmpty) {
        oldestTimestamp = _memoryMessages.first.createdAt;
      }

      // 2. Fetch older messages from remote
      final remoteSource = getIt<ChannelRemoteSource>();
      final olderMessages = await remoteSource.getChannelMessages(
        channelId,
        limit: 10,
        beforeTimestamp: oldestTimestamp,
      );

      if (olderMessages.isEmpty) {
        ref.read(channelMessagesHasMoreProvider(channelId).notifier).state =
            false;
      } else {
        // 3. ADD TO MEMORY ONLY
        final entities = olderMessages
            .map((m) => ChannelMessageEntity.fromMap(m))
            .toList();
        _memoryMessages.addAll(entities);
        _memoryMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

        _controller.add(List.from(_memoryMessages));
      }
    } catch (e) {
      debugPrint('🚨 [Pagination Error] Failed to load older messages: $e');
      ref.read(channelMessagesErrorProvider(channelId).notifier).state =
          'Connection lost. Tap to retry.';
    } finally {
      ref.read(channelMessagesLoadingProvider(channelId).notifier).state =
          false;
    }
  }

  Future<void> sendMessage({
    String? text,
    String? mediaUrl,
    List<Map<String, String>>? mediaItems,
    String? replyToId,
    ChannelMessageType type = ChannelMessageType.text,
    Map<String, dynamic>? metadata,
  }) async {
    final currentUser = ref.read(authControllerProvider).user;
    if (currentUser == null) return;

    final messageId = const Uuid().v4();
    String? finalMediaUrl = mediaUrl;
    List<Map<String, String>> finalMediaItems = List.from(mediaItems ?? []);

    // 👑 1. OPTIMISTIC UPDATE (Memory + DB)
    final optimisticMessage = ChannelMessageEntity(
      id: messageId,
      channelId: channelId,
      senderId: currentUser.id,
      senderUsername: currentUser.username,
      senderAvatarUrl: currentUser.profileImageUrl,
      textContent: text,
      mediaUrl:
          mediaUrl ??
          (finalMediaItems.isNotEmpty ? finalMediaItems.first['url'] : null),
      messageType: type,
      replyToId: replyToId,
      createdAt: DateTime.now().toUtc(),
      metadata: {
        ...?metadata,
        if (finalMediaItems.isNotEmpty) 'media_items': finalMediaItems,
      },
      isPending: true,
    );

    _memoryMessages.add(optimisticMessage);
    _memoryMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    _controller.add(List.from(_memoryMessages));

    await _nativeDb.upsertChannelMessage(optimisticMessage.toMap());
    await _nativeDb.trimChannelMessages(channelId: channelId, keepCount: 10);

    // 👑 2. MEDIA UPLOAD & CLOUD SYNC
    _processUploadAndSync(
      optimisticMessage,
      finalMediaItems,
      metadata,
      type,
      currentUser.id,
    );
  }

  Future<void> _processUploadAndSync(
    ChannelMessageEntity optimisticMessage,
    List<Map<String, String>> finalMediaItems,
    Map<String, dynamic>? metadata,
    ChannelMessageType type,
    String currentUserId,
  ) async {
    String? finalMediaUrl = optimisticMessage.mediaUrl;
    final List<Map<String, String>> remoteMediaItems = [];
    final List<String> localPathsToUpload = [];
    final List<MediaType> localTypesToUpload = [];

    for (var item in finalMediaItems) {
      final url = item['url']!;
      if (!url.startsWith('http')) {
        localPathsToUpload.add(url);
        localTypesToUpload.add(
          item['type'] == 'video' ? MediaType.video : MediaType.photo,
        );
      } else {
        remoteMediaItems.add(item);
      }
    }

    if (localPathsToUpload.isNotEmpty) {
      try {
        final postingService = getIt<PostingService>();
        final uploadResult = await postingService.uploadMediaAssets(
          userId: currentUserId,
          media: List.generate(
            localPathsToUpload.length,
            (i) => MediaItem(
              path: localPathsToUpload[i],
              type: localTypesToUpload[i],
            ),
          ),
          folderName: 'channel_messages',
          existingThumbnails: [],
        );

        int imgIdx = 0;
        int vidIdx = 0;
        for (int i = 0; i < localPathsToUpload.length; i++) {
          String? uploadedUrl;
          if (localTypesToUpload[i] == MediaType.photo &&
              imgIdx < uploadResult.imageUrls.length) {
            uploadedUrl = uploadResult.imageUrls[imgIdx++];
          } else if (localTypesToUpload[i] == MediaType.video &&
              vidIdx < uploadResult.hdVideoUrls.length) {
            uploadedUrl = uploadResult.hdVideoUrls[vidIdx++];
          }

          if (uploadedUrl != null) {
            remoteMediaItems.add({
              'url': uploadedUrl,
              'type': localTypesToUpload[i] == MediaType.video
                  ? 'video'
                  : 'image',
            });
          }
        }

        if (remoteMediaItems.isNotEmpty) {
          finalMediaUrl = remoteMediaItems.first['url'];
        }

        // Update memory
        final idx = _memoryMessages.indexWhere(
          (m) => m.id == optimisticMessage.id,
        );
        if (idx != -1) {
          _memoryMessages[idx] = _memoryMessages[idx].copyWith(
            mediaUrl: finalMediaUrl,
            metadata: {...?metadata, 'media_items': remoteMediaItems},
          );
          _controller.add(List.from(_memoryMessages));
        }

        await _nativeDb.upsertChannelMessage(_memoryMessages[idx].toMap());
      } catch (e) {
        debugPrint('👑 [sendMessage] ❌ Media upload FAILED: $e');
      }
    }

    // PUSH TO CLOUD
    try {
      final remoteSource = getIt<ChannelRemoteSource>();
      final idx = _memoryMessages.indexWhere(
        (m) => m.id == optimisticMessage.id,
      );
      if (idx != -1) {
        final finalMessage = _memoryMessages[idx].copyWith(isPending: false);
        await remoteSource.sendChannelMessage(finalMessage.toMap());

        _memoryMessages[idx] = finalMessage;
        _controller.add(List.from(_memoryMessages));

        await _nativeDb.upsertChannelMessage(finalMessage.toMap());
      }
    } catch (e) {
      debugPrint('👑 [sendMessage] ⚠️ Cloud sync failed: $e');
    }
  }
}
