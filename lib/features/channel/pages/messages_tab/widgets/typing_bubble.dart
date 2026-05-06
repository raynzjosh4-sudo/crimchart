import 'package:flutter/material.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/core/theme/design_system.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/user_model.dart';
import '../bottom_sheets/user_profile_bottom_sheet.dart';

class TypingBubble extends StatelessWidget {
  final ChatUser sender;

  const TypingBubble({super.key, required this.sender});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar
          GestureDetector(
            onTap: () => UserProfileBottomSheet.show(context, sender),
            child: Container(
              width: 32.w,
              height: 32.w,
              margin: EdgeInsets.only(right: 8.w, bottom: 4.h),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: CachedNetworkImageProvider(sender.profileImageUrl),
                  fit: BoxFit.cover,
                ),
                border: Border.all(
                  color: colorScheme.onSurface.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
          ),

          // Bubble
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest, // Solid theme color
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppShapes.cardRadius),
                topRight: Radius.circular(AppShapes.cardRadius),
                bottomLeft: Radius.circular(4.r),
                bottomRight: Radius.circular(AppShapes.cardRadius),
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
                width: 1,
              ),
              boxShadow: AppShadows.diffused(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ),
            child: const TypingDots(),
          ),
        ],
      ),
    );
  }
}

class TypingDots extends StatefulWidget {
  const TypingDots({super.key});

  @override
  State<TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final double delay = index * 0.2;
            final double value = Curves.easeInOut.transform(
              ((_controller.value - delay) % 1.0).clamp(0.0, 1.0),
            );
            final double opacity =
                0.3 + (0.7 * (1.0 - (value - 0.5).abs() * 2));
            final double scale = 0.8 + (0.4 * (1.0 - (value - 0.5).abs() * 2));

            return Container(
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: opacity),
                shape: BoxShape.circle,
              ),
              transform: Matrix4.identity()..scale(scale),
            );
          },
        );
      }),
    );
  }
}
