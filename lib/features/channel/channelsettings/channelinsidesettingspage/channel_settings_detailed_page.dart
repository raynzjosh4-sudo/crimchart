import 'package:crown/channelcreatepage/subpages/age_selection_page.dart';
import 'package:crown/channelcreatepage/subpages/country_selection_page.dart';
import 'package:crown/core/localization/localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:crown/core/di/injection.dart';
import 'package:crown/features/showcase/chart_toast.dart';
import 'package:crown/core/widgets/chart_linear_loader.dart';
import 'package:crown/features/channel/domain/repositories/channel_repository.dart';
import 'package:crown/core/db/chart_native_db.dart';
import 'package:crown/features/channel/domain/entities/channel_entity.dart';
import 'dart:convert';

class ChannelSettingsDetailedPage extends StatefulWidget {
  final String channelId;
  final String initialAge;
  final bool initialVisibleToOtherChannelMembers;
  final bool initialVisibleToFollowedUsers;
  final String initialJoinMethod;
  final bool initialPreventLeaving;
  final List<String> initialCountryRestrictions;
  final String initialAllowCommentingBy;
  final String initialAllowStatusPostingBy;
  final String initialAllowInvitationsBy;

  const ChannelSettingsDetailedPage({
    super.key,
    required this.channelId,
    required this.initialAge,
    required this.initialVisibleToOtherChannelMembers,
    required this.initialVisibleToFollowedUsers,
    required this.initialJoinMethod,
    required this.initialPreventLeaving,
    required this.initialCountryRestrictions,
    required this.initialAllowCommentingBy,
    required this.initialAllowStatusPostingBy,
    required this.initialAllowInvitationsBy,
  });

  @override
  State<ChannelSettingsDetailedPage> createState() =>
      _ChannelSettingsDetailedPageState();
}

class _ChannelSettingsDetailedPageState
    extends State<ChannelSettingsDetailedPage> {
  // Settings State
  late bool _visibleToOtherChannelMembers;
  late bool _visibleToFollowedUsers;
  late String _joinMethod;
  late bool _preventLeaving;
  late String _selectedAge;
  late List<String> _selectedCountries;
  late String _allowCommentingBy;
  late String _allowStatusPostingBy;
  late String _allowInvitationsBy;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _visibleToOtherChannelMembers = widget.initialVisibleToOtherChannelMembers;
    _visibleToFollowedUsers = widget.initialVisibleToFollowedUsers;
    _joinMethod = widget.initialJoinMethod;
    _preventLeaving = widget.initialPreventLeaving;
    _selectedAge = widget.initialAge;
    _selectedCountries = List.from(widget.initialCountryRestrictions);
    _allowCommentingBy = widget.initialAllowCommentingBy;
    _allowStatusPostingBy = widget.initialAllowStatusPostingBy;
    _allowInvitationsBy = widget.initialAllowInvitationsBy;
    
    _loadOfflineSettings();
  }

  Future<void> _loadOfflineSettings() async {
    try {
      final nativeDb = getIt<ChartNativeDB>();
      final channels = await nativeDb.getCachedChannels();
      final myChannelJson = channels.where((c) => c['id'] == widget.channelId).firstOrNull;
      
      if (myChannelJson != null && mounted) {
        final entity = ChannelEntity.fromLocalCache(myChannelJson);
        setState(() {
          _visibleToOtherChannelMembers = entity.visible_to_other_channel_members == 1;
          _visibleToFollowedUsers = entity.visible_to_followed_users == 1;
          _joinMethod = entity.join_method ?? 'invite';
          _preventLeaving = entity.prevent_leaving == 1;
          _selectedAge = entity.age_restriction ?? 'All Ages';
          _allowCommentingBy = entity.allow_commenting_by ?? 'all';
          _allowStatusPostingBy = entity.allow_status_posting_by ?? 'all';
          _allowInvitationsBy = entity.allow_invitations_by ?? 'all';
          
          if (entity.country_restrictions != null) {
             try {
                final List<dynamic> parsed = jsonDecode(entity.country_restrictions!);
                _selectedCountries = parsed.map((e) => e.toString()).toList();
             } catch(_) {}
          }
        });
      }
    } catch (e) {
      debugPrint('Failed to load offline settings: $e');
    }
  }

  Future<void> _saveSettings() async {
    setState(() => _isSaving = true);
    
    final repository = getIt<ChannelRepository>();
    
    final updatedData = {
      'age_restriction': _selectedAge,
      'visible_to_other_channel_members': _visibleToOtherChannelMembers ? 1 : 0,
      'visible_to_followed_users': _visibleToFollowedUsers ? 1 : 0,
      'join_method': _joinMethod,
      'prevent_leaving': _preventLeaving ? 1 : 0,
      'country_restrictions': jsonEncode(_selectedCountries), 
      'allow_commenting_by': _allowCommentingBy,
      'allow_status_posting_by': _allowStatusPostingBy,
      'allow_invitations_by': _allowInvitationsBy,
    };

    // 🗑️ LOCAL CLEANUP: Instantly remove cached invitation posts so UI updates immediately
    if (_allowInvitationsBy == 'none') {
      final nativeDb = getIt<ChartNativeDB>();
      await nativeDb.deleteInvitationPostsForChannel(widget.channelId);
    }

    final result = await repository.updateChannel(widget.channelId, updatedData);

    if (mounted) {
      setState(() => _isSaving = false);
      result.fold(
        (failure) => ChartToast.showError(
          context, 
          title: 'Update Failed', 
          message: failure.message
        ),
        (success) {
          ChartToast.showSuccess(
            context, 
            title: 'Success', 
            message: 'Settings updated successfully! 👑'
          );
          Navigator.of(context).pop();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final primaryColor = colorScheme.primary;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: ChartAppBar(
        title: 'Privacy & Permissions',
        centerTitle: true,
        showBack: true,
        backgroundColor: backgroundColor,
      ),
      body: Column(
        children: [
          if (_isSaving) ChartLinearLoader(isLoading: _isSaving),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              children: [
                _buildHeader(context.tr('set_who_can_see_channel'), primaryColor),
                _buildActionTile(
                  context.tr('age_restriction'),
                  _selectedAge == 'All Ages' ? context.tr('all') : _selectedAge,
                  LucideIcons.calendar,
                  () async {
                    final selected = await Navigator.of(context).push<String>(
                      MaterialPageRoute(
                        builder: (_) => AgeSelectionPage(currentAge: _selectedAge),
                      ),
                    );
                    if (selected != null && mounted)
                      setState(() => _selectedAge = selected);
                  },
                ),
                _buildSwitchTile(
                  context.tr('members_in_my_other_channels'),
                  _visibleToOtherChannelMembers,
                  (v) => setState(() => _visibleToOtherChannelMembers = v),
                  primaryColor,
                ),
                _buildSwitchTile(
                  context.tr('members_am_following'),
                  _visibleToFollowedUsers,
                  (v) => setState(() => _visibleToFollowedUsers = v),
                  primaryColor,
                ),

                _buildHeader(context.tr('how_can_people_join'), primaryColor),
                _buildRadioTile(
                  context.tr('by_sending_invitation_request'),
                  'invite',
                  _joinMethod,
                  (v) => setState(() => _joinMethod = v!),
                  primaryColor,
                ),
                _buildRadioTile(
                  context.tr('anyone_can_join'),
                  'anyone',
                  _joinMethod,
                  (v) => setState(() => _joinMethod = v!),
                  primaryColor,
                ),

                _buildHeader(context.tr('allow_commenting_by'), primaryColor),
                _buildRadioTile(
                  context.tr('all'),
                  'all',
                  _allowCommentingBy,
                  (v) => setState(() => _allowCommentingBy = v!),
                  primaryColor,
                ),
                _buildRadioTile(
                  context.tr('followers'),
                  'followers',
                  _allowCommentingBy,
                  (v) => setState(() => _allowCommentingBy = v!),
                  primaryColor,
                ),
                _buildRadioTile(
                  context.tr('joined_members'),
                  'joined',
                  _allowCommentingBy,
                  (v) => setState(() => _allowCommentingBy = v!),
                  primaryColor,
                ),
                _buildRadioTile(
                  context.tr('none_only_me'),
                  'none',
                  _allowCommentingBy,
                  (v) => setState(() => _allowCommentingBy = v!),
                  primaryColor,
                ),

                _buildHeader('ALLOW STATUS POSTING BY', primaryColor),
                _buildRadioTile(
                  context.tr('all'),
                  'all',
                  _allowStatusPostingBy,
                  (v) => setState(() => _allowStatusPostingBy = v!),
                  primaryColor,
                ),
                _buildRadioTile(
                  context.tr('joined_members'),
                  'joined',
                  _allowStatusPostingBy,
                  (v) => setState(() => _allowStatusPostingBy = v!),
                  primaryColor,
                ),
                _buildRadioTile(
                  context.tr('none_only_me'),
                  'none',
                  _allowStatusPostingBy,
                  (v) => setState(() => _allowStatusPostingBy = v!),
                  primaryColor,
                ),

                _buildHeader('ALLOW INVITATIONS BY', primaryColor),
                _buildRadioTile(
                  context.tr('all'),
                  'all',
                  _allowInvitationsBy,
                  (v) => setState(() => _allowInvitationsBy = v!),
                  primaryColor,
                ),
                _buildRadioTile(
                  context.tr('joined_members'),
                  'members',
                  _allowInvitationsBy,
                  (v) => setState(() => _allowInvitationsBy = v!),
                  primaryColor,
                ),
                _buildRadioTile(
                  context.tr('none_only_me'),
                  'none',
                  _allowInvitationsBy,
                  (v) => setState(() => _allowInvitationsBy = v!),
                  primaryColor,
                ),

                _buildHeader(context.tr('global_restrictions'), primaryColor),
                _buildActionTile(
                  context.tr('which_country_allowed'),
                  _selectedCountries.length == 1
                      ? (_selectedCountries.first == 'Global'
                            ? context.tr('all')
                            : _selectedCountries.first)
                      : '${_selectedCountries.length}',
                  LucideIcons.globe,
                  () async {
                    final selected = await Navigator.of(context).push<List<String>>(
                      MaterialPageRoute(
                        builder: (_) => CountrySelectionPage(
                          currentCountries: _selectedCountries,
                        ),
                      ),
                    );
                    if (selected != null && mounted)
                      setState(() => _selectedCountries = selected);
                  },
                ),
                _buildSwitchTile(
                  context.tr('allow_members_not_leave'),
                  _preventLeaving,
                  (v) => setState(() => _preventLeaving = v),
                  primaryColor,
                ),

                SizedBox(height: 32.h),

                // 👑 IN-UI SAVE BUTTON (Requested: Inside the Column/List)
                if (!_isSaving)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: _saveSettings,
                        child: Container(
                          width: 120.w,
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Center(
                            child: Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFFFFD700), // 👑 VIBRANT GOLD
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                SizedBox(height: 60.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String title, Color color) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 8.h),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: color.withValues(alpha: 0.8),
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
    Color primaryColor,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      title: Text(
        title,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Transform.scale(
        scale: 0.8,
        child: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: primaryColor,
          activeTrackColor: primaryColor.withValues(alpha: 0.3),
        ),
      ),
      onTap: () => onChanged(!value),
    );
  }

  Widget _buildRadioTile(
    String title,
    String value,
    String groupValue,
    ValueChanged<String?> onChanged,
    Color primaryColor,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
      title: Text(
        title,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Transform.scale(
        scale: 0.85,
        child: Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: primaryColor,
        ),
      ),
      onTap: () => onChanged(value),
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
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
      onTap: onTap,
    );
  }
}
