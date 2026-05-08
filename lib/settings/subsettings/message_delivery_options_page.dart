import 'package:flutter/material.dart';
import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/utils/responsive_size.dart';

class MessageDeliveryOptionsPage extends StatefulWidget {
  final String titleKey;
  final String descriptionKey;

  const MessageDeliveryOptionsPage({
    super.key,
    required this.titleKey,
    required this.descriptionKey,
  });

  @override
  State<MessageDeliveryOptionsPage> createState() =>
      _MessageDeliveryOptionsPageState();
}

class _MessageDeliveryOptionsPageState
    extends State<MessageDeliveryOptionsPage> {
  String _selectedOption = 'Chart inbox requests';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(title: context.tr(widget.titleKey)),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        children: [
          _buildSectionHeader(context, context.tr('deliver_requests_to')),
          _buildRadioItem(
            'Chart inbox requests',
            context.tr('Chart_inbox_requests'),
          ),
          _buildRadioItem(
            'Don\'t receive Chart inbox requests',
            context.tr('no_receive_inbox_requests'),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              context.tr(widget.descriptionKey),
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.5),
                fontSize: 13.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRadioItem(String value, String displayTitle) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      onTap: () {
        setState(() {
          _selectedOption = value;
        });
      },
      title: Text(
        displayTitle,
        style: TextStyle(color: colorScheme.onSurface, fontSize: 15.sp),
      ),
      trailing: Container(
        width: 20.w,
        height: 20.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: _selectedOption == value
                ? colorScheme.primary
                : colorScheme.onSurface.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: _selectedOption == value
            ? Center(
                child: Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            : null,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
    );
  }
}











