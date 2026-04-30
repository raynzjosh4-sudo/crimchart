import 'package:flutter/material.dart';
import 'exportsettings.dart';
import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(title: context.tr('help')),
      body: ListView(
        children: [
          _buildHelpItem(
            context,
            LucideIcons.alertTriangle,
            context.tr('report_problem'),
          ),
          _buildHelpItem(
            context,
            LucideIcons.helpCircle,
            context.tr('help_center'),
          ),
          _buildHelpItem(
            context,
            LucideIcons.shieldCheck,
            context.tr('privacy_security_help'),
          ),
          _buildHelpItem(
            context,
            LucideIcons.messageSquare,
            context.tr('support_requests'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(BuildContext context, IconData icon, String title) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: colorScheme.onSurface, size: 22.sp),
      title: Text(
        title,
        style: TextStyle(color: colorScheme.onSurface, fontSize: 16.sp),
      ),
      trailing: Icon(
        LucideIcons.chevronRight,
        color: colorScheme.onSurface.withOpacity(0.3),
        size: 18.sp,
      ),
      onTap: () {},
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
    );
  }
}











