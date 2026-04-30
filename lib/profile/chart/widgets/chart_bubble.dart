import 'package:flutter/material.dart';
import '../models/chart_message.dart';
import '../../../../core/utils/responsive_size.dart';
import 'bubbles/text_bubble.dart';
import 'bubbles/image_bubble.dart';
import 'bubbles/video_bubble.dart';
import 'bubbles/audio_bubble.dart';

class ChartBubble extends StatelessWidget {
  final ChartMessage message;

  const ChartBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMe = message.isMe;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            _buildContent(),
            SizedBox(height: 4.h),
            Text(
              '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 10.sp,
                color: colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (message.type) {
      case ChartMessageType.text:
        return TextBubble(message: message);
      case ChartMessageType.image:
        return ImageBubble(message: message);
      case ChartMessageType.video:
        return VideoBubble(message: message);
      case ChartMessageType.audio:
        return AudioBubble(message: message);
    }
  }
}





























