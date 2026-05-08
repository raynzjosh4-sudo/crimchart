import 'package:flutter/material.dart';
import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/core/utils/responsive_size.dart';

import 'package:lucide_icons/lucide_icons.dart';
import 'channel_invite_page.dart';

class ChannelCreationSettingsPage extends StatefulWidget {
  const ChannelCreationSettingsPage({super.key});

  @override
  State<ChannelCreationSettingsPage> createState() =>
      _ChannelCreationSettingsPageState();
}

class _ChannelCreationSettingsPageState
    extends State<ChannelCreationSettingsPage> {
  bool _membersOtherChannels = false;
  bool _membersFollowing = true;
  String _joinMethod = 'invite'; // 'invite' or 'anyone'
  bool _preventLeaving = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const ChartAppBar(
        title: 'CHANNEL SETTINGS',
        showBack: true,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Set who can see your channel', colorScheme),
              _buildActionTile('Age', '18+', LucideIcons.calendar, colorScheme),
              _buildToggleTile(
                'Members in my other channels',
                _membersOtherChannels,
                (val) => setState(() => _membersOtherChannels = val),
                colorScheme,
              ),
              _buildToggleTile(
                'Members am following',
                _membersFollowing,
                (val) => setState(() => _membersFollowing = val),
                colorScheme,
              ),

              SizedBox(height: 24.h),
              _buildSectionHeader(
                'How can people join this channel',
                colorScheme,
              ),
              _buildRadioTile(
                'By sending invitation request',
                'invite',
                _joinMethod,
                (val) => setState(() => _joinMethod = val!),
                colorScheme,
              ),
              _buildRadioTile(
                'Anyone can join it',
                'anyone',
                _joinMethod,
                (val) => setState(() => _joinMethod = val!),
                colorScheme,
              ),

              SizedBox(height: 24.h),
              _buildSectionHeader('Global Restrictions', colorScheme),
              _buildActionTile(
                'Which country is allowed to participate',
                'Global',
                LucideIcons.globe,
                colorScheme,
              ),
              _buildToggleTile(
                'Allow members who joined not to leave, unless sent a leaving thing',
                _preventLeaving,
                (val) => setState(() => _preventLeaving = val),
                colorScheme,
              ),

              SizedBox(height: 48.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ChannelInvitePage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    minimumSize: Size(double.infinity, 56.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'NEXT',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 48.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 12.h),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: colorScheme.primary.withValues(alpha: 0.8),
          fontSize: 12.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildToggleTile(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
    ColorScheme colorScheme,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
      title: Text(
        title,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: colorScheme.primary,
      ),
      onTap: () => onChanged(!value),
    );
  }

  Widget _buildRadioTile(
    String title,
    String value,
    String groupValue,
    ValueChanged<String?> onChanged,
    ColorScheme colorScheme,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 0.h),
      title: Text(
        title,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Radio<String>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: colorScheme.primary,
      ),
      onTap: () => onChanged(value),
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    ColorScheme colorScheme,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
      title: Text(
        title,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            subtitle,
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 8.w),
          Icon(
            LucideIcons.chevronRight,
            size: 20.sp,
            color: colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ],
      ),
      onTap: () {
        // Open actionable modal/dropdown here in the future
      },
    );
  }
}











