import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class TikTokVideoCard extends StatelessWidget {
  final int index;
  final int? textureId;
  final bool isPlaying;

  const TikTokVideoCard({
    super.key,
    required this.index,
    required this.textureId,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. The Video Background (Native Hardware Texture)
        Container(
          color: Colors.black,
          child: textureId != null
              ? Texture(textureId: textureId!)
              : Center(
                  child: CircularProgressIndicator(color: Colors.white54),
                ),
        ),

        // 2. Right Side Action Column
        Positioned(
          right: 4.w,
          bottom: 15.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Profile Avatar
              Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.0),
                  color: Colors.grey[800],
                ),
                child: Center(
                  child: Icon(Icons.person, color: Colors.white, size: 8.w),
                ),
              ),
              SizedBox(height: 6.h),
              
              // Like
              _buildActionIcon(LucideIcons.heart, "1"),
              
              // Share
              _buildActionIcon(LucideIcons.send, "0"),
              
              // Tag
              _buildActionIcon(LucideIcons.tag, "Tag"),
            ],
          ),
        ),

        // 3. Bottom Info Overlay
        Positioned(
          left: 4.w,
          bottom: 4.h,
          right: 20.w, // Leave room for right column
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Username & Verified
              Row(
                children: [
                  Text(
                    "User $index",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Icon(Icons.verified, color: Colors.orange, size: 16.sp),
                ],
              ),
              SizedBox(height: 2.h),
              
              // Caption
              Text(
                "This is the hardcore C++ zero-copy texture pipeline in action! 🥰😂 #performance",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.h),

              // Three Dots Button
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white70),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, color: Colors.white, size: 4.sp),
                    SizedBox(width: 1.w),
                    Icon(Icons.circle, color: Colors.white, size: 4.sp),
                    SizedBox(width: 1.w),
                    Icon(Icons.circle, color: Colors.white, size: 4.sp),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionIcon(IconData icon, String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.h),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(2.5.w),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 38.sp),
          ),
          SizedBox(height: 0.8.h),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
