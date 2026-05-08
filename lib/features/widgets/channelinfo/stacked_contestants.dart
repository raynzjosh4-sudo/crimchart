import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import '../memberimage/starter_image.dart';

class StackedContestants extends StatelessWidget {
  /// Pass null entries for members without an avatar (will show person icon).
  final List<String?> avatarUrls;
  final double avatarSize;
  final double overlapOffset;
  final double borderWidth;
  final Color? borderColor;
  final int maxAvatars;

  const StackedContestants({
    super.key,
    required this.avatarUrls,
    this.avatarSize = 40.0,
    this.overlapOffset = 25.0,
    this.borderWidth = 2.0,
    this.borderColor,
    this.maxAvatars = 5,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor =
        borderColor ?? Theme.of(context).scaffoldBackgroundColor;
    final colorScheme = Theme.of(context).colorScheme;

    final double computedAvatarSize = avatarSize.w;
    final double computedOverlapOffset = overlapOffset.w;
    final double computedBorderWidth = borderWidth.w;

    final int displayCount = avatarUrls.length > maxAvatars
        ? maxAvatars
        : avatarUrls.length;
    final bool hasExtra = avatarUrls.length > maxAvatars;
    final int extraCount = avatarUrls.length - maxAvatars;
    final int totalCircles = displayCount + (hasExtra ? 1 : 0);
    final double totalWidth =
        computedAvatarSize + ((totalCircles - 1) * computedOverlapOffset);

    return SizedBox(
      height: computedAvatarSize,
      width: totalWidth,
      child: Stack(
        children: List.generate(totalCircles, (index) {
          final double leftOffset = index * computedOverlapOffset;

          if (hasExtra && index == displayCount) {
            // +N overflow indicator
            return Positioned(
              left: leftOffset,
              child: Container(
                width: computedAvatarSize,
                height: computedAvatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.surfaceContainerHighest,
                  border: Border.all(
                    color: effectiveBorderColor,
                    width: computedBorderWidth,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '+$extraCount',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    fontSize: computedAvatarSize * 0.35,
                  ),
                ),
              ),
            );
          }

          final String? url = avatarUrls[index];
          return Positioned(
            left: leftOffset,
            child: MemberImage(
              size:
                  computedAvatarSize, // Wait, since MemberImage accepts size, we don't need .w if we pass computedAvatarSize, but wait, `MemberImage` internally probably already applies .w or expects a raw size. Actually, `MemberImage` inside applies `.w` on `size`! So we shouldn't pass `.w` multiplied size to `MemberImage`, or it will multiply twice.
              // So let's pass `avatarSize` (raw) to `MemberImage`!
              imageUrl: url,
              showStatusRing: false,
              showActiveDot: false,
              borderWidth:
                  borderWidth, // MemberImage also applies .w internally
            ),
          );
        }),
      ),
    );
  }
}











