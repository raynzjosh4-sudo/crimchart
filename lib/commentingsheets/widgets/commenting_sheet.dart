import 'package:crown/commentingsheets/widgets/tabs/charted_members_tab.dart';
import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/features/channel/application/channel_feed_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:crown/features/auth/application/auth_controller.dart';
import 'package:crown/posting/application/posting_controller.dart';
import 'package:crown/posting/models/media_item.dart';
import 'package:crown/commentingsheets/widgets/comment_input_field.dart';
import 'tabs/your_data_tab.dart';
import 'tabs/device_media_tab.dart';
import 'tabs/gif_selection_tab.dart';
import '../../features/newinsidechartstartpage/widgets/datacardwidget/sample_media_data.dart';
import '../../features/widgets/chartcard/models/media_data.dart' as legacy;
import 'package:crown/core/widgets/chart_image.dart';

class CommentingSheet extends ConsumerStatefulWidget {
  final String? channelId;
  final String? channelName;
  final String commentCount;
  final VoidCallback? onCommentPosted;
  final Function(legacy.MediaData)? onMediaSelected;
  final bool showInputField;

  const CommentingSheet({
    super.key,
    this.channelId,
    this.channelName,
    this.commentCount = '0',
    this.onCommentPosted,
    this.onMediaSelected,
    this.showInputField = true,
    this.linkedPostId,
    this.linkedAuthorUsername,
    this.linkedCaption,
    this.linkedChannelId,
    this.linkedThumbnailUrl,
  });

  final String? linkedPostId;
  final String? linkedAuthorUsername;
  final String? linkedCaption;
  final String? linkedChannelId;
  final String? linkedThumbnailUrl;

  @override
  ConsumerState<CommentingSheet> createState() => _CommentingSheetState();
}

class _CommentingSheetState extends ConsumerState<CommentingSheet> {
  final TextEditingController _commentController = TextEditingController();
  final SampleMediaData _sampleData = SampleMediaData();
  final List<int> _selectedIndices = [];
  List<legacy.MediaData> _selectedMediaItems = [];

  // 🎙️ Audio Recording State (Modern Record Package)
  AudioRecorder? _audioRecorder;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _audioRecorder?.dispose();
    _audioRecorder = null;
    super.dispose();
  }

  // ─── Recording Logic ────────────────────────────────────────────────────────

  Future<void> _startRecording() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) return;

    if (await _audioRecorder!.isRecording()) return;

    try {
      final dir = await getTemporaryDirectory();
      // WhatsApp style: .m4a (AAC) is standard and data-saving
      final path =
          '${dir.path}/voice_note_${DateTime.now().millisecondsSinceEpoch}.m4a';

      const config = RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 24000,
        sampleRate: 16000,
        numChannels: 1,
      );

      await _audioRecorder!.start(config, path: path);
      setState(() => _isRecording = true);
    } catch (e) {
      debugPrint('Failed to start recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder!.stop();
      setState(() => _isRecording = false);

      // 🚀 IMMEDIATE SEND: The user released the button, so we send now!
      if (path != null) {
        _handlePost(recordedAudioPath: path);
      }
    } catch (e) {
      debugPrint('Failed to stop recording: $e');
    }
  }

  void _onMediaTap(int index, legacy.MediaData item) {
    if (widget.onMediaSelected != null) {
      widget.onMediaSelected!(item);
      Navigator.pop(context);
      return;
    }

    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
        _selectedMediaItems.removeWhere(
          (m) => m.contentUrl == item.contentUrl,
        ); // 👑 Removes it
      } else {
        _selectedIndices.add(index);
        _selectedMediaItems.add(item); // 👑 Adds it without clearing others!
      }
    });
  }

  Future<void> _handlePost({String? recordedAudioPath}) async {
    final caption = _commentController.text.trim();

    // 👑 UPDATED SAFETY CHECK: Allows sending if caption OR media OR audio exists
    if (caption.isEmpty &&
        _selectedMediaItems.isEmpty &&
        recordedAudioPath == null)
      return;

    final user = ref.read(authControllerProvider).user;
    if (user == null) return;

    List<MediaItem> items = [];

    // 👑 1. Visual media (LOOP THROUGH MULTIPLE ITEMS)
    for (var mediaItem in _selectedMediaItems) {
      final isLocal = !mediaItem.contentUrl.startsWith('http');
      items.add(
        MediaItem(
          path: mediaItem.contentUrl,
          type: mediaItem.type == legacy.MediaType.video
              ? MediaType.video
              : MediaType.photo,
          thumbnailUrl: mediaItem.thumbnailUrl,
          source: isLocal ? MediaSource.device : MediaSource.gallery,
          linkedPostId: isLocal ? null : mediaItem.postId,
        ),
      );
    }

    // 2. Audio media (from direct recording)
    if (recordedAudioPath != null) {
      items.add(
        MediaItem(
          path: recordedAudioPath,
          type: MediaType.audio,
          source: MediaSource.device,
        ),
      );
    }

    // 👑 SMART ROUTING:
    // 1. If there is a linkedPostId, it's ALWAYS a comment (reply).
    // 2. If it's in 'general', it's a standard channel_post.
    // 3. If it's a new post in a specific channel, it's a MANIFESTO.
    String determinedType = PostType.channel; 

    if (widget.linkedPostId != null) {
      determinedType = PostType.comment; // It's a reply!
    } else if (widget.channelId != null && widget.channelId != 'general') {
      determinedType = PostType.manifesto; // It's a top-level announcement!
    }

    await ref
        .read(postingControllerProvider.notifier)
        .createPost(
          media: items,
          caption: caption,
          channelId: widget.channelId,
          channelName: widget.channelName,
          isMyChannel: false,
          postType: determinedType,
          linkedPostId: widget.linkedPostId,
          linkedAuthorUsername: widget.linkedAuthorUsername,
          linkedCaption: widget.linkedCaption,
          linkedChannelId: widget.linkedChannelId,
          linkedThumbnailUrls: widget.linkedThumbnailUrl != null
              ? [widget.linkedThumbnailUrl!]
              : null,
        );

    if (widget.linkedPostId != null) {
      ref
          .read(channelFeedProvider(widget.channelId ?? 'general').notifier)
          .incrementCommentCount(widget.linkedPostId!);
    }

    widget.onCommentPosted?.call();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentUser = ref.watch(authControllerProvider).user;

    return DefaultTabController(
      length: 4,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          children: [
            // ── DRAG HANDLE ──
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),

            // ── TITLE ROW ──
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isRecording
                        ? context.tr('recording')
                        : context.tr('select_media'),
                    style: TextStyle(
                      color: _isRecording ? Colors.red : colorScheme.onSurface,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: colorScheme.onSurface),
                  ),
                ],
              ),
            ),

            // 👑 NEW: THE "REPLYING TO" HEADER!
            if (widget.linkedPostId != null)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh.withValues(
                    alpha: 0.4,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border(
                    left: BorderSide(color: colorScheme.primary, width: 4),
                  ),
                ),
                child: Row(
                  children: [
                    if (widget.linkedThumbnailUrl != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: ChartImage(
                          url: widget.linkedThumbnailUrl,
                          width: 40.w,
                          height: 40.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 12.w),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Replying to ${widget.linkedAuthorUsername ?? "Original"}',
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            widget.linkedCaption != null &&
                                    widget.linkedCaption!.isNotEmpty
                                ? widget.linkedCaption!
                                : 'Shared Media',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // ── TAB BAR ──
            TabBar(
              // ... your existing TabBar code ...
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurface.withValues(
                alpha: 0.4,
              ),
              indicatorColor: colorScheme.primary,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w900,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              dividerColor: Colors.transparent,
              tabs: [
                Tab(text: context.tr('gallery_tab')),
                Tab(text: context.tr('device_tab')),
                Tab(text: context.tr('gif_tab')),
                Tab(text: context.tr('members_tab')),
              ],
            ),

            // ── TAB VIEWS ──
            Expanded(
              child: TabBarView(
                // ... your existing TabBarView code ...
                children: [
                  YourDataTab(
                    selectedIndices: _selectedIndices,
                    onMediaTap: _onMediaTap,
                    sampleData: _sampleData,
                  ),
                  DeviceMediaTab(
                    selectedIndices: _selectedIndices,
                    onMediaTap: _onMediaTap,
                  ),
                  GifSelectionTab(
                    selectedIndices: _selectedIndices,
                    onMediaTap: _onMediaTap,
                  ),
                  const ChartedMembersTab(),
                ],
              ),
            ),

            // ── INPUT FIELD ──
            // ── INPUT FIELD ──
            if (widget.showInputField)
              CommentInputField(
                controller: _commentController,
                userImageUrl: currentUser?.profileImageUrl,
                hasMedia: _selectedMediaItems.isNotEmpty,
                onSend: _handlePost,
                onLongPressStart: _startRecording,
                onLongPressEnd: _stopRecording,
              )
            else
              SizedBox(height: MediaQuery.of(context).padding.bottom + 16.h),
          ],
        ),
      ),
    );
  }
}
