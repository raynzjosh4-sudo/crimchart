import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/core/widgets/chart_image.dart';
import '../memberimage/starter_image.dart';

class ManifestoChatBubble extends StatelessWidget {
  final String username;
  final String message;
  final String? avatarUrl;
  final Color themeColor;
  final bool isMe;
  final bool isOnline;
  final List<String> imageUrls;
  final VoidCallback? onLongPress; // 👑 Long-press → delete sheet
  final VoidCallback? onAvatarTap; // 👑 Avatar tap → profile page

  const ManifestoChatBubble({
    super.key,
    required this.username,
    required this.message,
    this.avatarUrl,
    required this.themeColor,
    this.isMe = false,
    this.isOnline = false,
    this.imageUrls = const [],
    this.onLongPress,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    // 👑 Premium Asymmetric Bubble BorderRadius
    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(isMe ? 16.r : 4.r),
      topRight: Radius.circular(isMe ? 4.r : 16.r),
      bottomLeft: Radius.circular(16.r),
      bottomRight: Radius.circular(16.r),
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── LEFT AVATAR (For Others) ──
          if (!isMe) ...[
            GestureDetector(
              onTap: onAvatarTap,
              child: MemberImage(
                size: 34.w,
                imageUrl:
                    avatarUrl ??
                    'https://picsum.photos/seed/${username.hashCode}/100',
                showActiveDot: isOnline,
                borderWidth: 1.w,
              ),
            ),
            SizedBox(width: 10.w),
          ],

          // ── THE BUBBLE & USERNAME ──
          Flexible(
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                // ── USERNAME ──
                Padding(
                  padding: EdgeInsets.only(
                    left: isMe ? 0 : 4.w,
                    right: isMe ? 4.w : 0,
                    bottom: 2.h,
                  ),
                  child: Text(
                    username,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w900,
                      color: isMe ? themeColor : Colors.white70,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                // ── MESSAGE BODY ──
                GestureDetector(
                  onLongPress: onLongPress,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.sizeOf(context).width * 0.75,
                      minWidth: 100.w,
                      minHeight: 40.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: borderRadius,
                      border: Border.all(
                        color: isMe
                            ? themeColor.withValues(alpha: 0.4)
                            : Colors.white10,
                        width: 0.5,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── IMAGES GRID ──
                        if (imageUrls.isNotEmpty) _buildImageGrid(),

                        // ── TEXT MESSAGE ──
                        if (message.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 10.h,
                            ),
                            child: Text(
                              message,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 14.sp,
                                height: 1.4,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── RIGHT AVATAR (For Me) ──
          if (isMe) ...[
            SizedBox(width: 10.w),
            GestureDetector(
              onTap: onAvatarTap,
              child: MemberImage(
                size: 34.w,
                imageUrl:
                    avatarUrl ??
                    'https://picsum.photos/seed/${username.hashCode}/100',
                showActiveDot: isOnline,
                borderWidth: 1.w,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImageGrid() {
    if (imageUrls.length == 1) {
      return SizedBox(
        height: 200.h,
        width: double.infinity,
        child: _buildSingleImage(imageUrls.first),
      );
    }

    return Container(
      constraints: BoxConstraints(maxHeight: 250.h),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: imageUrls.length == 2 ? 2 : 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: imageUrls.length,
        itemBuilder: (context, index) => _buildSingleImage(imageUrls[index]),
      ),
    );
  }

  Widget _buildSingleImage(String path) {
    return ChartImage(url: path, fit: BoxFit.cover, width: double.infinity);
  }
}
