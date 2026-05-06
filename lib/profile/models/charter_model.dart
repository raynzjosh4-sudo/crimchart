/// Represents a single Top or Star profile shown in the horizontal feed card.
class CharterModel {
  final String id;
  final String username;
  final String displayName;
  final String profileImageUrl;
  final String title; // e.g. 'Top', 'Star'
  final String category; // e.g. 'Rap', 'Chess', 'Art'
  final int chartCount;
  final int channelCount;
  final bool isVideo;
  final String? videoUrl;
  final bool isAudio;
  final String? audioUrl;
  final String? mediaThumbnailUrl;
  final String? bio;
  final int giftsEarned;
  final int coinsEarned;
  final String? currentChartName;
  final List<CharterModel> competitors;
  final bool hasStatus;
  final bool isActive;
  final List<String> imageUrls;
  final String? folderName;
  final int isPending;
  final String localFileCache;
  final String role; // e.g. 'admin', 'member', 'owner'
  final bool isMe;

  const CharterModel({
    required this.id,
    required this.username,
    required this.displayName,
    required this.profileImageUrl,
    required this.title,
    required this.category,
    this.chartCount = 0,
    this.channelCount = 0,
    this.isVideo = false,
    this.videoUrl,
    this.isAudio = false,
    this.audioUrl,
    this.mediaThumbnailUrl,
    this.bio,
    this.giftsEarned = 0,
    this.coinsEarned = 0,
    this.currentChartName,
    this.competitors = const [],
    this.hasStatus = false,
    this.isActive = false,
    this.imageUrls = const [],
    this.folderName,
    this.isPending = 0,
    this.localFileCache = '',
    this.role = '',
    this.isMe = false,
  });

  CharterModel copyWith({
    String? id,
    String? username,
    String? displayName,
    String? profileImageUrl,
    String? title,
    String? category,
    int? chartCount,
    int? channelCount,
    bool? isVideo,
    String? videoUrl,
    bool? isAudio,
    String? audioUrl,
    String? mediaThumbnailUrl,
    String? bio,
    int? giftsEarned,
    int? coinsEarned,
    String? currentChartName,
    List<CharterModel>? competitors,
    bool? hasStatus,
    bool? isActive,
    List<String>? imageUrls,
    String? folderName,
    int? isPending,
    String? localFileCache,
    String? role,
    bool? isMe,
  }) {
    return CharterModel(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      title: title ?? this.title,
      category: category ?? this.category,
      chartCount: chartCount ?? this.chartCount,
      channelCount: channelCount ?? this.channelCount,
      isVideo: isVideo ?? this.isVideo,
      videoUrl: videoUrl ?? this.videoUrl,
      isAudio: isAudio ?? this.isAudio,
      audioUrl: audioUrl ?? this.audioUrl,
      mediaThumbnailUrl: mediaThumbnailUrl ?? this.mediaThumbnailUrl,
      bio: bio ?? this.bio,
      giftsEarned: giftsEarned ?? this.giftsEarned,
      coinsEarned: coinsEarned ?? this.coinsEarned,
      currentChartName: currentChartName ?? this.currentChartName,
      competitors: competitors ?? this.competitors,
      hasStatus: hasStatus ?? this.hasStatus,
      isActive: isActive ?? this.isActive,
      imageUrls: imageUrls ?? this.imageUrls,
      folderName: folderName ?? this.folderName,
      isPending: isPending ?? this.isPending,
      localFileCache: localFileCache ?? this.localFileCache,
      role: role ?? this.role,
      isMe: isMe ?? this.isMe,
    );
  }
}
























