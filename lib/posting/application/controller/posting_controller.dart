import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:crown/features/auth/application/auth_controller.dart';
import 'package:crown/posting/models/media_item.dart';
import 'package:crown/core/db/chart_native_db.dart';
import 'package:crown/features/channel/application/channel_feed_provider.dart';
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
    // ── Explicit Link fields (for Replies/Deep-Linked threads) ──────────────
    String? linkedPostId,
    String? linkedAuthorUsername,
    String? linkedCaption,
    String? linkedChannelId,
    List<String>? linkedThumbnailUrls,
  }) async {
    debugPrint('🚀 [POST] createPost() STARTED (Refactored)');
    state = PostingState(status: PostingStatus.processing, progress: 0.1);

    try {
      if (linkedPostId != null) {
        debugPrint('💬 [POST] Starting COMMENT on Manifesto: $linkedPostId');
      } else {
        debugPrint('🚀 [POST] Starting New MANIFESTO in Channel: $channelId');
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
        linkedPostId: linkedPostId,
        linkedAuthorUsername: linkedAuthorUsername,
        linkedCaption: linkedCaption,
        linkedChannelId: linkedChannelId,
        linkedThumbnailUrls: linkedThumbnailUrls,
      );

      final optimisticPost = shaped.entity;
      final newPostId = optimisticPost.id;
      final resolvedChannelId = optimisticPost.channelId;

      // 👑 OPTIMISTIC UI INJECTION
      if (shaped.targetTable == 'manifesto_comments') {
        debugPrint('⚡ [POST] Injecting optimistic REPLY into Discussion Sheet...');
      } else {
        debugPrint('⚡ [POST] Injecting optimistic MANIFESTO into Channel Feed...');
      }
      
      final feedNotifier = _ref.read(channelFeedProvider(resolvedChannelId).notifier);
      
      feedNotifier.injectOptimisticPost(optimisticPost);

      // 👑 OPTIMISTIC COUNT: If this is a comment, increment parent Manifesto count in memory!
      if (shaped.entity.linkedPostId != null && 
          (shaped.targetTable == 'manifesto_comments' || channelId != 'general')) {
        feedNotifier.incrementCommentCount(shaped.entity.linkedPostId!);
      }

      // Save to local DB instantly
      debugPrint('💾 [POST] Saving optimistic post to local SQLite DB...');
      await ChartNativeDB.instance.cacheOptimisticItem(
        shaped.targetTable, 
        shaped.localDbMap,
      );

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

          _ref.read(postingProgressProvider(postId).notifier).update(
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
      if (shaped.entity.isVideo && uploadResults.hdVideoUrls.isEmpty) uploadFailed = true;
      if (shaped.entity.isAudio && uploadResults.audioUrl == null) uploadFailed = true;
      if (shaped.entity.imageUrls.isNotEmpty && uploadResults.imageUrls.isEmpty) uploadFailed = true;

      if (uploadFailed) {
        debugPrint('❌ [BG] CLOUDFLARE UPLOAD FAILED. Aborting Supabase sync to prevent local path corruption.');
        // Optional: You could update the SQLite 'posts' table here to set 'isPending': -1 (Failed state)
        return; 
      }

      // 👑 4. SUPABASE PUT (METADATA) via Service
      if (shaped.targetTable == 'manifesto_comments') {
        debugPrint('🌐 [BG] PERMANENT INSERT: Saving comment to manifesto_comments table...');
      } else {
        debugPrint('🌐 [BG] PERMANENT INSERT: Saving manifesto to manifestos table...');
      }
      
      await _service.finalizeSupabasePost(
        basePost: shaped.entity,
        uploadResults: uploadResults,
        privacy: privacy,
        customRole: customRole,
        isPublicFeed: isPublicFeed,
        allowComments: allowComments,
        shareToStatus: shareToStatus,
      );

      // 👑 SQLite CLEANUP: Mark as synced so it doesn't return as pending on app restart
      await ChartNativeDB.instance.markPostSynced(postId);

      debugPrint('🏁 [BG] Background process COMPLETE for postId=$postId');
    } catch (e) {
      debugPrint('❌ [BG] UPLOAD FAILED: $e');
    }
  }

  void reset() {
    state = PostingState(status: PostingStatus.idle);
  }
}
