import '../models/comment_model.dart';

final List<VideoComment> dummyVideoComments = [
  VideoComment(
    id: '1',
    username: 'PAatty1783',
    userAvatarUrl: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Patty',
    text: 'The Amazon account and Pinterest bus account asks for a website... Where would I get that?',
    timeAgo: '3d',
    likes: 4,
    replies: [
      VideoComment(
        id: '1-1',
        username: 'callmekevy',
        userAvatarUrl: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Kevin',
        text: 'You don\'t have to add a URL on Pinterest, on Amazon add the url to your Pinterest bio page.',
        timeAgo: '3d',
        isCreator: true,
        likes: 1,
      ),
    ],
  ),
  VideoComment(
    id: '2',
    username: 'raj',
    userAvatarUrl: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Raj',
    text: 'sir can I do it from nepal and if so can I withdraw my money directly to my account',
    timeAgo: '3d',
    likes: 5,
    replies: [
      VideoComment(
        id: '2-1',
        username: 'callmekevy',
        userAvatarUrl: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Kevin',
        text: 'I\'m not sure if it\'s available in your area, but the easiest way to find out is to sign up for Amazon Associates. Then try to link your bank so you can get paid.',
        timeAgo: '2d',
        isCreator: true,
        likes: 0,
      ),
    ],
  ),
  VideoComment(
    id: '3',
    username: 'sarah_j',
    userAvatarUrl: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Sarah',
    text: 'This is actually so helpful, thank you for sharing!',
    timeAgo: '1d',
    likes: 12,
  ),
];





























