import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/memberimage/starter_image.dart';
import '../../../../newinsidechartstartpage/models/member.dart';

class MemberListTile extends StatelessWidget {
  final Member member;

  const MemberListTile({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      leading: MemberImage(
        size: 50.w,
        imageUrl: member.avatarUrl,
        borderWidth: 1.w,
        showStatusRing: true,
        showActiveDot: false,
      ),
      title: Text(
        member.name,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        '${member.channelsCount} channels',
        style: TextStyle(
          fontSize: 12.sp,
          color: colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: colorScheme.onSurface.withValues(alpha: 0.1),
            width: 0.5,
          ),
        ),
        child: Text(
          'View Profile',
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }
}











