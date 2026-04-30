import 'widgets/mediatype/crown_media_type.dart';

class CrownModel {
  final String id;
  final String title;
  final String description;
  
  final String crownerId;
  final String crownerName;
  final String crownerImage;
  
  final bool isActive;
  final bool hasStatus;
  
  final List<CrownOptionModel> options;

  CrownModel({
    required this.id,
    required this.title,
    required this.description,
    required this.crownerId,
    required this.crownerName,
    required this.crownerImage,
    required this.options,
    this.isActive = true,
    this.hasStatus = false,
  });
}

class CrownOptionModel {
  final String id;
  final String description;
  final String? mediaUrl; 
  final CrownMediaType mediaType;
  final int crowns;       
  final bool isMe;

  final String? link;
  final String? crownedUserId;
  final String? crownedUserName;
  final String? crownedUserImage;

  CrownOptionModel({
    required this.id,
    required this.description,
    this.mediaUrl,
    this.mediaType = CrownMediaType.none,
    this.crowns = 0,
    this.isMe = false,
    this.link,
    this.crownedUserId,
    this.crownedUserName,
    this.crownedUserImage,
  });

  CrownOptionModel copyWith({
    int? crowns, 
    bool? isMe,
  }) {
    return CrownOptionModel(
      id: id,
      description: description,
      mediaUrl: mediaUrl,
      mediaType: mediaType,
      crowns: crowns ?? this.crowns,
      isMe: isMe ?? this.isMe,
      link: link,
      crownedUserId: crownedUserId,
      crownedUserName: crownedUserName,
      crownedUserImage: crownedUserImage,
    );
  }
}
