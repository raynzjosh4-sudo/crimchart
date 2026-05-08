import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/native/chart_native_ffi.dart';
import '../../../../core/network/cloud_media_service.dart';
import '../../../../core/di/injection.dart';
import '../domain/repositories/channel_repository.dart';

enum ChannelCreationStatus { idle, processing, success, error }

class ChannelCreationState {
  final ChannelCreationStatus status;
  final String? error;

  ChannelCreationState({required this.status, this.error});
}

final channelCreationControllerProvider =
    StateNotifierProvider<ChannelCreationController, ChannelCreationState>((
      ref,
    ) {
      final repo = getIt<ChannelRepository>();
      final cloud = getIt<CloudMediaService>();
      return ChannelCreationController(repo, cloud);
    });

class ChannelCreationController extends StateNotifier<ChannelCreationState> {
  final ChannelRepository _repository;
  final CloudMediaService _cloudService;

  ChannelCreationController(this._repository, this._cloudService)
    : super(ChannelCreationState(status: ChannelCreationStatus.idle));

  Future<void> createChannel({
    required String name,
    required String description,
    required String? mediaPath,
    required String ageRestriction,
    required bool membersOtherChannels,
    required bool membersFollowing,
    required String joinMethod,
    required bool preventLeaving,
    required List<String> countryRestrictions,
    required String allowCommentingBy,
  }) async {
    print('📦 CONTROLLER: Received create request for "$name"');
    state = ChannelCreationState(status: ChannelCreationStatus.processing);

    try {
      final supabase = Supabase.instance.client;
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) throw Exception('User is not logged in.');

      String? finalCloudflareUrl;

      // 👑 1. CLOUDFLARE UPLOAD FIRST (With C++ Compression)
      if (mediaPath != null && mediaPath.isNotEmpty) {
        if (mediaPath.startsWith('http')) {
          finalCloudflareUrl = mediaPath;
        } else {
          print(
            '🖼️ CONTROLLER: Compressing channel avatar via Native Engine...',
          );
          final appDir = await getTemporaryDirectory();
          final crushedImagePath =
              '${appDir.path}/ch_avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';

          // 👑 NATIVE COMPRESSION PIPELINE (C++ FFI)
          final success = await ChartNativeFFI().compressPhoto(
            inputPath: mediaPath,
            outputPath: crushedImagePath,
            width: 600, // Balanced for avatar quality/speed
          );

          final fileToUpload = success
              ? File(crushedImagePath)
              : File(mediaPath);

          print(
            '📤 CONTROLLER: Uploading avatar to Cloudflare (Folder: channel_avatars)...',
          );
          finalCloudflareUrl = await _cloudService.uploadMedia(
            fileToUpload,
            userId: currentUserId,
            folderName: 'channel_avatars',
          );
        }
      }

      // 👑 2. PACKAGE DATA
      final channelData = {
        'name': name,
        'description': description,
        'ageRestriction': ageRestriction,
        'membersOtherChannels': membersOtherChannels,
        'membersFollowing': membersFollowing,
        'join_method': joinMethod,
        'joinMethod': joinMethod,
        'preventLeaving': preventLeaving,
        'countryRestrictions': countryRestrictions,
        'allowCommentingBy': allowCommentingBy,
      };

      // 👑 3. SAVE TO SUPABASE (METADATA ONLY)
      final result = await _repository.createChannel(
        channelData,
        avatarUrl: finalCloudflareUrl,
      );

      result.fold(
        (failure) {
          state = ChannelCreationState(
            status: ChannelCreationStatus.error,
            error: failure.message,
          );
        },
        (newChannel) async {
          state = ChannelCreationState(status: ChannelCreationStatus.success);
        },
      );
    } catch (e) {
      print('⛔ CONTROLLER CRITICAL ERROR: $e');
      state = ChannelCreationState(
        status: ChannelCreationStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> editChannel({
    required String channelId,
    required String name,
    required String description,
    required String? newMediaPath,
    required String? oldCloudflareUrl,
  }) async {
    print('📦 CONTROLLER: Received edit request for "$name"');
    state = ChannelCreationState(status: ChannelCreationStatus.processing);

    try {
      final supabase = Supabase.instance.client;
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) throw Exception('User is not logged in.');

      String? finalCloudflareUrl;

      if (newMediaPath != null && newMediaPath.isNotEmpty) {
        if (newMediaPath.startsWith('http')) {
          finalCloudflareUrl = newMediaPath;
        } else {
          print(
            '🖼️ CONTROLLER: Compressing new channel avatar via Native Engine...',
          );
          final appDir = await getTemporaryDirectory();
          final crushedImagePath =
              '${appDir.path}/ch_avatar_edit_${DateTime.now().millisecondsSinceEpoch}.jpg';

          final success = await ChartNativeFFI().compressPhoto(
            inputPath: newMediaPath,
            outputPath: crushedImagePath,
            width: 600,
          );

          final fileToUpload = success
              ? File(crushedImagePath)
              : File(newMediaPath);

          print('📤 CONTROLLER: Uploading new avatar to Cloudflare...');
          finalCloudflareUrl = await _cloudService.uploadMedia(
            fileToUpload,
            userId: currentUserId,
            folderName: 'channel_avatars',
          );
        }
      }

      // 👑 1.5 AUTO-UPGRADE LEGACY URLS (Rebrand fix)
      // We perform this even if finalCloudflareUrl was just set from an 'http' newMediaPath.
      if (finalCloudflareUrl != null && finalCloudflareUrl.isNotEmpty) {
        var corrected = finalCloudflareUrl.replaceFirst(
          '/channel-profiles/',
          '/channel_avatars/',
        );

        if (corrected.contains('crown.nexassearch.com/') &&
            !corrected.contains('crown.nexassearch.com/users/')) {
          corrected = corrected.replaceFirst(
            'crown.nexassearch.com/',
            'crown.nexassearch.com/users/',
          );
        }

        if (corrected != finalCloudflareUrl) {
          print('👑 AUTO-UPGRADING Legacy URL to: $corrected');
          finalCloudflareUrl = corrected;
        }
      } else if (oldCloudflareUrl != null && oldCloudflareUrl.isNotEmpty) {
        // If no new image picked, check if the old one needs fixing
        var corrected = oldCloudflareUrl.replaceFirst(
          '/channel-profiles/',
          '/channel_avatars/',
        );

        if (corrected.contains('crown.nexassearch.com/') &&
            !corrected.contains('crown.nexassearch.com/users/')) {
          corrected = corrected.replaceFirst(
            'crown.nexassearch.com/',
            'crown.nexassearch.com/users/',
          );
        }

        if (corrected != oldCloudflareUrl) {
          print('👑 AUTO-UPGRADING Old Legacy URL to: $corrected');
          finalCloudflareUrl = corrected;
        }
      }

      // 👑 2. PACKAGE DATA
      final channelData = {'name': name, 'description': description};

      // 👑 3. SAVE TO SUPABASE
      final result = await _repository.updateChannel(
        channelId,
        channelData,
        avatarUrl: finalCloudflareUrl,
      );

      result.fold(
        (failure) {
          state = ChannelCreationState(
            status: ChannelCreationStatus.error,
            error: failure.message,
          );
        },
        (updatedChannel) async {
          state = ChannelCreationState(status: ChannelCreationStatus.success);
        },
      );
    } catch (e) {
      print('⛔ CONTROLLER CRITICAL ERROR: $e');
      state = ChannelCreationState(
        status: ChannelCreationStatus.error,
        error: e.toString(),
      );
    }
  }
}
