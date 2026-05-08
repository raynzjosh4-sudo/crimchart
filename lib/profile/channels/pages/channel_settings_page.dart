import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/features/allchannels/models/chart_channel.dart';
import 'package:flutter/material.dart';

class ChannelSettingsPage extends StatefulWidget {
  final ChartChannel channel;

  const ChannelSettingsPage({super.key, required this.channel});

  @override
  State<ChannelSettingsPage> createState() => _ChannelSettingsPageState();
}

class _ChannelSettingsPageState extends State<ChannelSettingsPage> {
  // Settings state
  bool _isPrivate = true;
  String _inviteMode = 'request_to_join';
  bool _dataPrivate = false;
  bool _showGiftsToMember = true;
  bool _allowGifting = true;
  bool _allowMedia = true;
  String _slowMode = 'off';
  String _contentFilter = 'medium';
  String _notifications = 'all';
  String _category = 'community';
  bool _isDiscoverable = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final backgroundColor = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: ChartAppBar(
        title: context.tr('channel_settings_title'),
        backgroundColor: backgroundColor,
        titleStyle: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w900,
          fontSize: 16.sp,
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          _buildHeader(context.tr('general_settings')),
          _buildSwitchTile(
            context.tr('private_channel'),
            _isPrivate,
            (v) => setState(() => _isPrivate = v),
          ),
          _buildDropdownTile(
            context.tr('invite_mode'),
            _inviteMode,
            ['open_to_all', 'request_to_join'],
            (v) => setState(() => _inviteMode = v!),
          ),
          _buildSwitchTile(
            context.tr('discoverable'),
            _isDiscoverable,
            (v) => setState(() => _isDiscoverable = v),
          ),
          _buildDropdownTile(context.tr('category'), _category, [
            'community',
            'tech',
            'art',
            'gaming',
            'music',
          ], (v) => setState(() => _category = v!)),

          _buildHeader(context.tr('privacy_data')),
          _buildSwitchTile(
            context.tr('private_data_mode'),
            _dataPrivate,
            (v) => setState(() => _dataPrivate = v),
          ),
          _buildSwitchTile(
            context.tr('show_gifts_members'),
            _showGiftsToMember,
            (v) => setState(() => _showGiftsToMember = v),
          ),
          _buildSwitchTile(
            context.tr('allow_gifting'),
            _allowGifting,
            (v) => setState(() => _allowGifting = v),
          ),

          _buildHeader(context.tr('moderation_restrictions')),
          _buildSwitchTile(
            context.tr('allow_media'),
            _allowMedia,
            (v) => setState(() => _allowMedia = v),
          ),
          _buildDropdownTile(context.tr('slow_mode'), _slowMode, [
            'off',
            '30s',
            '1m',
            '5m',
          ], (v) => setState(() => _slowMode = v!)),
          _buildDropdownTile(
            context.tr('content_filter'),
            _contentFilter,
            ['none', 'low', 'medium', 'high'],
            (v) => setState(() => _contentFilter = v!),
          ),

          _buildHeader(context.tr('notifications_header')),
          _buildDropdownTile(
            context.tr('notifications'),
            _notifications,
            ['all', 'mentions', 'none'],
            (v) => setState(() => _notifications = v!),
          ),

          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 10.h),
      child: Text(
        title,
        style: TextStyle(
          color: const Color(0xFFFFD700),
          fontSize: 11.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Transform.scale(
        scale: 0.8,
        child: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFFFFD700),
        ),
      ),
    );
  }

  Widget _buildDropdownTile(
    String title,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: colorScheme.surface,
          alignment: Alignment.centerRight,
          style: TextStyle(
            color: const Color(0xFFFFD700),
            fontWeight: FontWeight.w900,
            fontSize: 14.sp,
          ),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: const Color(0xFFFFD700),
            size: 20.sp,
          ),
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(
                _getLocalizedOption(option),
                style: const TextStyle(letterSpacing: 0.5),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  String _getLocalizedOption(String option) {
    // If the option is a number/time like '30s', return as is
    if (RegExp(r'^\d+[smh]$').hasMatch(option)) return option;
    return context.tr(option);
  }
}











