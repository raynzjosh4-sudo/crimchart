import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'animated_send_button.dart';

class CommentInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback? onImageTap;
  final VoidCallback? onLongPressStart;
  final VoidCallback? onLongPressEnd;
  final String? userImageUrl;
  final bool hasMedia;
  final bool showTextField; // 👑 ADDED

  const CommentInputField({
    super.key,
    required this.controller,
    required this.onSend,
    this.onImageTap,
    this.onLongPressStart,
    this.onLongPressEnd,
    this.userImageUrl,
    this.hasMedia = false,
    this.showTextField = true, // 👑 DEFAULT TO TRUE
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 16.h,
        bottom: MediaQuery.of(context).padding.bottom + 16.h,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Text Input
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (showTextField)
                  Expanded(
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: 48.h,
                        maxHeight: 120.h,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.onSurface.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(28.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Post/Camera Icon (on the left now)
                          Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: GestureDetector(
                              onTap: onImageTap,
                              child: Icon(
                                LucideIcons.camera,
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
                                size: 24.sp,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),

                          // Main TextField
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              child: TextField(
                                controller: controller,
                                maxLines: 5,
                                minLines: 1,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: context.tr(
                                    'message',
                                  ), // Update translation key if needed
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  hintStyle: TextStyle(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.4,
                                    ),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  const Spacer(), // 👑 Pushes the button to the right
                SizedBox(width: 8.w),

                // Floating Send/Mic Button
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (context, value, _) {
                    final showSend = value.text.isNotEmpty || hasMedia;

                    return Container(
                      width: 48.r,
                      height: 48.r,
                      decoration: BoxDecoration(
                        color: showSend
                            ? colorScheme.primary
                            : colorScheme.surfaceContainerHighest,
                        shape: BoxShape.circle,
                        boxShadow: [
                          if (showSend)
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                        ],
                      ),
                      child: Center(
                        child: AnimatedSendButton(
                          size: 22.sp,
                          color: showSend ? Colors.white : colorScheme.onSurface.withValues(alpha: 0.5),
                          icon: LucideIcons.send,
                          onTap: showSend ? onSend : () {},
                          onLongPressStart: null,
                          onLongPressEnd: null,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
