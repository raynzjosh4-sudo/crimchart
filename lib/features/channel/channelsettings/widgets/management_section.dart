import 'package:flutter/material.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../widgets/memberimage/starter_image.dart';
import '../../../newinsidechartstartpage/models/member.dart';

class ManagementSection extends StatelessWidget {
  final List<Member> followers;
  const ManagementSection({super.key, required this.followers});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${followers.length + 1} followers',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              Icon(
                LucideIcons.search,
                size: 16.sp,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
        _InviteTile(icon: LucideIcons.userPlus, title: 'Invite followers'),
        _InviteTile(icon: LucideIcons.plus, title: 'Invite admins'),

        // Your Profile (Owner)
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
          leading: MemberImage(
            size: 40.w,
            imageUrl: 'https://picsum.photos/seed/me/200',
          ),
          title: Text(
            'You',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            "You're not visible to followers",
            style: TextStyle(
              fontSize: 11.sp,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          trailing: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              'Owner',
              style: TextStyle(
                color: const Color(0xFFFFD700),
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
          child: Text(
            'You can only view individual followers who are contacts.',
            style: TextStyle(
              fontSize: 11.sp,
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ),
      ],
    );
  }
}

class _InviteTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const _InviteTile({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
      leading: Container(
        width: 40.w,
        height: 40.w,
        decoration: const BoxDecoration(
          color: Color(0xFFFFD700),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black, size: 20.sp),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
      ),
      onTap: () {},
    );
  }
}











