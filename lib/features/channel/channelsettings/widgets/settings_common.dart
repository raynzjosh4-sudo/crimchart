import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';

class SettingsSection extends StatelessWidget {
  final List<Widget> children;
  const SettingsSection({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      color: Theme.of(
        context,
      ).colorScheme.surfaceContainer.withValues(alpha: 0.3),
      child: Column(children: children),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final String? trailingText;
  final Color? color;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.trailingText,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? theme.colorScheme.onSurface.withValues(alpha: 0.7),
        size: 20.sp,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: color ?? theme.colorScheme.onSurface,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                fontSize: 11.sp,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            )
          : null,
      trailing:
          trailing ??
          (trailingText != null
              ? Text(
                  trailingText!,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                )
              : Icon(
                  Icons.chevron_right,
                  size: 18.sp,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                )),
      onTap: onTap ?? () {},
    );
  }
}











