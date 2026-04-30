import '../../models/charter_model.dart';
import '../../dummydata/profile_dummy_data.dart';

final List<CharterModel> userAudioData = List.generate(
  12,
  (index) => CharterModel(
    id: 'audio_$index',
    username: 'raynzjosh4',
    displayName: 'Raynz Josh',
    profileImageUrl: currentUserProfile.profileImageUrl,
    title: 'Chart Anthem Vol. ${index + 1}',
    category: 'Music',
    isAudio: true,
    mediaThumbnailUrl: 'https://picsum.photos/id/${index + 120}/300/300',
    chartCount: 0,
  ),
);























