import '../features/cardwidgets/models/story_model.dart';

/// Dummy story data. In production, these would come from an API.
/// Each story maps to the '/stories' route which opens the story viewer.
const String storiesLink = '/stories';

final List<StoryModel> dummyStories = [
  StoryModel(
    id: 's1',
    username: 'Your story',
    userProfileImageUrl: 'https://i.pravatar.cc/150?img=1',
    hasUnviewedStatus: false,
  ),
  StoryModel(
    id: 's2',
    username: 'raynz.josh',
    userProfileImageUrl: 'https://i.pravatar.cc/150?img=2',
  ),
  StoryModel(
    id: 's3',
    username: 'alice_wonder',
    userProfileImageUrl: 'https://i.pravatar.cc/150?img=3',
    isLive: true,
  ),
  StoryModel(
    id: 's4',
    username: 'bob_builder',
    userProfileImageUrl: 'https://i.pravatar.cc/150?img=4',
  ),
  StoryModel(
    id: 's5',
    username: 'charlie_chaplin',
    userProfileImageUrl: 'https://i.pravatar.cc/150?img=5',
  ),
  StoryModel(
    id: 's6',
    username: 'diana_prince',
    userProfileImageUrl: 'https://i.pravatar.cc/150?img=6',
    hasUnviewedStatus: false,
  ),
];





























