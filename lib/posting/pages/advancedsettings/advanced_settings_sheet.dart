import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AdvancedSettingsSheet extends StatefulWidget {
  final bool isPublic;
  final bool allowComments;
  final ValueChanged<bool>? onPublicChanged;
  final ValueChanged<bool>? onAllowCommentsChanged;

  const AdvancedSettingsSheet({
    super.key,
    required this.isPublic,
    required this.allowComments,
    this.onPublicChanged,
    this.onAllowCommentsChanged,
  });

  @override
  State<AdvancedSettingsSheet> createState() => _AdvancedSettingsSheetState();
}

class _AdvancedSettingsSheetState extends State<AdvancedSettingsSheet> {
  late bool _localIsPublic;
  late bool _localAllowComments;

  @override
  void initState() {
    super.initState();
    _localIsPublic = widget.isPublic;
    _localAllowComments = widget.allowComments;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 20.h,
        top: 10.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 24.h),
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Text(
            context.tr('advanced_settings'),
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 24.h),
          _buildSwitchTile(
            icon: LucideIcons.eye,
            title: context.tr('public'),
            value: _localIsPublic,
            onChanged: (val) {
              if (widget.onPublicChanged != null) {
                setState(() => _localIsPublic = val);
                widget.onPublicChanged!(val);
              }
            },
            colorScheme: colorScheme,
            enabled: widget.onPublicChanged != null,
          ),
          _buildSwitchTile(
            icon: LucideIcons.messageSquare,
            title: context.tr('allow_comments'),
            value: _localAllowComments,
            onChanged: (val) {
              if (widget.onAllowCommentsChanged != null) {
                setState(() => _localAllowComments = val);
                widget.onAllowCommentsChanged!(val);
              }
            },
            colorScheme: colorScheme,
            enabled: widget.onAllowCommentsChanged != null,
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              context.tr('advanced_desc'),
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.4),
                fontSize: 12.sp,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required ColorScheme colorScheme,
    bool enabled = true,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: colorScheme.onSurface.withValues(alpha: 0.7),
        size: 22.sp,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: enabled ? colorScheme.onSurface : colorScheme.onSurface.withValues(alpha: 0.3),
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: Transform.scale(
        scale: 0.8,
        alignment: Alignment.centerRight,
        child: Switch(
          value: value,
          onChanged: enabled ? onChanged : null,
          activeThumbColor: Theme.of(context).primaryColor,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}











