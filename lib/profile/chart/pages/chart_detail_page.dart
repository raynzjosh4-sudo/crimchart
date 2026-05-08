import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../models/chart_chart.dart';
import '../models/chart_message.dart';
import '../widgets/chart_bubble.dart';

class ChartDetailPage extends StatefulWidget {
  final ChartChart chart;

  const ChartDetailPage({super.key, required this.chart});

  @override
  State<ChartDetailPage> createState() => _ChartDetailPageState();
}

class _ChartDetailPageState extends State<ChartDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChartMessage> _messages = [
    ChartMessage(
      id: '1',
      content: 'Hey! I saw your latest project, it looks amazing!',
      timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
      isMe: false,
    ),
    ChartMessage(
      id: '2',
      content: 'Thanks! I really appreciate it. Still worTop on some details.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 18)),
      isMe: true,
    ),
    ChartMessage(
      id: '3',
      content: 'Did you see this reference for the UI?',
      type: ChartMessageType.image,
      mediaUrl: 'https://picsum.photos/seed/ui/400/300',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      isMe: false,
    ),
    ChartMessage(
      id: '4',
      content: 'Check out this smooth transition video!',
      type: ChartMessageType.video,
      mediaUrl: 'https://picsum.photos/seed/vid/400/300',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      isMe: false,
    ),
    ChartMessage(
      id: '5',
      content: 'Voice Message',
      type: ChartMessageType.audio,
      duration: '0:22',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isMe: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(
        title: widget.chart.senderName,
        showBack: true,
        actions: [
          IconButton(icon: const Icon(LucideIcons.phone), onPressed: () {}),
          IconButton(icon: const Icon(LucideIcons.video), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChartBubble(message: _messages[index]);
              },
            ),
          ),
          _buildInputArea(theme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildInputArea(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        12.w,
        8.h,
        12.w,
        32.h,
      ), // Extra bottom padding for safe area
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: colorScheme.onSurface.withValues(alpha: 0.1),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              LucideIcons.camera,
              color: colorScheme.onSurface,
              size: 24.sp,
            ),
            onPressed: () {},
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: TextField(
                controller: _messageController,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'Message...',
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              LucideIcons.mic,
              color: colorScheme.onSurface,
              size: 24.sp,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              LucideIcons.image,
              color: colorScheme.onSurface,
              size: 24.sp,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}











