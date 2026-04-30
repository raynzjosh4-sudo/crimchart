import '../../models/charter_model.dart';
import '../../dummydata/profile_dummy_data.dart';

final List<CharterModel> userPhotosData = List.generate(24, (index) {
  final heights = [400, 500, 600, 450, 550];
  final height = heights[index % heights.length];
  return CharterModel(
    id: 'img_$index',
    username: 'raynzjosh4',
    displayName: 'Raynz Josh',
    profileImageUrl: currentUserProfile.profileImageUrl,
    title: 'Post $index',
    category: 'Tech',
    mediaThumbnailUrl: 'https://picsum.photos/id/${index + 10}/400/$height',
  );
});





























