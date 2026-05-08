import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ChartNextButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isVisible;
  final String text;
  final double? width;
  final double? height;

  const ChartNextButton({
    super.key,
    required this.onTap,
    this.isVisible = true,
    this.text = 'Next',
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    // If it's a twin, it's a circle 40x40
    final bool isTwin = width == null && height == null;

    return AnimatedSlide(
      offset: isVisible ? Offset.zero : const Offset(0, 1),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutQuart,
      child: AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isTwin ? 0 : 24.w,
            vertical: isTwin ? 0 : 16.h,
          ),
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isVisible ? onTap : null,
                customBorder: const CircleBorder(),
                child: Container(
                  width: width?.w ?? 40.w,
                  height: height?.h ?? 40.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: isTwin ? BoxShape.circle : BoxShape.rectangle,
                    borderRadius: isTwin ? null : BorderRadius.circular(30.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: isTwin
                        ? Icon(
                            LucideIcons.plus,
                            color: const Color(
                              0xFFE040FB,
                            ), // Matches Chart primary
                            size: 20.sp,
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                text,
                                style: TextStyle(
                                  color: const Color(0xFFE040FB),
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Icon(
                                LucideIcons.plus,
                                color: const Color(0xFFE040FB),
                                size: 20.sp,
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}











