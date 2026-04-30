import 'package:crown/profile/models/charter_model.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../features/widgets/memberimage/starter_image.dart';
import '../../../../../core/utils/responsive_size.dart';
import '../../storychacrdwidget/status_page.dart';
import '../../../../../../profile/pages/profile_page.dart';

class TopStarAvatarStack extends StatefulWidget {
  final CharterModel person;
  final List<CharterModel> competitors;
  final Color gold;
  final Function(CharterModel) onSwap;

  // Layout parameters for reusability
  final double width;
  final double height;
  final double mainSize;
  final double competitorScale;
  final double spacing;
  final bool isMainOnRight;
  final GlobalKey? recipientKey;
  final VoidCallback? onLeaderTap;
  final bool showLeaderAddButton;

  const TopStarAvatarStack({
    super.key,
    required this.person,
    required this.competitors,
    required this.gold,
    required this.onSwap,
    this.width = 180,
    this.height = 150,
    this.mainSize = 100,
    this.competitorScale = 0.6,
    this.spacing = 24.0,
    this.isMainOnRight = true,
    this.recipientKey,
    this.onLeaderTap,
    this.showLeaderAddButton = true,
  });

  @override
  State<TopStarAvatarStack> createState() => _TopStarAvatarStackState();
}

class _TopStarAvatarStackState extends State<TopStarAvatarStack> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    // We want to show exactly 3 slots: leader + 2 sides
    final List<CharterModel?> displayItems = [
      widget.person,
      widget.competitors.isNotEmpty ? widget.competitors[0] : null,
      widget.competitors.length > 1 ? widget.competitors[1] : null,
    ];

    final sortedIndices = [1, 2, 0]; // 1 and 2 are sides, 0 is leader

    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Stack(
        clipBehavior: Clip.none,
        children: sortedIndices.map((i) {
          final p = displayItems[i];
          final bool isLeader = i == 0;
          final bool isEmpty = p == null;
          final bool isTicked = _selectedIndex == i;

          double top;
          double left;
          double scale;
          double opacity;
          double turns;

          if (isLeader) {
            top = 28.h;
            left = widget.isMainOnRight
                ? widget.width - widget.mainSize - 10.w
                : 10.w;
            scale = 1.0;
            opacity = 1.0;
            turns = 0;
          } else {
            final int cIndex = i - 1;
            final double smallSize = widget.mainSize * widget.competitorScale;
            top = 50.h;

            if (widget.isMainOnRight) {
              left = 10.w + cIndex * widget.spacing;
            } else {
              left =
                  widget.width - smallSize - 10.w - (cIndex * widget.spacing);
            }

            scale = widget.competitorScale;
            opacity = 1.0;
            turns = (cIndex + 1) * 0.015;
          }

          return AnimatedPositioned(
            key: ValueKey(isLeader ? 'leader' : 'slot_$i'),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOutQuart,
            top: top,
            left: left,
            child: AnimatedRotation(
              turns: turns,
              duration: const Duration(milliseconds: 700),
              child: AnimatedScale(
                scale: scale,
                duration: const Duration(milliseconds: 700),
                child: AnimatedOpacity(
                  opacity: opacity,
                  duration: const Duration(milliseconds: 700),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        if (isLeader) {
                          if (p != null && p.hasStatus) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => StatusPage(
                                  username: p.username,
                                  userProfileImageUrl: p.profileImageUrl,
                                  statusImageUrl: p.profileImageUrl,
                                ),
                              ),
                            );
                          } else if (widget.onLeaderTap != null) {
                            widget.onLeaderTap!.call();
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ProfilePage(),
                              ),
                            );
                          }
                        } else if (!isEmpty) {
                          widget.onSwap(p);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: isLeader
                              ? BoxShape.circle
                              : BoxShape.rectangle,
                          borderRadius: isLeader
                              ? null
                              : BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: widget.gold.withOpacity(
                                isLeader ? 0.35 : 0.0,
                              ),
                              blurRadius: isLeader ? 30.w : 0,
                              spreadRadius: isLeader ? 2.w : 0,
                            ),
                          ],
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            if (!isEmpty)
                              MemberImage(
                                key: isLeader ? widget.recipientKey : null,
                                size: widget.mainSize,
                                imageUrl: p.profileImageUrl,
                                showStatusRing: p.hasStatus,
                                showActiveDot: p.isActive,
                                borderWidth: isLeader ? 3.0.w : 4.0.w,
                              )
                            else
                              Container(
                                width: widget.mainSize,
                                height: widget.mainSize * 1.4,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() => _selectedIndex = i);
                                    },
                                    child: _buildLucidePlusButton(
                                      size: widget.mainSize * 0.35,
                                      bgColor: Colors.white,
                                      iconColor: Colors.amber,
                                      isTicked: isTicked,
                                    ),
                                  ),
                                ),
                              ),

                            if (isLeader) ...[
                              Positioned(
                                top: 5.h,
                                left: -15.w,
                                child: FadeInWidget(
                                  child: Icon(
                                    LucideIcons.gift,
                                    color: Colors.pinkAccent,
                                    size: 16.w,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 25.h,
                                right: -15.w,
                                child: FadeInWidget(
                                  child: Icon(
                                    LucideIcons.gift,
                                    color: Colors.blueAccent,
                                    size: 16.w,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: -28.h,
                                child: FadeInWidget(
                                  child: Icon(
                                    LucideIcons.star,
                                    color: Colors.amber,
                                    size: 28.w,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black26,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: -4.h,
                                child: FadeInWidget(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 3.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: widget.gold,
                                      borderRadius: BorderRadius.circular(10.w),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      '${_formatPoints(widget.person.chartCount)}kp',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatPoints(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return '$count';
  }

  Widget _buildLucidePlusButton({
    required double size,
    required Color bgColor,
    required Color iconColor,
    bool isTicked = false,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Center(
        child: Icon(
          isTicked ? LucideIcons.check : LucideIcons.plus,
          color: iconColor,
          size: size * 0.6,
        ),
      ),
    );
  }
}

class FadeInWidget extends StatelessWidget {
  final Widget child;
  const FadeInWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      builder: (context, opacity, child) {
        return Opacity(opacity: opacity, child: child);
      },
      child: child,
    );
  }
}











