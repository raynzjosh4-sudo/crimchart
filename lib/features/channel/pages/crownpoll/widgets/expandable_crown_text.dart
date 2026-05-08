import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';

class ExpandableCrownText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const ExpandableCrownText({super.key, required this.text, required this.style});

  @override
  State<ExpandableCrownText> createState() => _ExpandableCrownTextState();
}

class _ExpandableCrownTextState extends State<ExpandableCrownText> {
  int _maxLines = 2;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(text: widget.text, style: widget.style),
          maxLines: _maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflowing = textPainter.didExceedMaxLines;
        final hasExpanded = _maxLines > 2;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.text,
              maxLines: _maxLines,
              overflow: TextOverflow.ellipsis,
              style: widget.style,
            ),
            if (isOverflowing || hasExpanded)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isOverflowing)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _maxLines += 3;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 2.h, right: 12.w),
                        child: Text(
                          "more",
                          style: TextStyle(
                            fontSize: (widget.style.fontSize ?? 14.sp) - 2.sp,
                            color: widget.style.color?.withValues(alpha: 0.5) ?? Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  if (hasExpanded)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _maxLines = 2;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Text(
                          "less",
                          style: TextStyle(
                            fontSize: (widget.style.fontSize ?? 14.sp) - 2.sp,
                            color: widget.style.color?.withValues(alpha: 0.5) ?? Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        );
      },
    );
  }
}
