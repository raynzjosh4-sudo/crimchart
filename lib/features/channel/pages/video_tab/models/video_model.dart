class VideoItem {
  final String id;
  final String thumbnailUrl;
  final String videoUrl;
  final String creatorName;
  final bool isVerified;
  final List<String> hashtags;

  const VideoItem({
    required this.id,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.creatorName,
    this.isVerified = false,
    this.hashtags = const [],
  });
}

class DummyVideoData {
  static const List<VideoItem> videos = [
    VideoItem(
      id: '1',
      thumbnailUrl: 'https://picsum.photos/seed/v1/400/600',
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      creatorName: 'Johny Mitchell',
      isVerified: true,
      hashtags: ['#viral', '#trending', '#travel'],
    ),
    VideoItem(
      id: '2',
      thumbnailUrl: 'https://picsum.photos/seed/v2/400/500',
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      creatorName: 'Johny Mitchell',
      isVerified: true,
      hashtags: ['#viral', '#trending', '#vibe'],
    ),
    VideoItem(
      id: '3',
      thumbnailUrl: 'https://picsum.photos/seed/v3/400/700',
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      creatorName: 'Johny Mitchell',
      isVerified: true,
      hashtags: ['#viral', '#trending', '#music'],
    ),
    VideoItem(
      id: '4',
      thumbnailUrl: 'https://picsum.photos/seed/v4/400/400',
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      creatorName: 'Johny Mitchell',
      isVerified: true,
      hashtags: ['#viral', '#trending', '#art'],
    ),
    VideoItem(
      id: '5',
      thumbnailUrl: 'https://picsum.photos/seed/v5/400/800',
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      creatorName: 'Johny Mitchell',
      isVerified: true,
      hashtags: ['#viral', '#trending', '#fashion'],
    ),
    VideoItem(
      id: '6',
      thumbnailUrl: 'https://picsum.photos/seed/v6/400/550',
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      creatorName: 'Johny Mitchell',
      isVerified: true,
      hashtags: ['#viral', '#trending', '#vlog'],
    ),
  ];
}
