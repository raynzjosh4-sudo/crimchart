import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/router/app_router.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AccountSelectorPage extends StatelessWidget {
  const AccountSelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = Provider.of<LocalizationProvider>(context);

    // Dummy accounts list - in a real app, these would come from local storage
    final List<Map<String, dynamic>> savedAccounts = [
      {
        'id': '1',
        'name': 'Josh',
        'subtext': '4 ${localization.tr('notifications_count')}',
        'avatar': 'https://i.pravatar.cc/150?u=josh1',
      },
      {
        'id': '2',
        'name': 'Josh raynz',
        'subtext': '21 ${localization.tr('notifications_count')}',
        'avatar': 'https://i.pravatar.cc/150?u=josh2',
      },
      {
        'id': '3',
        'name': 'joshreinz',
        'subtext': '',
        'avatar': 'https://i.pravatar.cc/150?u=josh3',
      },
      {'id': '4', 'name': 'raynzjosh4@gmail.com', 'subtext': '', 'avatar': ''},
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(
        title: '',
        showBorder: false,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Background Radial Glow for depth
            Positioned(
              top: -50.h,
              left: 20.w,
              right: 20.w,
              child: Container(
                height: 300.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(height: 48.h),

                // Centered Chart Logo
                Center(
                  child: SizedBox(
                    width: 100.w,
                    height: 100.w,
                    child: Image.asset(
                      'assets/icons/playstore.png',
                      width: 80.w,
                      height: 80.w,
                    ),
                  ),
                ),

                SizedBox(height: 48.h),

                // Accounts List
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: savedAccounts.asMap().entries.map((entry) {
                      return _buildAccountCard(
                        entry.value,
                        colorScheme,
                        entry.key == 0,
                        localization,
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(
                  height: 100.h,
                ), // Extra space to scroll past the bottom bar
              ],
            ),

            // Bottom Navigation Style Actions (Pinned at bottom)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: theme.scaffoldBackgroundColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: colorScheme.onSurface.withValues(alpha: 0.1),
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Switch accounts
                          Expanded(
                            child: TextButton(
                              onPressed: () => context.push(AppRoutes.login),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                shape: const RoundedRectangleBorder(),
                              ),
                              child: Text(
                                localization.tr('account_selector_switch'),
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          // Divider
                          Container(
                            height: 24.h,
                            width: 1,
                            color: colorScheme.onSurface.withValues(alpha: 0.1),
                          ),
                          // Create account
                          Expanded(
                            child: TextButton(
                              onPressed: () => context.go(AppRoutes.landing),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                shape: const RoundedRectangleBorder(),
                              ),
                              child: Text(
                                localization.tr('account_selector_create'),
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCard(
    Map<String, dynamic> account,
    ColorScheme colorScheme,
    bool isHighlight,
    LocalizationProvider localization,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(20.w),
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            children: [
              // Avatar
              Container(
                padding: EdgeInsets.all(isHighlight ? 2.w : 0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: isHighlight
                      ? Border.all(color: colorScheme.primary, width: 2.w)
                      : null,
                ),
                child: _buildAvatar(account, colorScheme),
              ),

              SizedBox(width: 16.w),

              // Name & Metadata
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            account['name'] as String,
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isHighlight) ...[
                          SizedBox(width: 8.w),
                          Icon(
                            Icons.check_circle,
                            color: colorScheme.primary,
                            size: 16.sp,
                          ),
                        ],
                      ],
                    ),
                    if ((account['subtext'] as String).isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        account['subtext'] as String,
                        style: TextStyle(
                          color: colorScheme.primary.withValues(alpha: 0.8),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Login Button (New Requirement)
              TextButton(
                onPressed: () {
                  // Direct login logic
                },
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  localization.tr('account_selector_login'),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(Map<String, dynamic> account, ColorScheme colorScheme) {
    final avatarUrl = account['avatar'] as String;
    if (avatarUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 28.w,
        backgroundImage: NetworkImage(avatarUrl),
      );
    } else {
      return Container(
        width: 56.w,
        height: 56.w,
        decoration: BoxDecoration(
          color: colorScheme.onSurface.withValues(alpha: 0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(
          LucideIcons.user,
          color: colorScheme.onSurface.withValues(alpha: 0.2),
          size: 24.sp,
        ),
      );
    }
  }
}











