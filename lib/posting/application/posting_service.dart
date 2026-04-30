import 'dart:convert';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:crown/core/db/chart_native_db.dart';
import 'package:crown/core/network/cloud_media_service.dart';
import 'package:crown/core/native/chart_native_ffi.dart';
import 'package:crown/features/feed/domain/entities/post_entity.dart';
import 'package:crown/features/feed/domain/repositories/feed_repository.dart';
import 'package:crown/features/auth/domain/entities/user_entity.dart';
import 'package:crown/posting/models/media_item.dart';

@lazySingleton
class PostingService {
  final FeedRepository _repository;
  final CloudMediaService _cloudService;

  PostingService(this._repository, this._cloudService); // 👑 Force build sync

  /// 👑 1. DATA SHAPING (SHEIK DATA)
  /// Prepares post entities and local DB maps.
  Future<PostShapedData> shapeInitialPost({
    required UserEntity user,
    required List<MediaItem> media,
    required String caption,
    String? channelId,
    String? channelName,
    bool isMyChannel = false,
    String postType = 'post',
    String? parentPostId,
    List<String> channels = const [],
    // Link fields
    String? linkedPostId,
    String? linkedAuthorUsername,
    String? linkedCaption,
    String? linkedChannelId,
    List<String>? linkedThumbnailUrls,
    bool isPublicFeed = true, // 👑 
    bool allowComments = true, // 👑
    bool shareToStatus = false, // 👑
  }) async {
    // Resolve basic fields
    final linkedItem = media.where((m) => m.linkedPostId != null).firstOrNull;
    final resolvedLinkedPostId = linkedPostId ?? linkedItem?.linkedPostId;
    final resolvedLinkedAuthorUsername = linkedAuthorUsername ?? linkedItem?.linkedAuthorUsername;
    final resolvedLinkedCaption = linkedCaption ?? linkedItem?.linkedCaption;
    final resolvedLinkedChannelId = linkedChannelId ?? linkedItem?.linkedChannelId;
    final resolvedThumbnailUrls = linkedThumbnailUrls ?? (linkedItem?.thumbnailUrl != null ? [linkedItem!.thumbnailUrl!] : []);
    
    final existingChain = linkedItem?.linkChain ?? const [];
    final existingDepth = linkedItem?.linkDepth ?? 0;
    
    // 👑 TABLE-BASED FOLDER ROUTING
    // Logic: Decide which R2 folder this media belongs to based on the primary destination table.
    String resolvedFolderName = 'posts'; // Global Feed
    
    final resolvedChannelId = channelId ?? (channels.isNotEmpty ? channels.first : 'general');
    final resolvedChannelName = channelName ?? (channels.isNotEmpty ? channels.first : 'General');
    
    // 👑 ROUTING LOGIC: 
    // Determine folder and type based on channel context
    final isChannelContent = resolvedChannelId != 'general' && resolvedChannelId.isNotEmpty;
    final isCommentOrReply = postType == 'comment' || postType == 'reply';
    final isManifesto = isChannelContent && !isCommentOrReply;
    
    if (isManifesto) {
      resolvedFolderName = 'channel_posts';
    } else if (!isPublicFeed && shareToStatus) {
      resolvedFolderName = 'statuses';
    }
    
    final folderName = resolvedFolderName;

    final newPostId = const Uuid().v4();
    final finalChain = [...existingChain, if (resolvedLinkedPostId != null) resolvedLinkedPostId];
    
    final isVideo = media.isNotEmpty && media.first.type == MediaType.video;
    final isAudio = media.isNotEmpty && media.last.type == MediaType.audio;

    // Scan for instant URLs
    List<String> instantImages = [];
    List<String> instantThumbnails = resolvedThumbnailUrls; 
    List<String> instantVideos = []; // 👑 PLURAL VIDEOS
    String? instantAudio;

    final appDir = await getTemporaryDirectory();

    for (var item in media) {
      // 1. Thumbnails always included if present
      if (item.thumbnailUrl != null && item.thumbnailUrl!.isNotEmpty) {
        if (!instantThumbnails.contains(item.thumbnailUrl!)) {
          instantThumbnails.add(item.thumbnailUrl!);
        }
      }

      // 2. Media Paths (Local OR Remote)
      if (item.type == MediaType.photo) {
        instantImages.add(item.path);
      } else if (item.type == MediaType.video) {
        instantVideos.add(item.path); // 👑 COLLECT ALL
        
        // 👑 C++ THUMBNAIL EXTRACTION: 
        // If we don't have a thumbnail yet, run the engine to get a real .jpg frame!
        if (instantThumbnails.isEmpty) {
          final thumbPath = '${appDir.path}/t_opt_${newPostId}.jpg';
          debugPrint('🎬 [C++] Extracting optimistic thumbnail: $thumbPath');
          final success = await ChartNativeFFI().extractThumbnail(
            inputPath: item.path, 
            outputPath: thumbPath,
            timeSec: 1.0, // Grab frame at 1 second mark
            thumbWidth: 480, 
          );
          
          if (success && File(thumbPath).existsSync()) {
            instantThumbnails.add(thumbPath);
          } else {
            // Hard fallback to original path if processing fails
            instantThumbnails.add(item.path);
          }
        }
      } else if (item.type == MediaType.audio) {
        instantAudio = item.path;
      }
    }

    final entity = PostEntity.original(
      id: newPostId,
      authorId: user.id,
      authorUsername: user.username,
      authorDisplayName: user.displayName,
      authorAvatarUrl: user.profileImageUrl,
      createdAt: DateTime.now(),
      channelId: resolvedChannelId,
      channelName: resolvedChannelName,
      caption: caption,
      imageUrls: instantImages,
      thumbnailUrls: instantThumbnails,
      videoUrl: instantVideos.isNotEmpty ? instantVideos.first : null, // 👑 Fallback
      videoUrls: instantVideos, // 👑 MULTI-VIDEO SUPPORT
      audioUrl: instantAudio,
      isVideo: isVideo,
      isAudio: isAudio,
      folderName: folderName,
      aspectRatio: media.isNotEmpty ? (media.first.aspectRatio ?? 1.0) : 1.0,
      linkedPostId: resolvedLinkedPostId,
      linkedAuthorUsername: resolvedLinkedAuthorUsername,
      linkedCaption: resolvedLinkedCaption,
      linkedChannelId: resolvedLinkedChannelId,
      postType: postType,
      parentPostId: parentPostId,
      linkChain: finalChain,
      linkDepth: existingDepth + (resolvedLinkedPostId != null ? 1 : 0),
      isPublic: isPublicFeed,
      allowComments: allowComments,
      isPending: 1, // 👑 OPTIMISTIC FLAG
    );

    // 👑 STRICT SQLITE SHAPING
    String targetTable;
    Map<String, dynamic> localDbMap;

    if (isManifesto) {
      targetTable = 'manifestos';
      localDbMap = {
        'id': newPostId,
        'author_id': user.id,
        'username': user.username,
        'profile_image_url': user.profileImageUrl,
        'channel_id': resolvedChannelId,
        'caption': caption,
        'video_url': instantVideos.isNotEmpty ? instantVideos.first : null,
        'video_urls': jsonEncode(instantVideos),
        'image_urls': instantImages,
        'thumbnail_urls': instantThumbnails,
        'likes': 0,
        'comments': 0,
        'is_public': isPublicFeed ? 1 : 0,
        'allow_comments': allowComments ? 1 : 0,
        'isPending': 1,
      };
    } else if (isChannelContent && isCommentOrReply) {
      targetTable = 'manifesto_comments';
      localDbMap = {
        'id': newPostId,
        'author_id': user.id,
        'channel_id': resolvedChannelId,
        'manifesto_id': resolvedLinkedPostId,
        'message': caption,
        'image_urls': instantImages,
        'likes': 0,
        'isPending': 1,
      };
    } else {
      targetTable = 'posts';
      localDbMap = {
        'id': newPostId,
        'author_id': user.id,
        'username': user.username,
        'userProfileImageUrl': user.profileImageUrl ?? '',
        'channelName': resolvedChannelName,
        'channelId': resolvedChannelId,
        'caption': caption,
        'videoUrl': instantVideos.isNotEmpty ? instantVideos.first : '',
        'video_urls': jsonEncode(instantVideos),
        'sdVideoUrl': '',
        'audioUrl': instantAudio ?? '',
        'imageUrls': instantImages,
        'thumbnailUrls': instantThumbnails,
        'isVideo': isVideo ? 1 : 0,
        'isAudio': isAudio ? 1 : 0,
        'folder_name': folderName,
        'aspectRatio': media.isNotEmpty ? (media.first.aspectRatio ?? 1.0) : 1.0,
        'likes': 0,
        'comments': 0,
        'shares': 0,
        'isLiked': 0,
        'chartedCount': 0,
        'localFileCache': media.isNotEmpty ? media.first.path : '',
        'isPending': 1,
        'linked_post_id': resolvedLinkedPostId,
        'linked_author_username': resolvedLinkedAuthorUsername,
        'linked_caption': resolvedLinkedCaption,
        'linked_channel_id': resolvedLinkedChannelId,
        'post_type': postType,
        'parent_post_id': parentPostId,
        'link_chain': finalChain,
        'link_depth': existingDepth + (resolvedLinkedPostId != null ? 1 : 0),
        'is_public': isPublicFeed ? 1 : 0,
        'allow_comments': allowComments ? 1 : 0,
      };
    }

    return PostShapedData(
      entity: entity,
      localDbMap: localDbMap,
      folderName: folderName,
      targetTable: targetTable, // 👑 PASSED TO CONTROLLER
    );
  }

  /// 👑 2. CLOUDFLARE PUT (UPLOAD)
  /// Handles media processing (compression) and uploading to R2.
  Future<PostUploadResult> uploadMediaAssets({
    required String userId,
    required List<MediaItem> media,
    required String folderName,
    required List<String> existingThumbnails,
    void Function(int, int)? onProgress, // 👑 Added progress callback
  }) async {
    final appDir = await getTemporaryDirectory();
    final List<String> uploadedImageUrls = [];
    final List<String> hdVideoUrls = []; // 👑 PLURAL
    final List<String> sdVideoUrls = []; // 👑 PLURAL
    String? audioUrl;
    bool isVideo = false;
    bool isAudio = false;

    // Is it a direct repost where media is already URLs?
    final allLinked = media.isNotEmpty && media.every((m) => m.isLinked);

    if (!allLinked) {
      for (var i = 0; i < media.length; i++) {
        final item = media[i];
        if (item.type == MediaType.audio) {
          isAudio = true;
          // Compression
          final compressedPath = '${appDir.path}/v_${DateTime.now().millisecondsSinceEpoch}.m4a';
          final success = await ChartNativeFFI().compressAudio(inputPath: item.path, outputPath: compressedPath);
          final fileExists = File(compressedPath).existsSync();
          final fileSize = fileExists ? File(compressedPath).lengthSync() : 0;
          if (fileSize <= 1024) print('❌ CRITICAL: Audio Compression produced empty/invalid file. Reverting to original file!');
          final finalPath = (success && fileExists && fileSize > 1024) ? compressedPath : item.path;
          // Upload
          final url = await _cloudService.uploadMedia(File(finalPath), userId: userId, folderName: folderName, onProgress: onProgress);
          audioUrl ??= url;
          continue;
        }

        if (item.type == MediaType.video) {
          isVideo = true;
          
          final originalDb = (File(item.path).lengthSync() / (1024 * 1024)).toStringAsFixed(2);
          print('🎬 [UploadMedia] Original video size: $originalDb MB ($item.path)');
          
          final hdOut = '${appDir.path}/hd_${DateTime.now().millisecondsSinceEpoch}.mp4';
          final sdOut = '${appDir.path}/sd_${DateTime.now().millisecondsSinceEpoch}.mp4';
          
          print('⏳ [UploadMedia] Starting compression for HD output...');
          await ChartNativeFFI().compressVideo(inputPath: item.path, outputPath: hdOut);
          
          print('⏳ [UploadMedia] Starting compression for SD (Data Saver) output...');
          await ChartNativeFFI().compressVideo(inputPath: item.path, outputPath: sdOut, isDataSaver: true);

          final originalFileStr = File(item.path).lengthSync();
          final sdFileStr = File(sdOut).existsSync() ? File(sdOut).lengthSync() : originalFileStr + 1;
          final hdFileStr = File(hdOut).existsSync() ? File(hdOut).lengthSync() : originalFileStr + 1;

          final int thresholdBytes = 10 * 1024; // 10 KB minimum

          if (sdFileStr <= thresholdBytes) print('❌ CRITICAL: SD Compression produced empty/invalid file. Reverting to original!');
          if (hdFileStr <= thresholdBytes) print('❌ CRITICAL: HD Compression produced empty/invalid file. Reverting to original!');

          // 👑 SMART GUARDRAIL: If compression bloated the file, or produced empty shell, use original!
          final finalSd = (sdFileStr > thresholdBytes && sdFileStr <= originalFileStr) ? sdOut : item.path;
          final finalHd = (hdFileStr > thresholdBytes && hdFileStr <= originalFileStr) ? hdOut : item.path;

          final sdMb = (File(finalSd).lengthSync() / (1024 * 1024)).toStringAsFixed(2);
          final hdMb = (File(finalHd).lengthSync() / (1024 * 1024)).toStringAsFixed(2);
          
          print('✅ [UploadMedia] Compression fallback check complete.');
          if (finalHd == item.path) print('⚠️ HD Fallback: Using original file because compression failed/bloated it ($hdMb MB)');
          else print('📉 HD Compressed Size: $hdMb MB');
          
          if (finalSd == item.path) print('⚠️ SD Fallback: Using original file because compression failed/bloated it ($sdMb MB)');
          else print('📉 SD Compressed Size: $sdMb MB');

          print('☁️ [UploadMedia] Uploading SD version...');
          final resSd = await _cloudService.uploadMedia(File(finalSd), userId: userId, folderName: folderName, onProgress: onProgress);
          print('☁️ [UploadMedia] Uploading HD version...');
          final resHd = await _cloudService.uploadMedia(File(finalHd), userId: userId, folderName: folderName, onProgress: onProgress);
          
          if (resSd != null) sdVideoUrls.add(resSd);
          if (resHd != null) hdVideoUrls.add(resHd);
          continue;
        }

        if (item.type == MediaType.photo) {
          if (item.path.startsWith('http')) {
            uploadedImageUrls.add(item.path);
            continue;
          }
          
          final finalPath;
          if (item.path.contains('baked_')) {
            finalPath = item.path;
          } else {
            final crushedPath = '${appDir.path}/c_img_${DateTime.now().millisecondsSinceEpoch}.jpg';
            final success = await ChartNativeFFI().compressPhoto(inputPath: item.path, outputPath: crushedPath, width: 720);
            final fileExists = File(crushedPath).existsSync();
            final fileSize = fileExists ? File(crushedPath).lengthSync() : 0;
            if (fileSize <= 100) print('❌ CRITICAL: Photo Compression produced empty/invalid file. Reverting to original file!');
            finalPath = (success && fileExists && fileSize > 100) ? crushedPath : item.path;
          }
          
          final url = await _cloudService.uploadMedia(File(finalPath), userId: userId, folderName: folderName, onProgress: onProgress);
          if (url != null) uploadedImageUrls.add(url);
        }
      }
    } else {
      // Repost mapping
      for (var item in media) {
        if (item.type == MediaType.photo) uploadedImageUrls.add(item.path);
        else if (item.type == MediaType.video) { hdVideoUrls.add(item.path); isVideo = true; }
        else if (item.type == MediaType.audio) { audioUrl = item.path; isAudio = true; }
      }
    }

    // 👑 FIX: ACTUALLY UPLOAD THE THUMBNAILS TO CLOUDFLARE!
    List<String> uploadedThumbnails = [];
    final rawThumbnails = existingThumbnails.isNotEmpty 
        ? existingThumbnails 
        : media.where((m) => m.thumbnailUrl != null).map((m) => m.thumbnailUrl!).toList();

    for (String thumbPath in rawThumbnails) {
      if (thumbPath.startsWith('http')) {
        uploadedThumbnails.add(thumbPath); // It's already a web link (Repost)
      } else {
        // 👑 GUARDRAIL: Only upload actual image files as thumbnails!
        final lowerPath = thumbPath.toLowerCase();
        if (lowerPath.endsWith('.jpg') || lowerPath.endsWith('.jpeg') || lowerPath.endsWith('.png')) {
          debugPrint('☁️ [Cloudflare] Uploading thumbnail: $thumbPath');
          final thumbUrl = await _cloudService.uploadMedia(File(thumbPath), userId: userId, folderName: folderName, onProgress: onProgress);
          if (thumbUrl != null) uploadedThumbnails.add(thumbUrl);
        } else {
          debugPrint('⚠️ [Cloudflare] Skipping invalid thumbnail path: $thumbPath');
        }
      }
    }

    return PostUploadResult(
      imageUrls: uploadedImageUrls,
      hdVideoUrls: hdVideoUrls,
      sdVideoUrls: sdVideoUrls,
      audioUrl: audioUrl,
      thumbnails: uploadedThumbnails, 
      isVideo: isVideo,
      isAudio: isAudio,
    );
  }

  /// 👑 3. SUPABASE PUT (METADATA)
  /// Finalizes the post by inserting into Supabase.
  Future<void> finalizeSupabasePost({
    required PostEntity basePost,
    required PostUploadResult uploadResults,
    required String privacy,
    required String customRole,
    bool isPublicFeed = true, 
    bool allowComments = true,
    bool shareToStatus = false,
  }) async {
    // Merge base data with upload results
    final finalPost = basePost.copyWith(
      imageUrls: uploadResults.imageUrls,
      videoUrl: uploadResults.hdVideoUrls.isNotEmpty ? uploadResults.hdVideoUrls.first : null,
      videoUrls: uploadResults.hdVideoUrls,
      sdVideoUrl: uploadResults.sdVideoUrls.isNotEmpty ? uploadResults.sdVideoUrls.first : null,
      audioUrl: uploadResults.audioUrl,
      thumbnailUrls: uploadResults.thumbnails,
      isVideo: uploadResults.isVideo,
      isAudio: uploadResults.isAudio,
    );

    final result = await _repository.createPost(
      finalPost,
      folderName: basePost.folderName ?? 'public_posts',
      privacy: privacy,
      customRole: customRole,
      isPublicFeed: isPublicFeed,
      allowComments: allowComments,
      shareToStatus: shareToStatus,
    );

    await result.fold(
      (l) async {
        debugPrint('❌ [PostingService] Supabase insert FAILED: ${l.message}');
        throw Exception(l.message);
      },
      (r) async {
        debugPrint('✅ [PostingService] Supabase insert SUCCESS');
        // Update local DB
        await ChartNativeDB.instance.markPostSynced(basePost.id);
        final db = await ChartNativeDB.instance.database;

        // 👑 STRICT SQLITE ROUTING: Mutually Exclusive Tables
        final bool isChannelContent = basePost.channelId.isNotEmpty && basePost.channelId != 'general';

        if (isChannelContent) {
          // 🛣️ ROUTE A: CHANNEL
          final isCommentOrReply = basePost.postType == 'comment' || basePost.postType == 'reply';
          
          if (!isCommentOrReply) {
            // 👑 SYNC: If the row exists, we want to PRESERVE the current local comment count!
            final existing = await db.query('manifestos', where: 'id = ?', whereArgs: [basePost.id]);
            final int currentComments = existing.isNotEmpty ? (existing.first['comments'] as int? ?? 0) : 0;

            await db.insert('manifestos', {
              'id': basePost.id,
              'author_id': basePost.authorId,
              'username': basePost.authorUsername,
              'profile_image_url': basePost.authorAvatarUrl,
              'channel_id': basePost.channelId,
              'caption': basePost.caption,
              'video_url': uploadResults.hdVideoUrls.isNotEmpty ? uploadResults.hdVideoUrls.first : basePost.videoUrl,
              'video_urls': jsonEncode(uploadResults.hdVideoUrls.isNotEmpty ? uploadResults.hdVideoUrls : basePost.videoUrls),
              'image_urls': jsonEncode(uploadResults.imageUrls.isNotEmpty ? uploadResults.imageUrls : basePost.imageUrls),
              'thumbnail_urls': jsonEncode(uploadResults.thumbnails.isNotEmpty ? uploadResults.thumbnails : basePost.thumbnailUrls),
              'likes': 0,
              'comments': currentComments, // 🚀 PRESERVED
              'is_public': isPublicFeed ? 1 : 0, 
              'allow_comments': allowComments ? 1 : 0, 
              'isPending': 0,
            }, conflictAlgorithm: ConflictAlgorithm.replace);
          } else {
            await db.insert('manifesto_comments', {
              'id': basePost.id,
              'author_id': basePost.authorId,
              'channel_id': basePost.channelId,
              'manifesto_id': basePost.linkedPostId, 
              'message': basePost.caption,
              'image_urls': jsonEncode(uploadResults.imageUrls.isNotEmpty ? uploadResults.imageUrls : basePost.imageUrls),
              'likes': 0,
              'isPending': 0,
            }, conflictAlgorithm: ConflictAlgorithm.replace);
            
            // 👑 CONFIRMATION: Ensure count is accurate
            await ChartNativeDB.instance.incrementManifestoCommentCount(basePost.linkedPostId!);
          }
        } else {
          // 🛣️ ROUTE B: GENERAL POSTS (Only if not a channel)
          await db.insert('posts', {
            'id': basePost.id,
            'author_id': basePost.authorId,
            'username': basePost.authorUsername,
            'userProfileImageUrl': basePost.authorAvatarUrl,
            'caption': basePost.caption,
            'videoUrl': uploadResults.hdVideoUrls.isNotEmpty ? uploadResults.hdVideoUrls.first : '',
            'video_urls': jsonEncode(uploadResults.hdVideoUrls),
            'sdVideoUrl': uploadResults.sdVideoUrls.isNotEmpty ? uploadResults.sdVideoUrls.first : '',
            'audioUrl': uploadResults.audioUrl ?? '',
            'imageUrls': jsonEncode(uploadResults.imageUrls),
            'thumbnailUrls': jsonEncode(uploadResults.thumbnails),
            'isVideo': uploadResults.isVideo ? 1 : 0,
            'isAudio': uploadResults.isAudio ? 1 : 0,
            'folder_name': basePost.folderName ?? 'public_posts',
            'likes': 0,
            'comments': 0,
            'isPending': 0, // Cleared pending status
            'is_public': isPublicFeed ? 1 : 0,
            'allow_comments': allowComments ? 1 : 0,
          }, conflictAlgorithm: ConflictAlgorithm.replace);
        }
      },
    );
  }
}

class PostShapedData {
  final PostEntity entity;
  final Map<String, dynamic> localDbMap;
  final String folderName;
  final String targetTable; // 👑 NEW TARGET FIELD
  
  PostShapedData({
    required this.entity, 
    required this.localDbMap, 
    required this.folderName,
    required this.targetTable,
  });
}

class PostUploadResult {
  final List<String> imageUrls;
  final List<String> hdVideoUrls;
  final List<String> sdVideoUrls;
  final String? audioUrl;
  final List<String> thumbnails;
  final bool isVideo;
  final bool isAudio;

  PostUploadResult({
    required this.imageUrls,
    required this.hdVideoUrls,
    required this.sdVideoUrls,
    this.audioUrl,
    required this.thumbnails,
    required this.isVideo,
    required this.isAudio,
  });
}
