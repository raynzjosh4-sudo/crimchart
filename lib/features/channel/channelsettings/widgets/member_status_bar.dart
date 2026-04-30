import 'package:flutter/material.dart';
import 'package:crown/core/utils/responsive_size.dart';
import '../../../widgets/memberimage/starter_image.dart';
import '../../../newinsidechartstartpage/models/member.dart';

class MemberStatusBar extends StatelessWidget {
  final List<Member> members;
  const MemberStatusBar({super.key, required this.members});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'MEMBER STATUSES',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 90.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  children: [
                    MemberImage(
                      size: 52.w,
                      imageUrl: member.avatarUrl,
                      borderWidth: 2.w,
                      showStatusRing: true,
                    ),
                    SizedBox(height: 6.h),
                    SizedBox(
                      width: 56.w,
                      child: Text(
                        member.name.split(' ').first,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface.withValues(alpha: 0.8),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}











