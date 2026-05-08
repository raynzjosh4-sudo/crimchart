import 'package:crimchart/core/db/chart_native_db.dart';
import 'package:crimchart/core/di/injection.dart';
import 'package:crimchart/features/auth/application/auth_controller.dart';
import 'package:crimchart/features/channel/data/sources/channel_remote_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crimchart/profile/models/charter_model.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';
import 'dart:async';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/core/theme/design_system.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../bottom_sheets/select_media_bottom_sheet.dart';
import '../dialogs/microphone_permission_dialog.dart';
import 'voice_message_player.dart';

enum RecordState { none, recording, reviewing }

class ChatInputField extends ConsumerStatefulWidget {
  final String channelId;
  final Function(String) onSubmitted;
  final Function(List<Map<String, String>>)? onMultiMediaSubmitted;

  const ChatInputField({
    super.key,
    required this.channelId,
    required this.onSubmitted,
    this.onMultiMediaSubmitted,
  });

  @override
  ConsumerState<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends ConsumerState<ChatInputField>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  Timer? _typingTimer;
  bool _isTyping = false;

  final AudioRecorder _audioRecorder = AudioRecorder();
  RecordState _recordState = RecordState.none;
  String? _recordPath;
  Timer? _recordTimer;
  int _recordSeconds = 0;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    _controller.addListener(() {
      setState(() {}); // Update icons when text changes
      _handleTyping();
      if (_controller.text.isNotEmpty && !_shakeController.isAnimating) {
        _shakeController.repeat(reverse: true);
      } else if (_controller.text.isEmpty) {
        _shakeController.stop();
        _shakeController.reset();
      }
    });
  }

  void _handleTyping() {
    if (_controller.text.isNotEmpty && !_isTyping) {
      _setTyping(true);
    }

    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 2), () {
      if (_isTyping) {
        _setTyping(false);
      }
    });
  }

  void _setTyping(bool typing) {
    _isTyping = typing;
    final currentUser = ref.read(authControllerProvider).user;
    if (currentUser != null) {
      // 1. Update Local
      getIt<ChartNativeDB>().setTypingStatus(
        channelId: widget.channelId,
        userId: currentUser.id,
        isTyping: typing,
      );

      // 2. Update Remote
      getIt<ChannelRemoteSource>().setPresence(
        channelId: widget.channelId,
        userId: currentUser.id,
        isOnline: true,
        isTyping: typing,
        displayName: currentUser.username,
        avatarUrl: currentUser.profileImageUrl,
      );
    }
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _recordTimer?.cancel();
    _audioRecorder.dispose();
    if (_isTyping) _setTyping(false);
    _controller.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      final hasPermission = await MicrophonePermissionDialog.check(context);
      if (hasPermission) {
        final dir = await getTemporaryDirectory();
        _recordPath =
            '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: _recordPath!,
        );

        setState(() {
          _recordState = RecordState.recording;
          _recordSeconds = 0;
        });

        _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _recordSeconds++;
          });
        });
      }
    } catch (e) {
      debugPrint('Error starting recording: $e');
    }
  }

  Future<void> _stopRecordingForReview() async {
    try {
      _recordTimer?.cancel();
      final path = await _audioRecorder.stop();
      if (path != null) {
        _recordPath = path;
        setState(() {
          _recordState = RecordState.reviewing;
        });
      } else {
        _cancelRecording();
      }
    } catch (e) {
      debugPrint('Error stopping recording for review: $e');
      _cancelRecording();
    }
  }

  void _sendRecording() {
    if (_recordPath != null && widget.onMultiMediaSubmitted != null) {
      widget.onMultiMediaSubmitted!([
        {'url': _recordPath!, 'type': 'audio'},
      ]);
    }
    setState(() {
      _recordState = RecordState.none;
      _recordPath = null;
      _recordSeconds = 0;
    });
  }

  Future<void> _cancelRecording() async {
    try {
      _recordTimer?.cancel();
      if (_recordState == RecordState.recording) {
        await _audioRecorder.stop();
      }
      if (_recordPath != null) {
        final file = File(_recordPath!);
        if (await file.exists()) {
          await file.delete();
        }
      }
    } catch (e) {
      debugPrint('Error canceling recording: $e');
    } finally {
      setState(() {
        _recordState = RecordState.none;
        _recordPath = null;
        _recordSeconds = 0;
      });
    }
  }

  String get _formattedRecordTime {
    final minutes = _recordSeconds ~/ 60;
    final seconds = _recordSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void _handleSubmit() {
    if (_recordState == RecordState.recording) {
      _stopRecordingForReview();
      return;
    } else if (_recordState == RecordState.reviewing) {
      _sendRecording();
      return;
    }

    final text = _controller.text.trim();
    if (text.isEmpty) {
      _startRecording();
      return;
    }

    widget.onSubmitted(text);
    _controller.clear();
  }

  void _handleMemberMention(CharterModel member) {
    final text = _controller.text;
    final mention = '@${member.username} ';
    if (text.isEmpty || text.endsWith(' ')) {
      _controller.text = text + mention;
    } else {
      _controller.text = '$text $mention';
    }
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // ignore: unused_local_variable
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface, // 👑 SOLID BACKGROUND: specific to the input field!
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
          ),
        ),
      ),
      child: Row(
        children: [
          // Folder Icon with better hit testing
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                debugPrint('👑 [ChatInputField] Folder icon tapped');
                SelectMediaBottomSheet.show(
                  context,
                  channelId: widget.channelId,
                  onMediaSubmitted: (items) {
                    debugPrint(
                      '👑 [ChatInputField] Received ${items.length} items from picker',
                    );
                    if (widget.onMultiMediaSubmitted != null) {
                      widget.onMultiMediaSubmitted!(items);
                    } else if (items.isNotEmpty) {
                      widget.onSubmitted(items.first['url']!);
                    }
                  },
                );
              },
              borderRadius: BorderRadius.circular(24.r),
              child: AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, sin(_shakeController.value * pi * 5) * 2),
                    child: Transform.rotate(
                      angle: sin(_shakeController.value * pi * 10) * 0.1,
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          LucideIcons.folder,
                          size: 24.sp,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // Input Field / Recording / Reviewing
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.5),
                    end: Offset.zero,
                  ).animate(animation),
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: _recordState == RecordState.recording
                  ? Container(
                      key: const ValueKey('recording'),
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          AppShapes.cardRadius,
                        ),
                        border: Border.all(
                          color: theme.colorScheme.error.withValues(alpha: 0.3),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.linear,
                            builder: (context, val, child) {
                              return Opacity(
                                opacity: (sin(val * pi * 4) + 1) / 2,
                                child: Icon(
                                  Icons.circle,
                                  color: theme.colorScheme.error,
                                  size: 12.sp,
                                ),
                              );
                            },
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            _formattedRecordTime,
                            style: TextStyle(
                              color: theme.colorScheme.error,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "Recording...",
                            style: TextStyle(
                              color: theme.colorScheme.error.withValues(
                                alpha: 0.7,
                              ),
                              fontSize: 12.sp,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          GestureDetector(
                            onTap: _cancelRecording,
                            child: Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.error.withValues(
                                  alpha: 0.1,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                LucideIcons.trash2,
                                size: 16.sp,
                                color: theme.colorScheme.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : _recordState == RecordState.reviewing
                  ? Container(
                      key: const ValueKey('reviewing'),
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(
                          AppShapes.cardRadius,
                        ),
                        border: Border.all(
                          color: theme.primaryColor.withValues(alpha: 0.3),
                        ),
                      ),
                      padding: EdgeInsets.only(left: 8.w, right: 16.w),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: _cancelRecording,
                            child: Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.error.withValues(
                                  alpha: 0.1,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                LucideIcons.trash2,
                                size: 16.sp,
                                color: theme.colorScheme.error,
                              ),
                            ),
                          ),
                          Expanded(
                            child: VoiceMessagePlayer(
                              url: _recordPath!,
                              isMe:
                                  false, // ensures text/icons use onSurface color
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      key: const ValueKey('input'),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(
                          AppShapes.cardRadius,
                        ),
                      ),
                      child: TextField(
                        controller: _controller,
                        style: TextStyle(fontSize: 14.sp),
                        minLines: 1,
                        maxLines: 5,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          hintStyle: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.4,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
            ),
          ),
          SizedBox(width: 12.w),

          // Send / Stop / Mic Button
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: GestureDetector(
              key: ValueKey(_recordState),
              onTap: _handleSubmit,
              child: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: _recordState == RecordState.recording
                      ? theme.colorScheme.error
                      : theme.primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.diffused(
                    color:
                        (_recordState == RecordState.recording
                                ? theme.colorScheme.error
                                : theme.primaryColor)
                            .withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ),
                child: Icon(
                  _recordState == RecordState.recording
                      ? LucideIcons
                            .square // Stop
                      : (_recordState == RecordState.reviewing
                            ? LucideIcons.send
                            : (_controller.text.isEmpty
                                  ? LucideIcons.mic
                                  : LucideIcons.send)),
                  size: 20.sp,
                  color: _recordState == RecordState.recording
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
