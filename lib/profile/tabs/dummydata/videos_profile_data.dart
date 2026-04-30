import '../../models/charter_model.dart';
import '../../dummydata/profile_dummy_data.dart';

final List<CharterModel> userVideosData = List.generate(18, (index) => CharterModel(
  id: 'vid_$index',
  username: 'raynzjosh4',
  displayName: 'Raynz Josh',
  profileImageUrl: currentUserProfile.profileImageUrl,
  title: 'Video $index',
  category: 'Tech',
  isVideo: true,
  mediaThumbnailUrl: 'https://picsum.photos/id/${index + 60}/400/700', // Video vertical feel
));





























