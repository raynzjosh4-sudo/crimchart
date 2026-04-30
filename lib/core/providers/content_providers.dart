import 'package:crown/core/models/content_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Repository for content operations
abstract class ContentRepository {
  Future<List<ContentEntity>> getContentForChannel(String channelId);
  Future<ContentEntity?> getContentById(String contentId);
  Future<void> createContent(ContentEntity content);
  Future<void> updateContent(ContentEntity content);
  Future<void> deleteContent(String contentId);
}

// Content state management with Riverpod
class ContentNotifier extends StateNotifier<Map<String, ContentEntity>> {
  final ContentRepository _repository;

  ContentNotifier(this._repository) : super({});

  // Load content for a channel
  Future<void> loadChannelContent(String channelId) async {
    try {
      final content = await _repository.getContentForChannel(channelId);
      final contentMap = {for (final item in content) item.id: item};
      state = {...state, ...contentMap};
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  // Get content by ID
  ContentEntity? getContent(String contentId) {
    return state[contentId];
  }

  // Add or update content
  void updateContent(ContentEntity content) {
    state = {...state, content.id: content};
  }

  // Remove content
  void removeContent(String contentId) {
    final newState = Map<String, ContentEntity>.from(state);
    newState.remove(contentId);
    state = newState;
  }
}

// Providers
final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  // This would be implemented with your API client
  return ContentRepositoryImpl();
});

final contentNotifierProvider =
    StateNotifierProvider<ContentNotifier, Map<String, ContentEntity>>((ref) {
      final repository = ref.watch(contentRepositoryProvider);
      return ContentNotifier(repository);
    });

// Provider for getting content by ID
final contentByIdProvider = Provider.family<ContentEntity?, String>((
  ref,
  contentId,
) {
  final contentMap = ref.watch(contentNotifierProvider);
  return contentMap[contentId];
});

// Provider for channel content
final channelContentProvider =
    FutureProvider.family<List<ContentEntity>, String>((ref, channelId) async {
      final repository = ref.watch(contentRepositoryProvider);
      return repository.getContentForChannel(channelId);
    });

// Provider for content creation
final createContentProvider = FutureProvider.family<void, ContentEntity>((
  ref,
  content,
) async {
  final repository = ref.watch(contentRepositoryProvider);
  await repository.createContent(content);
});

// Thumbnail link provider for navigation
final thumbnailLinkNavigationProvider = Provider<void Function(ThumbnailLink)>((
  ref,
) {
  return (ThumbnailLink link) {
    // Navigate to the original content
    // This would integrate with your router
    // ref.read(routerProvider).go('/content/${link.originalContentId}');
  };
});

// Implementation (would be in a separate file)
class ContentRepositoryImpl implements ContentRepository {
  ContentRepositoryImpl();

  @override
  Future<List<ContentEntity>> getContentForChannel(String channelId) async {
    // Implementation would call your API
    throw UnimplementedError();
  }

  @override
  Future<ContentEntity?> getContentById(String contentId) async {
    // Implementation would call your API
    throw UnimplementedError();
  }

  @override
  Future<void> createContent(ContentEntity content) async {
    // Implementation would call your API
    throw UnimplementedError();
  }

  @override
  Future<void> updateContent(ContentEntity content) async {
    // Implementation would call your API
    throw UnimplementedError();
  }

  @override
  Future<void> deleteContent(String contentId) async {
    // Implementation would call your API
    throw UnimplementedError();
  }
}

// Placeholder for API client
class ApiClient {}

// Provider for API client (would be implemented)
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});











