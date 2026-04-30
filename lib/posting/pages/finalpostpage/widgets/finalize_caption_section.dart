import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';

class FinalizeCaptionSection extends StatelessWidget {
  final TextEditingController controller;

  const FinalizeCaptionSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: TextField(
        controller: controller,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        maxLines: null,
        decoration: InputDecoration(
          hintText: context.tr('add_caption'),
          hintStyle: TextStyle(
            color: colorScheme.onSurface.withValues(
              alpha: 0.3,
            ),
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }
}
