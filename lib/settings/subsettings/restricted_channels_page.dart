import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'exportsettings.dart';

class RestrictedChannelsPage extends StatefulWidget {
  const RestrictedChannelsPage({super.key});

  @override
  State<RestrictedChannelsPage> createState() => _RestrictedChannelsPageState();
}

class _RestrictedChannelsPageState extends State<RestrictedChannelsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(
        title: context.tr('restricted_channels'),
        showBorder: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              context.tr('protect_interaction_desc'),
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.6),
                fontSize: 14.sp,
                height: 1.4,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: colorScheme.onSurface, fontSize: 15.sp),
                decoration: InputDecoration(
                  hintText: context.tr('search'),
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.3),
                  ),
                  prefixIcon: Icon(
                    LucideIcons.search,
                    size: 18.sp,
                    color: colorScheme.onSurface.withOpacity(0.3),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.onSurface.withOpacity(0.1),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      LucideIcons.minusCircle,
                      size: 40.sp,
                      color: colorScheme.onSurface.withOpacity(0.2),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    context.tr('no_restricted_channels'),
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Text(
                      context.tr('restrict_channel_desc'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.5),
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}











