class StoryModel {
  final String id;
  final String username;
  final String userProfileImageUrl;
  final bool isLive;
  final bool hasUnviewedStatus;
  final bool isChartable;
  final bool isPublic;

  StoryModel({
    required this.id,
    required this.username,
    required this.userProfileImageUrl,
    this.isLive = false,
    this.hasUnviewedStatus = true,
    this.isChartable = true,
    this.isPublic = true,
  });
}





























