import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/core/theme/theme_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/features/allchannels/models/chart_channel.dart';
import 'package:crown/features/channel/channelsettings/channel_settings_page.dart';
import 'package:crown/features/widgets/messages_section.dart';
import 'package:crown/profile/models/charter_model.dart';
import 'package:crown/core/localization/localization_provider.dart';

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crown/features/newinsidechartstartpage/models/member.dart';

import 'package:crown/features/feed/domain/entities/post_entity.dart';
import 'package:crown/features/channel/application/channel_feed_provider.dart';
import 'package:crown/features/auth/application/auth_controller.dart';
import 'package:crown/posting/application/posting_controller.dart';
import 'package:crown/posting/models/media_item.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:crown/commentingsheets/widgets/comment_input_field.dart';
import 'package:crown/posting/pages/post_page.dart';

class ChannelPage extends ConsumerStatefulWidget {
  final ChartChannel? channel;
  final List<CharterModel> contestants;
  final String? initialMessageId;
  final CharterModel? focusedContestant;

  const ChannelPage({
    super.key,
    this.channel,
    this.contestants = const [],
    this.initialMessageId,
    this.focusedContestant,
  });

  @override
  ConsumerState<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends ConsumerState<ChannelPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _commentController = TextEditingController();
  late final AudioRecorder _audioRecorder;
  bool _isRecording = false;
  bool _showFab = true;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _commentController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  // ─── Recording Logic ────────────────────────────────────────────────────────

  Future<void> _startRecording() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) return;

    if (await _audioRecorder.isRecording()) return;

    try {
      final dir = await getTemporaryDirectory();
      final path =
          '${dir.path}/voice_note_${DateTime.now().millisecondsSinceEpoch}.m4a';

      const config = RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 24000,
        sampleRate: 16000,
        numChannels: 1,
      );

      await _audioRecorder.start(config, path: path);
      setState(() => _isRecording = true);
    } catch (e) {
      debugPrint('Failed to start recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() => _isRecording = false);
      if (path != null) {
        _handlePost(recordedAudioPath: path);
      }
    } catch (e) {
      debugPrint('Failed to stop recording: $e');
    }
  }

  Future<void> _handlePost({String? recordedAudioPath}) async {
    final caption = _commentController.text.trim();
    if (caption.isEmpty && recordedAudioPath == null) return;

    final user = ref.read(authControllerProvider).user;
    if (user == null) return;

    final displayChannel = widget.channel ?? _getDummyChannel();
    List<MediaItem> items = [];

    if (recordedAudioPath != null) {
      items.add(
        MediaItem(
          path: recordedAudioPath,
          type: MediaType.audio,
          source: MediaSource.device,
        ),
      );
    }

    // Determine type: Channels usually get Manifestos as top-level posts
    String determinedType = PostType.manifesto;

    await ref
        .read(postingControllerProvider.notifier)
        .createPost(
          media: items,
          caption: caption,
          channelId: displayChannel.id,
          channelName: displayChannel.title,
          isMyChannel: false,
          postType: determinedType,
        );

    _commentController.clear();
  }

  void _openPostPage() {
    final displayChannel = widget.channel ?? _getDummyChannel();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PostPage(
          targetChannelId: displayChannel.id,
          isManifestoContext: false,
        ),
      ),
    );
  }

  // 👑 EXTRACTED HEADER UI: We moved this out of the Slivers list!
  Widget _buildConversationHeader(
    ChartChannel displayChannel,
    ThemeData theme,
    Color currentColor,
  ) {
    return Column(
      children: [
        if (displayChannel.description != null &&
            displayChannel.description!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Text(
              displayChannel.description!,
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14.sp,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        SizedBox(height: 12.h),
        Text(
          '${displayChannel.memberCount} ${context.tr('members').toUpperCase()}',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            letterSpacing: 1.5,
          ),
        ),

        // 👑 CHANGED: Replaced the massive 120.h gap with a clean 32.h gap
        // This is the space between the yellow button and the first chat message!
        SizedBox(height: 32.h),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final currentColor = context.read<ThemeProvider>().currentColor;
    final displayChannel = widget.channel ?? _getDummyChannel();
    final feedState = ref.watch(channelFeedProvider(displayChannel.id));
    final List<PostEntity> channelPosts = feedState.allPosts;

    final bool canAccess =
        !displayChannel.isPrivate ||
        displayChannel.isOwnChannel ||
        displayChannel.isCharted;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: ChartAppBar(
        title: displayChannel.title,
        titleWidget: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 250.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (displayChannel.imageUrl != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.w),
                      child: CachedNetworkImage(
                        imageUrl: displayChannel.imageUrl!,
                        width: 24.w,
                        height: 24.w,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: backgroundColor.withValues(alpha: 0.1),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          LucideIcons.image,
                          size: 14.sp,
                          color: currentColor.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                  ],
                  Flexible(
                    child: Text(
                      context.tr(displayChannel.title),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w900,
                        fontSize: 16.sp,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${displayChannel.memberCount} ${context.tr('members')}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    ' • ',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                  ),
                  Text(
                    displayChannel.isPrivate
                        ? context.tr("private")
                        : context.tr("public"),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        backgroundColor: backgroundColor,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChannelSettingsPage(
                  channelId: displayChannel.id,
                  channelTitle: displayChannel.title,
                  memberCount: displayChannel.memberCount,
                  createdAt: displayChannel
                      .createdAt, // ✅ FIXED: Pass actual creation date
                  staterAvatarUrl: displayChannel.imageUrl,
                  description: displayChannel.description,
                  ageRestriction: displayChannel.age_restriction,
                  membersOtherChannels: displayChannel.membersOtherChannels,
                  membersFollowing: displayChannel.membersFollowing,
                  joinMethod: displayChannel.joinMethod,
                  preventLeaving: displayChannel.preventLeaving,
                  countryRestrictions: displayChannel.countryRestrictions,
                  allowCommentingBy: displayChannel.allowCommentingBy,
                  members: widget.contestants
                      .map(
                        (c) => Member(
                          id: c.id,
                          name: c.displayName,
                          avatarUrl: c.profileImageUrl,
                          title: c.title,
                          channelsCount: c.channelCount,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            icon: Icon(
              LucideIcons.settings,
              color: colorScheme.onSurface,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 8.w),
        ],
        titleStyle: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w900,
          fontSize: 18.sp,
          letterSpacing: 0.5,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    return false;
                  },
                  child: CustomScrollView(
                    reverse: true,
                    controller: _scrollController,
                    slivers: [
                      // ── BOTTOM PADDING ──
                      SliverPadding(padding: EdgeInsets.only(bottom: 20.h)),

                      // ── MESSAGES SECTION (Newest at Bottom) ──
                      if (canAccess)
                        MessagesSection(
                          initialMessageId: widget.initialMessageId,
                          targetMemberId: widget.focusedContestant?.id,
                          channelId: displayChannel.id,
                          scrollController: _scrollController,
                          headerWidget: _buildConversationHeader(
                            displayChannel,
                            theme,
                            currentColor,
                          ),
                        )
                      else ...[
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  LucideIcons.lock,
                                  size: 48.sp,
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  context.tr('private_channel_message'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.5,
                                    ),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: _buildConversationHeader(
                            displayChannel,
                            theme,
                            currentColor,
                          ),
                        ),
                      ],

                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── PERSISTENT WHATSAPP-STYLE INPUT FIELD ──
          if (canAccess)
            CommentInputField(
              controller: _commentController,
              onSend: _handlePost,
              onImageTap: _openPostPage,
              onLongPressStart: _startRecording,
              onLongPressEnd: _stopRecording,
              userImageUrl: ref
                  .watch(authControllerProvider)
                  .user
                  ?.profileImageUrl,
            ),
        ],
      ),
    );
  }

  Widget _buildFocusedHero(CharterModel contestant) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final bool locallyCrowned = _showFab;

    return Column(
      children: [
        Container(
          width: screenWidth * 0.9,
          height: 360.h,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
            image: DecorationImage(
              image: CachedNetworkImageProvider(contestant.profileImageUrl),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          contestant.displayName,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          '${(contestant.chartCount / 1000).toStringAsFixed(1)}k Crowns',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFFFD700),
          ),
        ),
        SizedBox(height: 18.h),
        if (!locallyCrowned)
          GestureDetector(
            onTap: () {
              setState(() {
                _showFab = true;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700),
                borderRadius: BorderRadius.circular(30.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Text(
                'CROWN',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
      ],
    );
  }

  ChartChannel _getDummyChannel() {
    return ChartChannel(
      id: 'dummy',
      title: 'The massive influence of AI on modern art',
      memberCount: 560,
      isPrivate: false,
    );
  }
}
