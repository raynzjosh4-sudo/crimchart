import 'package:flutter/material.dart';
import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'exportsettings.dart';

class FollowInvitePage extends StatefulWidget {
  const FollowInvitePage({super.key});

  @override
  State<FollowInvitePage> createState() => _FollowInvitePageState();
}

class _FollowInvitePageState extends State<FollowInvitePage> {
  bool _autoConfirm = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(title: context.tr('join_and_invite')),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          _buildSectionHeader(context, context.tr('members_section')),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  context.tr('auto_confirm'),
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: _autoConfirm,
                  onChanged: (val) => setState(() => _autoConfirm = val),
                  activeThumbColor: colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            context.tr('auto_confirm_desc'),
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.5),
              fontSize: 13.sp,
              height: 1.4,
            ),
          ),
          SizedBox(height: 32.h),
          _buildSectionHeader(context, context.tr('invite_friends')),
          _buildInviteItem(
            context,
            LucideIcons.mail,
            context.tr('invite_email'),
          ),
          _buildInviteItem(
            context,
            LucideIcons.messageSquare,
            context.tr('invite_sms'),
          ),
          _buildInviteItem(
            context,
            LucideIcons.share2,
            context.tr('invite_more'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInviteItem(BuildContext context, IconData icon, String title) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      onTap: () {},
      leading: Icon(icon, color: colorScheme.onSurface),
      title: Text(
        title,
        style: TextStyle(color: colorScheme.onSurface, fontSize: 15.sp),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}











