import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';
import '../functioning/edit_post_controller.dart';

// ─── Filter Grid ────────────────────────────────────────────────────────────

class FiltersTabView extends StatelessWidget {
  final MediaEditState state;
  final List<String> filters;
  final Widget Function(MediaEditState, {BoxFit fit}) buildMediaImage;
  final void Function(MediaEditState, int) onSelectFilter;

  const FiltersTabView({
    super.key,
    required this.state,
    required this.filters,
    required this.buildMediaImage,
    required this.onSelectFilter,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30.h),
      itemCount: filters.length,
      itemBuilder: (context, index) {
        final isSelected = state.selectedFilterIndex == index;
        return GestureDetector(
          onTap: () => onSelectFilter(state, index),
          child: Container(
            width: 85.w,
            margin: EdgeInsets.only(right: 14.w),
            child: Column(
              children: [
                Text(
                  context.tr(filters[index]),
                  style: TextStyle(
                    color: isSelected
                        ? cs.onSurface
                        : cs.onSurface.withValues(alpha: 0.5),
                    fontSize: 11.5.sp,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  height: 85.h,
                  width: 85.w,
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    border: isSelected
                        ? Border.all(color: cs.primary, width: 2.5)
                        : null,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: cs.primary.withValues(alpha: 0.2),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14.r),
                    child: buildMediaImage(state, fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Adjustments List ───────────────────────────────────────────────────────

class AdjustmentsTabView extends StatelessWidget {
  final MediaEditState state;
  final void Function(MediaEditState, double) onBrightness;
  final void Function(MediaEditState, double) onContrast;
  final void Function(MediaEditState, double) onSaturation;

  const AdjustmentsTabView({
    super.key,
    required this.state,
    required this.onBrightness,
    required this.onContrast,
    required this.onSaturation,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final adjustments = [
      _AdjItem(
        key: 'brightness',
        icon: LucideIcons.sun,
        value: state.brightness,
        min: -0.5,
        max: 0.5,
        onChanged: (v) => onBrightness(state, v),
      ),
      _AdjItem(
        key: 'contrast',
        icon: LucideIcons.contrast,
        value: state.contrast,
        min: 0.5,
        max: 1.5,
        onChanged: (v) => onContrast(state, v),
      ),
      _AdjItem(
        key: 'saturation',
        icon: LucideIcons.droplets,
        value: state.saturation,
        min: 0.0,
        max: 2.0,
        onChanged: (v) => onSaturation(state, v),
      ),
    ];

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      itemCount: adjustments.length,
      itemBuilder: (context, index) {
        final adj = adjustments[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    adj.icon,
                    color: cs.onSurface.withValues(alpha: 0.6),
                    size: 18.sp,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    context.tr(adj.key),
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    adj.value.toStringAsFixed(1),
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.3),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Slider(
                value: adj.value,
                min: adj.min,
                max: adj.max,
                onChanged: adj.onChanged,
                activeColor: cs.primary,
                inactiveColor: cs.onSurface.withValues(alpha: 0.05),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AdjItem {
  final String key;
  final IconData icon;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  const _AdjItem({
    required this.key,
    required this.icon,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });
}

// ─── Trim Controls ──────────────────────────────────────────────────────────

class TrimTabView extends StatelessWidget {
  final MediaEditState state;
  final void Function(MediaEditState, RangeValues) onChanged;
  final String Function(double) formatDuration;

  const TrimTabView({
    super.key,
    required this.state,
    required this.onChanged,
    required this.formatDuration,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    double maxDur =
        state.videoController?.value.duration.inMilliseconds.toDouble() ??
        1000.0;
    if (maxDur <= 0.0) maxDur = 1000.0;
    double cStart = state.trimStart.clamp(0.0, maxDur);
    double cEnd   = state.trimEnd.clamp(0.0, maxDur);
    if (cStart > cEnd) cEnd = cStart;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      child: Column(
        children: [
          Icon(LucideIcons.scissors, color: cs.onSurface.withValues(alpha: 0.6), size: 30.sp),
          SizedBox(height: 20.h),
          Text(
            context.tr('trim_duration'),
            style: TextStyle(color: cs.onSurface, fontSize: 16.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 40.h),
          RangeSlider(
            min: 0.0,
            max: maxDur,
            values: RangeValues(cStart, cEnd),
            onChanged: (v) => onChanged(state, v),
            activeColor: cs.primary,
            inactiveColor: cs.onSurface.withValues(alpha: 0.05),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatDuration(cStart),
                style: TextStyle(color: cs.onSurface.withValues(alpha: 0.3), fontWeight: FontWeight.w600),
              ),
              Text(
                formatDuration(cEnd),
                style: TextStyle(color: cs.onSurface.withValues(alpha: 0.3), fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Volume Controls ────────────────────────────────────────────────────────

class VolumeTabView extends StatelessWidget {
  final MediaEditState state;
  final void Function(MediaEditState, double) onChanged;

  const VolumeTabView({
    super.key,
    required this.state,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      child: Column(
        children: [
          Icon(LucideIcons.volume2, color: cs.onSurface.withValues(alpha: 0.6), size: 30.sp),
          SizedBox(height: 20.h),
          Text(
            context.tr('adjust_volume'),
            style: TextStyle(color: cs.onSurface, fontSize: 16.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 40.h),
          Slider(
            value: state.volume,
            onChanged: (v) => onChanged(state, v),
            activeColor: cs.primary,
            inactiveColor: cs.onSurface.withValues(alpha: 0.05),
          ),
        ],
      ),
    );
  }
}

// ─── Stickers Tab ───────────────────────────────────────────────────────────

class StickersTabView extends StatelessWidget {
  final MediaEditState state;
  final void Function(MediaEditState, String) onAddSticker;

  const StickersTabView({
    super.key,
    required this.state,
    required this.onAddSticker,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: ElevatedButton.icon(
        icon: Icon(LucideIcons.sticker, size: 24.sp),
        label: Text(
          'Add Crimchat Logo',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.r)),
        ),
        onPressed: () => onAddSticker(state, 'assets/icons/playstore.png'),
      ),
    );
  }
}
