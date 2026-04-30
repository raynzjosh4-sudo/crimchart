import 'package:flutter/material.dart';
import 'package:crown/core/utils/responsive_size.dart';

class MediaLinksPreview extends StatelessWidget {
  final List<String> imageUrls;
  final String totalCount;

  const MediaLinksPreview({
    super.key,
    required this.imageUrls,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Media and links',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  Text(
                    totalCount,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 18.sp,
                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 80.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 80.h,
                  margin: EdgeInsets.only(right: 8.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    image: DecorationImage(
                      image: NetworkImage(imageUrls[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}











