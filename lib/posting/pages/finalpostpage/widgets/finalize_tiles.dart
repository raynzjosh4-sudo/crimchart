import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FinalizeListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const FinalizeListTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(
        icon,
        color: colorScheme.onSurface.withValues(alpha: 0.7),
        size: 22.sp,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
      trailing:
          trailing ??
          Icon(
            LucideIcons.chevronRight,
            color: colorScheme.onSurface.withValues(alpha: 0.2),
            size: 18.sp,
          ),
      onTap: onTap,
    );
  }
}

class FinalizeSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const FinalizeSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(
        icon,
        color: colorScheme.onSurface.withValues(alpha: 0.7),
        size: 22.sp,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: Transform.scale(
        scale: 0.8,
        alignment: Alignment.centerRight,
        child: Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: colorScheme.primary, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}
