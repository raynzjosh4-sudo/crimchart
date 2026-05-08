import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:crimchart/features/auth/application/auth_controller.dart';
import 'package:crimchart/posting/models/media_item.dart';
import 'package:crimchart/core/db/chart_native_db.dart';
import 'package:crimchart/features/channel/application/channel_feed_provider.dart';
import 'package:crimchart/features/channel/application/channel_statuses_provider.dart';
import 'package:crimchart/features/channel/application/channel_moments_provider.dart';
import '../posting_service.dart';

import 'posting_status.dart';
import 'posting_state.dart';
import '../posting_progress_provider.dart';

class PostingController extends StateNotifier<PostingState> {
  final Ref _ref;
  final PostingService _service;

  PostingController(this._ref, this._service)
    : super(PostingState(status: PostingStatus.idle));

  Future<void> createPost({
    required List<MediaItem> media,
    required String caption,
    // ── Channel context ────────────────────────────────────────────────────
    String? channelId,
    String? channelName,
    bool isMyChannel = false,
    // ── Post type ──────────────────────────────────────────────────────────
    String postType = 'post',
    String? parentPostId,
    // ── Implicit / overrides ───────────────────────────────────────────────
    List<String> channels = const [],
    String privacy = 'public',
    String customRole = '',

    bool isPublicFeed = true, // 👑 Decides if it hits the global 'posts' table
    bool allowComments = true, // 👑 Engagement setting
    bool shareToStatus = false, // 👑 ADDED
    bool shareToMoment = false, // 👑 ADDED
    // ── Explicit Link fields (for Replies/Deep-Linked threads) ──────────────
    String? linkedPostId,
    String? linkedAuthorUsername,
    String? linkedCaption,
    String? linkedChannelId,
    List<String>? linkedThumbnailUrls,
    double? aspectRatio,
  }) async {
    debugPrint('🚀 [POST] createPost() STARTED (Refactored)');
    state = PostingState(status: PostingStatus.processing, progress: 0.1);

    try {
      if (linkedPostId != null) {
        debugPrint('💬 [POST] Starting COMMENT on Channel Post: $linkedPostId');
      } else {
        debugPrint(
          '🚀 [POST] Starting New CHANNEL POST in Channel: $channelId',
        );
      }

      final user = _ref.read(authControllerProvider).user;
      if (user == null) throw Exception('User not authenticated');

      final shaped = await _service.shapeInitialPost(
        user: user,
        media: media,
        caption: caption,
        channelId: channelId,
        channelName: channelName,
        isMyChannel: isMyChannel,
        postType: postType,
        parentPostId: parentPostId,
        channels: channels,
        isPublicFeed: isPublicFeed,
        allowComments: allowComments,
        shareToStatus: shareToStatus,
        shareToMoment: shareToMoment, // 👑
        linkedPostId: linkedPostId,
        linkedAuthorUsername: linkedAuthorUsername,
        linkedCaption: linkedCaption,
        linkedChannelId: linkedChannelId,
        linkedThumbnailUrls: linkedThumbnailUrls,
        aspectRatio: aspectRatio,
      );

      final optimisticPost = shaped.entity;
      final newPostId = optimisticPost.id;
      final resolvedChannelId = optimisticPost.channelId;

      // 👑 OPTIMISTIC UI INJECTION
      if (shaped.targetTable == 'channel_post_comments') {
        debugPrint(
          '⚡ [POST] Injecting optimistic REPLY into Discussion Sheet...',
        );
      } else {
        debugPrint(
          '⚡ [POST] Injecting optimistic CHANNEL POST into Channel Feed...',
        );
      }

      // 👑 REMOVED: Optimistic injection and local caching.
      // We now wait for the actual upload and Supabase response to prevent duplicate empty widgets.

      // 🚀 Start background upload
      debugPrint(
        '📤 [POST] Kicking off background upload via PostingService...',
      );
      _processAndUploadInBackground(
        userId: user.id,
        media: media,
        shaped: shaped,
        privacy: privacy,
        customRole: customRole,
        isPublicFeed: isPublicFeed,
        allowComments: allowComments,
        shareToStatus: shareToStatus,
        shareToMoment: shareToMoment, // 👑
      );

      _ref.invalidate(authControllerProvider);
      state = PostingState(status: PostingStatus.success, progress: 1.0);
      debugPrint(
        '🎉 [POST] createPost() DONE — UI success, upload running in background',
      );
    } catch (e) {
      debugPrint('❌ [POST] POSTING ERROR: $e');
      state = PostingState(status: PostingStatus.error, error: e.toString());
    }
  }

  Future<void> _processAndUploadInBackground({
    required String userId,
    required List<MediaItem> media,
    required PostShapedData shaped,
    required String privacy,
    required String customRole,
    bool isPublicFeed = true,
    bool allowComments = true,
    bool shareToStatus = false,
    bool shareToMoment = false, // 👑 ADDED
  }) async {
    final postId = shaped.entity.id;
    try {
      debugPrint(
        '📤 [BG UPLOAD] Background process started for postId=$postId',
      );

      // 👑 3. CLOUDFLARE PUT (UPLOAD) via Service
      final uploadResults = await _service.uploadMediaAssets(
        userId: userId,
        media: media,
        folderName: shaped.folderName,
        existingThumbnails: shaped.entity.thumbnailUrls,
        onProgress: (sent, total) {
          final progress = sent / total;
          final mbSent = (sent / 1024 / 1024).toStringAsFixed(1);
          final mbTotal = (total / 1024 / 1024).toStringAsFixed(1);

          _ref
              .read(postingProgressProvider(postId).notifier)
              .update(
                (s) => s.copyWith(
                  progress: progress,
                  uploadedSize: '$mbSent MB',
                  totalSize: '$mbTotal MB',
                ),
              );
        },
      );

      // 👑 GUARDRAIL: Verify the upload actually succeeded!
      bool uploadFailed = false;
      if (shaped.entity.isVideo && uploadResults.hdVideoUrls.isEmpty)
        uploadFailed = true;
      if (shaped.entity.isAudio && uploadResults.audioUrl == null)
        uploadFailed = true;
      if (shaped.entity.imageUrls.isNotEmpty && uploadResults.imageUrls.isEmpty)
        uploadFailed = true;

      if (uploadFailed) {
        debugPrint(
          '❌ [BG] CLOUDFLARE UPLOAD FAILED. Aborting Supabase sync to prevent local path corruption.',
        );
        // Optional: You could update the SQLite 'posts' table here to set 'isPending': -1 (Failed state)
        return;
      }

      // 👑 4. SUPABASE PUT (METADATA) via Service
      if (shaped.targetTable == 'channel_post_comments') {
        debugPrint(
          '🌐 [BG] PERMANENT INSERT: Saving comment to channel_post_comments table...',
        );
      } else {
        debugPrint(
          '🌐 [BG] PERMANENT INSERT: Saving post to channel_posts table...',
        );
      }

      await _service.finalizeSupabasePost(
        basePost: shaped.entity,
        uploadResults: uploadResults,
        privacy: privacy,
        customRole: customRole,
        isPublicFeed: isPublicFeed,
        allowComments: allowComments,
        shareToStatus: shareToStatus,
        shareToMoment: shareToMoment, // 👑
      );

      // 👑 SQLite CLEANUP: Mark as synced so it doesn't return as pending on app restart
      await ChartNativeDB.instance.markPostSynced(postId);

      // 👑 REFRESH REAL DATA: Now that it's safely in Supabase, fetch the true data!
      final feedNotifier = _ref.read(
        channelFeedProvider(shaped.entity.channelId ?? 'general').notifier,
      );
      feedNotifier.refresh(isInitial: true);

      if (shareToStatus &&
          shaped.entity.channelId != null &&
          shaped.entity.channelId != 'general') {
        _ref
            .read(channelStatusesProvider(shaped.entity.channelId!).notifier)
            .refresh();
      }

      if (shaped.entity.postType == 'moment' &&
          shaped.entity.channelId != null) {
        _ref.invalidate(channelMomentsProvider(shaped.entity.channelId!));
      }

      debugPrint('✅ [BG UPLOAD] Upload and Sync COMPLETE for postId=$postId');
    } catch (e) {
      debugPrint('❌ [BG] UPLOAD FAILED: $e');
    }
  }

  void reset() {
    state = PostingState(status: PostingStatus.idle);
  }
}
