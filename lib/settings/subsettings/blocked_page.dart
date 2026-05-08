import 'package:flutter/material.dart';
import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/utils/responsive_size.dart';

class BlockedPage extends StatelessWidget {
  const BlockedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: ChartAppBar(
          title: context.tr('blocked'),
          showBorder: false,
          bottom: TabBar(
            labelColor: colorScheme.onSurface,
            unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.5),
            indicatorColor: colorScheme.onSurface,
            dividerHeight: 0,
            tabs: [
              Tab(text: context.tr('accounts')),
              Tab(text: context.tr('channel')),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildEmptyState(context, context.tr('no_blocked_accounts')),
            _buildEmptyState(context, context.tr('no_blocked_commenters')),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Center(
      child: Text(
        message,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          fontSize: 14.sp,
        ),
      ),
    );
  }
}











