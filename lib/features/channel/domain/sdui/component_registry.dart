import 'package:crown/features/channel/pages/discovery_widgets/cards/status_card_component.dart';
import 'package:crown/features/channel/pages/discovery_widgets/cards/status_card_carousel_component.dart';
import 'package:crown/features/channel/pages/discovery_widgets/cards/user_profile_card_component.dart';
import 'package:crown/features/channel/pages/discovery_widgets/cards/premium_post_component.dart';
import 'feed_component.dart';
import 'fallback_components.dart';

class ComponentRegistry {
  static FeedComponent fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;
    final data = json['data'] as Map<String, dynamic>? ?? {};

    try {
      switch (type) {
        case 'status_card_item':
          return StatusCardComponent(
            imageUrl: data['image_url'] ?? '',
            views: data['views'] ?? '',
          );
        case 'status_card_carousel':
          final cardsList = (data['cards'] as List<dynamic>? ?? []).map((cardJson) {
             return ComponentRegistry.fromJson(cardJson as Map<String, dynamic>);
          }).toList();
          return StatusCardCarouselComponent(cards: cardsList);
        case 'user_profile_card':
          return UserProfileCardComponent(
            name: data['name'] ?? '',
            username: data['username'] ?? '',
            profileImageUrl: data['profile_image_url'] ?? '',
            isVerified: data['is_verified'] ?? true,
            isFollowing: data['is_following'] ?? true,
          );
        case 'premium_post':
          return PremiumPostComponent(
            authorName: data['author_name'] ?? '',
            authorImageUrl: data['author_image_url'] ?? '',
            timeAgo: data['time_ago'] ?? '',
            backgroundImageUrl: data['background_image_url'] ?? '',
            caption: data['caption'] ?? '',
            likesCount: data['likes_count'] ?? '0',
            commentsCount: data['comments_count'] ?? '0',
            savesCount: data['saves_count'] ?? '0',
          );
        // We will add more blocks here as the app scales
        default:
          return const UnknownComponent();
      }
    } catch (e) {
      // Crucial: If parsing fails, don't crash the app. Return a fallback.
      return CorruptedComponentError(error: e.toString());
    }
  }
}
