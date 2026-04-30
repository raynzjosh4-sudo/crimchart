import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crown/posting/application/posting_controller.dart';
import 'package:crown/posting/models/media_item.dart';
import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/posting/pages/channeltags/channel_tags.dart';
import 'package:crown/posting/pages/advancedsettings/advanced_settings_sheet.dart';
import 'package:crown/features/allchannels/dummydata/channel_dummy_data.dart';

import 'widgets/finalize_media_preview.dart';
import 'widgets/finalize_caption_section.dart';
import 'widgets/finalize_share_button.dart';
import 'widgets/finalize_tiles.dart';

class FinalizePostPage extends ConsumerStatefulWidget {
  final List<MediaItem> selectedMedia;
  final String? targetChannelId; // 👑 Context Flag
  final bool isManifestoContext; // 👑 Context Flag

  const FinalizePostPage({
    super.key, 
    required this.selectedMedia,
    this.targetChannelId,
    this.isManifestoContext = false,
  });

  @override
  ConsumerState<FinalizePostPage> createState() => _FinalizePostPageState();
}

class _FinalizePostPageState extends ConsumerState<FinalizePostPage> {
  final TextEditingController _captionController = TextEditingController();
  bool _shareToStatus = false;
  bool _isPublic = true;
  bool _allowComments = true;
  bool _isChannelExpanded = false;
  final List<String> _selectedChannels = [];

  Future<void> _handlePost() async {
    print('🔘 [UI] Share button pressed!');

    // 👑 RULE 4: Is this a direct post from the Channel Info Sheet?
    final bool isDirectChannelPost = widget.targetChannelId != null;

    // 👑 Determine Routing Destinations
    final List<String> finalChannels = isDirectChannelPost 
        ? [widget.targetChannelId!] 
        : _selectedChannels;

    // 👑 RULE 1: Post Type logic
    // If it's from the sheet context, it's a manifesto.
    // (If not, your backend controller should check if they own the tagged channel to upgrade it to a manifesto).
    String determinedPostType = widget.isManifestoContext ? 'manifesto' : 'post';

    // 👑 RULE 2: Global Feed Visibility
    final bool isPublicFeed = _isPublic;

    // 👑 RULE 3: Status 
    if (_shareToStatus && !isDirectChannelPost) {
       // TODO: Call your status creation endpoint here later
       print('Creating Status Record...');
    }

    // Fire the request to the controller with all our calculated rules
    await ref.read(postingControllerProvider.notifier).createPost(
      media: widget.selectedMedia,
      caption: _captionController.text,
      channels: finalChannels,
      postType: determinedPostType, 
      isPublicFeed: isPublicFeed, // Will dictate if it goes to the global `posts` table
      allowComments: _allowComments, 
      shareToStatus: _shareToStatus && !isDirectChannelPost, // 👑 ADDED
    );
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Check if this is a locked manifesto context
    final bool isDirectChannelPost = widget.targetChannelId != null;

    final postingState = ref.watch(postingControllerProvider);
    final isPosting =
        postingState.status != PostingStatus.idle &&
        postingState.status != PostingStatus.success &&
        postingState.status != PostingStatus.error;

    ref.listen(postingControllerProvider, (previous, next) {
      if (next.status == PostingStatus.success) {
        if (mounted) {
          ref.read(postingControllerProvider.notifier).reset();
          // 👑 FIXED: Stop popping all the way to the root!
          // Just pop back to the channel.
          Navigator.of(context).pop(); // Pops Finalize
          Navigator.of(context).pop(); // Pops Media Pick/Sheet
        }
      } else if (next.status == PostingStatus.error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.error ?? 'Unknown error'))
          );
        }
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(
        title: isDirectChannelPost ? context.tr('new_manifesto') : context.tr('new_post'),
        isLoading: isPosting,
        loadingProgress: postingState.progress,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FinalizeMediaPreview(selectedMedia: widget.selectedMedia),
                  FinalizeCaptionSection(controller: _captionController),

                  SizedBox(height: 16.h),

                  // 👑 HIDE THESE IF IT'S A DIRECT CHANNEL MANIFESTO
                  if (!isDirectChannelPost) ...[
                    FinalizeSwitchTile(
                      icon: LucideIcons.circleDot,
                      title: context.tr('share_to_status'),
                      value: _shareToStatus,
                      onChanged: (val) => setState(() => _shareToStatus = val),
                    ),

                    FinalizeListTile(
                      icon: LucideIcons.hash,
                      title: _selectedChannels.isEmpty
                          ? context.tr('tag_in_channel')
                          : '${context.tr('tag_in_channel')} (${_selectedChannels.length} ${context.tr('selected')})',
                      onTap: () => setState(
                        () => _isChannelExpanded = !_isChannelExpanded,
                      ),
                      trailing: Icon(
                        _isChannelExpanded
                            ? LucideIcons.chevronDown
                            : LucideIcons.chevronRight,
                        color: colorScheme.onSurface.withValues(alpha: 0.2),
                        size: 18.sp,
                      ),
                    ),

                    if (_isChannelExpanded)
                      ChannelTags(
                        channels: dummyChannels,
                        selectedChannels: _selectedChannels,
                        onChannelSelected: (title) {
                          setState(() {
                            if (_selectedChannels.contains(title)) {
                              _selectedChannels.remove(title);
                            } else {
                              _selectedChannels.add(title);
                            }
                          });
                        },
                      ),
                  ],

                  SizedBox(height: 8.h),

                  FinalizeListTile(
                    icon: LucideIcons.settings,
                    title: context.tr('advanced_settings'),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => StatefulBuilder(
                          builder: (ctx, setSheetState) => AdvancedSettingsSheet(
                            isPublic: _isPublic,
                            allowComments: _allowComments,
                            onPublicChanged: (val) {
                              setSheetState(() => _isPublic = val);
                              setState(() => _isPublic = val);
                            },
                            onAllowCommentsChanged: (val) {
                              setSheetState(() => _allowComments = val);
                              setState(() => _allowComments = val);
                            },
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),

          FinalizeShareButton(
            onTap: isPosting ? () {} : _handlePost,
            isLoading: isPosting,
            status: postingState.status,
          ),
        ],
      ),
    );
  }
}
