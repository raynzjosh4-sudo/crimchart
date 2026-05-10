import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'animated_send_button.dart';

class CommentInputField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSend;
  final VoidCallback? onImageTap;
  final VoidCallback? onLongPressStart;
  final VoidCallback? onLongPressEnd;
  final String? userImageUrl;
  final bool hasMedia;
  final bool showTextField;
  final bool isTikTokStyle;
  final bool autoFocus;
  final VoidCallback? onTap;

  const CommentInputField({
    super.key,
    required this.controller,
    required this.onSend,
    this.onImageTap,
    this.onLongPressStart,
    this.onLongPressEnd,
    this.userImageUrl,
    this.onTap,
    this.hasMedia = false,
    this.showTextField = true,
    this.isTikTokStyle = false,
    this.autoFocus = false,
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
                        minHeight: isTikTokStyle ? 42.h : 48.h,
                        maxHeight: 120.h,
                      ),
                      decoration: BoxDecoration(
                        color: isTikTokStyle
                            ? Colors.white.withValues(alpha: 0.1)
                            : colorScheme.onSurface.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(
                          isTikTokStyle ? 24.r : 28.r,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Main TextField
                          Expanded(
                            child: TextField(
                              controller: controller,
                              autofocus: autoFocus,
                              readOnly: onTap != null,
                              onTap: onTap,
                              maxLines: 5,
                              minLines: 1,
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                hintText: isTikTokStyle
                                    ? 'Add comment...'
                                    : context.tr('message'),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.h,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          if (isTikTokStyle) ...[
                            GestureDetector(
                              onTap: onImageTap,
                              child: Icon(
                                LucideIcons.camera,
                                size: 22.sp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  )
                else
                  const Spacer(),
                SizedBox(width: 8.w),

                // Send Button
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (context, value, _) {
                    final showSend = value.text.isNotEmpty || hasMedia;

                    if (isTikTokStyle) {
                      return GestureDetector(
                        onTap: showSend ? () => onSend(controller.text) : null,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 8.h,
                          ),
                          child: Icon(
                            LucideIcons.send,
                            color: showSend
                                ? colorScheme.primary
                                : Colors.white24,
                            size: 28.sp,
                          ),
                        ),
                      );
                    }

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
                          color: showSend
                              ? Colors.white
                              : colorScheme.onSurface.withValues(alpha: 0.5),
                          icon: LucideIcons.send,
                          onTap: showSend
                              ? () => onSend(controller.text)
                              : () {},
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
