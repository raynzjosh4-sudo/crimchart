import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import '../memberimage/starter_image.dart';

class TikTokCommentTile extends StatelessWidget {
  final String username;
  final String message;
  final String? avatarUrl;
  final String date;
  final int likes;
  final bool isLiked;
  final VoidCallback? onLike;
  final VoidCallback? onReply;
  final VoidCallback? onAvatarTap;

  const TikTokCommentTile({
    super.key,
    required this.username,
    required this.message,
    this.avatarUrl,
    this.date = 'now',
    this.likes = 0,
    this.isLiked = false,
    this.onLike,
    this.onReply,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Avatar ──
          GestureDetector(
            onTap: onAvatarTap,
            child: MemberImage(
              size: 36.w,
              imageUrl:
                  avatarUrl ??
                  'https://picsum.photos/seed/${username.hashCode}/100',
              showActiveDot: false,
              borderWidth: 0,
            ),
          ),
          SizedBox(width: 12.w),

          // ── Content ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Text(
                      date,
                      style: TextStyle(color: Colors.white38, fontSize: 12.sp),
                    ),
                    SizedBox(width: 16.w),
                    GestureDetector(
                      onTap: onReply,
                      child: Text(
                        'Reply',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Like Action ──
          Column(
            children: [
              GestureDetector(
                onTap: onLike,
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  size: 20.sp,
                  color: isLiked ? Colors.red : Colors.white38,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                likes > 0 ? likes.toString() : '',
                style: TextStyle(color: Colors.white38, fontSize: 11.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
