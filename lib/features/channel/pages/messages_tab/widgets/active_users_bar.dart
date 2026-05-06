import 'package:cached_network_image/cached_network_image.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../bottom_sheets/user_profile_bottom_sheet.dart';

class ActiveUsersBar extends StatefulWidget {
  final List<ChatUser> users;
  final Set<String> onlineUserIds;
  final Map<String, bool> typingMap;

  const ActiveUsersBar({
    super.key,
    required this.users,
    this.onlineUserIds = const {},
    this.typingMap = const {},
  });

  @override
  State<ActiveUsersBar> createState() => _ActiveUsersBarState();
}

class _ActiveUsersBarState extends State<ActiveUsersBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _flashController;
  late Animation<double> _flashAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _flashController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _flashAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _flashController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _flashController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.h,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: widget.users.length,
        itemBuilder: (context, index) {
          final user = widget.users[index];
          final isOnline = widget.onlineUserIds.contains(user.id);
          final isTyping = widget.typingMap[user.id] == true;

          return _ActiveUserItem(
            user: user,
            flashAnimation: _flashAnimation,
            pulseAnimation: _pulseAnimation,
            isOnline: isOnline,
            isTyping: isTyping,
          );
        },
      ),
    );
  }
}

class _ActiveUserItem extends StatelessWidget {
  final ChatUser user;
  final Animation<double> flashAnimation;
  final Animation<double> pulseAnimation;
  final bool isOnline;
  final bool isTyping;

  const _ActiveUserItem({
    required this.user,
    required this.flashAnimation,
    required this.pulseAnimation,
    this.isOnline = false,
    this.isTyping = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () => UserProfileBottomSheet.show(context, user),
      child: Padding(
        padding: EdgeInsets.only(right: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar with online dot and typing indicator
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Pulsing Border if typing
                AnimatedBuilder(
                  animation: flashAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 52.w,
                      height: 52.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isTyping
                              ? Colors.greenAccent.withValues(
                                alpha: flashAnimation.value,
                              )
                              : isOnline
                              ? Colors.greenAccent
                              : theme.primaryColor.withValues(alpha: 0.3),
                          width: 2.w,
                        ),
                      ),
                      child: child,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            user.profileImageUrl,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),

                // Typing Bubble (WhatsApp style)
                if (isTyping)
                  Positioned(
                    top: -12.h,
                    left: 0,
                    right: 0,
                    child: ScaleTransition(
                      scale: pulseAnimation,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.chat_bubble,
                            size: 10.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),

                // Green online dot (if online but NOT typing, or both)
                if (isOnline && !isTyping)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.scaffoldBackgroundColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 4.h),

            // Name + Verified Badge
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    user.name.split(' ')[0],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                if (user.isVerified) ...[
                  SizedBox(width: 2.w),
                  Icon(Icons.verified, size: 10.sp, color: Colors.blueAccent),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
