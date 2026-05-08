import 'package:crimchart/core/widgets/chart_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_size.dart';
import '../../models/chart_message.dart';

class ImageBubble extends StatelessWidget {
  final ChartMessage message;

  const ImageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMe = message.isMe;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isMe
              ? theme.primaryColor.withValues(alpha: 0.5)
              : colorScheme.onSurface.withValues(alpha: 0.1),
          width: 2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: ChartImage(
        url: message.mediaUrl ?? 'https://picsum.photos/400/300',
        fit: BoxFit.cover,
        placeholder: _buildLoading(colorScheme),
      ),
    );
  }

  Widget _buildLoading(ColorScheme colorScheme) {
    return Container(
      width: 200.w,
      height: 150.h,
      color: colorScheme.surfaceContainerHigh,
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}











