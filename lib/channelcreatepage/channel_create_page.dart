import 'dart:io';
import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/widgets/chart_linear_loader.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/channel/application/channel_creation_controller.dart';
import '../chartappbar/chart_app_bar.dart';
import '../commentingsheets/widgets/commenting_sheet.dart';
import '../features/widgets/chartcard/models/media_data.dart';
import 'channel_invite_page.dart';
import 'subpages/age_selection_page.dart';
import 'subpages/country_selection_page.dart';

class ChannelCreatePage extends ConsumerStatefulWidget {
  const ChannelCreatePage({super.key});

  @override
  ConsumerState<ChannelCreatePage> createState() => _ChannelCreatePageState();
}

class _ChannelCreatePageState extends ConsumerState<ChannelCreatePage> {
  final _nameController = TextEditingController(text: 'Channel Title');
  final _descriptionController = TextEditingController(
    text: 'Write about the channel or community...',
  );

  MediaData? _selectedMedia;

  // Settings State
  bool _membersOtherChannels = false;
  bool _membersFollowing = true;
  String _joinMethod = 'invite';
  bool _preventLeaving = false;
  String _selectedAge = 'All Ages';
  List<String> _selectedCountries = ['Global'];
  String _allowCommentingBy = 'all';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = theme.primaryColor;

    final creationState = ref.watch(channelCreationControllerProvider);
    final isLoading = creationState.status == ChannelCreationStatus.processing;

    ref.listen<ChannelCreationState>(channelCreationControllerProvider, (
      previous,
      next,
    ) {
      if (next.status == ChannelCreationStatus.success) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ChannelInvitePage()),
        );
      } else if (next.status == ChannelCreationStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error ?? 'Creation failed')),
        );
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(
        title: 'create_channel', // 👑 MOCKUP HAS RAW LOWERCASE BOLD
        showBack: true,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Interactive Avatar Selector
                  Center(
                    child: GestureDetector(
                      onTap: () => _showMediaPicker(context),
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHigh.withValues(
                            alpha: 0.3,
                          ),
                          shape: BoxShape.circle,
                          image: _selectedMedia != null
                              ? DecorationImage(
                                  image:
                                      _selectedMedia!.contentUrl.startsWith(
                                        'http',
                                      )
                                      ? NetworkImage(_selectedMedia!.contentUrl)
                                            as ImageProvider
                                      : FileImage(
                                          File(_selectedMedia!.contentUrl),
                                        ),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _selectedMedia == null
                            ? Center(
                                child: Icon(
                                  LucideIcons.camera,
                                  size: 40,
                                  color: Color(0xFFFFD700).withValues(alpha: 0.8), // 👑 VIBRANT VINTAGE GOLD
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Essential Identity Fields
                  _buildTextField(
                    _nameController,
                    hint: context.tr('channel_title_hint'),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    _descriptionController,
                    hint: context.tr('channel_description_hint'),
                    maxLines: 4,
                  ),

                  const SizedBox(height: 32),

                  // Embedded Settings
                  _buildSectionHeader(
                    context.tr('set_who_can_see_channel'),
                    colorScheme,
                  ),
                  _buildActionTile(
                    context.tr('age_restriction'),
                    _selectedAge == 'All Ages'
                        ? context.tr('all')
                        : _selectedAge,
                    LucideIcons.calendar,
                    colorScheme,
                    () async {
                      final selected = await Navigator.of(context).push<String>(
                        MaterialPageRoute(
                          builder: (_) =>
                              AgeSelectionPage(currentAge: _selectedAge),
                        ),
                      );
                      if (selected != null && mounted) {
                        setState(() => _selectedAge = selected);
                      }
                    },
                  ),
                  _buildToggleTile(
                    context.tr('members_in_my_other_channels'),
                    _membersOtherChannels,
                    (val) => setState(() => _membersOtherChannels = val),
                    colorScheme,
                  ),
                  _buildToggleTile(
                    context.tr('members_am_following'),
                    _membersFollowing,
                    (val) => setState(() => _membersFollowing = val),
                    colorScheme,
                  ),

                  const SizedBox(height: 24),
                  _buildSectionHeader(
                    context.tr('how_can_people_join'),
                    colorScheme,
                  ),
                  _buildRadioTile(
                    context.tr('by_sending_invitation_request'),
                    'invite',
                    _joinMethod,
                    (val) => setState(() => _joinMethod = val!),
                    colorScheme,
                  ),
                  _buildRadioTile(
                    context.tr('anyone_can_join'),
                    'anyone',
                    _joinMethod,
                    (val) => setState(() => _joinMethod = val!),
                    colorScheme,
                  ),

                  const SizedBox(height: 24),
                  _buildSectionHeader(
                    context.tr('allow_commenting_by'),
                    colorScheme,
                  ),
                  _buildRadioTile(
                    context.tr('all'),
                    'all',
                    _allowCommentingBy,
                    (val) => setState(() => _allowCommentingBy = val!),
                    colorScheme,
                  ),
                  _buildRadioTile(
                    context.tr('followers'),
                    'followers',
                    _allowCommentingBy,
                    (val) => setState(() => _allowCommentingBy = val!),
                    colorScheme,
                  ),
                  _buildRadioTile(
                    context.tr('joined_members'),
                    'joined',
                    _allowCommentingBy,
                    (val) => setState(() => _allowCommentingBy = val!),
                    colorScheme,
                  ),
                  _buildRadioTile(
                    context.tr('none_only_me'),
                    'none',
                    _allowCommentingBy,
                    (val) => setState(() => _allowCommentingBy = val!),
                    colorScheme,
                  ),

                  const SizedBox(height: 24),
                  _buildSectionHeader(
                    context.tr('global_restrictions'),
                    colorScheme,
                  ),
                  _buildActionTile(
                    context.tr('which_country_allowed'),
                    _selectedCountries.length == 1
                        ? (_selectedCountries.first == 'Global'
                              ? context.tr('all')
                              : _selectedCountries.first)
                        : '${_selectedCountries.length}',
                    LucideIcons.globe,
                    colorScheme,
                    () async {
                      final selected = await Navigator.of(context)
                          .push<List<String>>(
                            MaterialPageRoute(
                              builder: (_) => CountrySelectionPage(
                                currentCountries: _selectedCountries,
                              ),
                            ),
                          );
                      if (selected != null && mounted) {
                        setState(() => _selectedCountries = selected);
                      }
                    },
                  ),
                  _buildToggleTile(
                    context.tr('allow_members_not_leave'),
                    _preventLeaving,
                    (val) => setState(() => _preventLeaving = val),
                    colorScheme,
                  ),

                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 24),
                    child: Text(
                      context.tr('change_settings_anytime'),
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                        height: 1.5,
                      ),
                    ),
                  ),

                  // Right-Aligned Premium Action Box
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        print('🏗️ CREATE CHANNEL BUTTON PRESSED');
                        if (isLoading) {
                          print('⚠️ ALREADY LOADING... IGNORING TAP');
                          return;
                        }
                        if (_nameController.text.trim().isEmpty) {
                          print('❌ VALIDATION FAILED: NAME IS EMPTY');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter a name')),
                          );
                          return;
                        }

                        print('🚀 SENDING DATA TO CONTROLLER:');
                        print(' - Name: ${_nameController.text}');
                        print(' - Description: ${_descriptionController.text}');
                        print(' - Media: ${_selectedMedia?.contentUrl}');
                        print(' - Age: $_selectedAge');

                        ref
                            .read(channelCreationControllerProvider.notifier)
                            .createChannel(
                              name: _nameController.text.trim(),
                              description: _descriptionController.text.trim(),
                              mediaPath: _selectedMedia?.contentUrl,
                              ageRestriction: _selectedAge,
                              membersOtherChannels: _membersOtherChannels,
                              membersFollowing: _membersFollowing,
                              joinMethod: _joinMethod,
                              preventLeaving: _preventLeaving,
                              countryRestrictions: _selectedCountries,
                              allowCommentingBy: _allowCommentingBy,
                            );
                      },
                      child: Container(
                        width: 120,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isLoading
                              ? colorScheme.surfaceContainerHigh.withValues(
                                  alpha: 0.1,
                                )
                              : colorScheme.surfaceContainerHigh.withValues(
                                  alpha: 0.3,
                                ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            isLoading
                                ? context.tr('wait')
                                : context.tr('create'),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: isLoading
                                  ? primaryColor.withValues(alpha: 0.5)
                                  : primaryColor,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          if (isLoading)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ChartLinearLoader(
                isLoading: true,
                color: primaryColor,
                height: 3,
              ),
            ),
        ],
      ),
    );
  }

  void _showMediaPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentingSheet(
        showInputField: false,
        onMediaSelected: (media) {
          setState(() {
            _selectedMedia = media;
          });
        },
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    String? hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
        ),
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(18),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, bottom: 16, top: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Color(0xFFFFD700), // 👑 PURE GOLD TEXT
          fontSize: 13,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8,
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      title: Text(
        title,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Transform.scale(
        scale: 0.75,
        child: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: colorScheme.primary,
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
    ColorScheme colorScheme,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      title: Text(
        title,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Transform.scale(
        scale: 0.85,
        child: Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: colorScheme.primary,
        ),
      ),
      onTap: () => onChanged(value),
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    ColorScheme colorScheme,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      title: Text(
        title,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 14,
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
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            LucideIcons.chevronRight,
            size: 20,
            color: colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
