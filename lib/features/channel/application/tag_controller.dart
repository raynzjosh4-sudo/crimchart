import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection.dart';
import '../domain/repositories/tag_repository.dart';

/// A simple controller to handle the "Tag" action.
class TagController extends StateNotifier<AsyncValue<void>> {
  final TagRepository _repository;

  TagController(this._repository) : super(const AsyncData(null));

  Future<void> tagPost({
    required String postId,
    required String sourceChannelId,
    required String targetChannelId,
    required List<String> linkChain,
  }) async {
    state = const AsyncValue.loading();
    debugPrint('🏷️ [TagController] Tagging post: $postId');
    debugPrint(
      '🏷️ [TagController] Source: $sourceChannelId -> Target: $targetChannelId',
    );
    debugPrint('🏷️ [TagController] LinkChain: $linkChain');

    final result = await _repository.createTag(
      postId: postId,
      sourceChannelId: sourceChannelId,
      targetChannelId: targetChannelId,
      linkChain: linkChain,
    );

    result.fold(
      (l) {
        debugPrint('❌ [TagController] Failed to create tag: ${l.message}');
        state = AsyncValue.error(l, StackTrace.current);
      },
      (r) {
        debugPrint('✅ [TagController] Tag created successfully!');
        state = const AsyncValue.data(null);
      },
    );
  }
}

final tagControllerProvider =
    StateNotifierProvider<TagController, AsyncValue<void>>((ref) {
      return TagController(getIt<TagRepository>());
    });
