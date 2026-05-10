import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/router/app_router.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/features/auth/application/auth_controller.dart';
import 'package:crimchart/features/auth/application/saved_accounts_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as p;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:crimchart/features/showcase/chart_toast.dart';

class AccountSelectorPage extends ConsumerWidget {
  const AccountSelectorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = p.Provider.of<LocalizationProvider>(context);

    final savedAccountsAsync = ref.watch(savedAccountsProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(
        title: '',
        showBorder: false,
        backgroundColor: theme.scaffoldBackgroundColor,
        onBack: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(AppRoutes.landing);
          }
        },
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
                  child: savedAccountsAsync.when(
                    data: (accounts) {
                      if (accounts.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.h),
                            child: Text(
                              'No saved accounts',
                              style: TextStyle(color: colorScheme.onSurface),
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: accounts.asMap().entries.map((entry) {
                          return _buildAccountCard(
                            context,
                            ref,
                            entry.value,
                            colorScheme,
                            entry.key == 0,
                            localization,
                          );
                        }).toList(),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) => Center(
                      child: Text(
                        'Error loading accounts',
                        style: TextStyle(color: colorScheme.error),
                      ),
                    ),
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
                                'Email',
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
    BuildContext context,
    WidgetRef ref,
    SavedAccount account,
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
                            account.name,
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
                    if (account.notificationsCount > 0) ...[
                      SizedBox(height: 4.h),
                      Text(
                        '${account.notificationsCount} ${localization.tr('notifications_count')}',
                        style: TextStyle(
                          color: colorScheme.primary,
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
                onPressed: () async {
                  final success = await ref
                      .read(authControllerProvider.notifier)
                      .switchAccount(account.id);
                  if (success && context.mounted) {
                    context.go(AppRoutes.feed);
                  } else if (!success && context.mounted) {
                    final errorMessage = ref
                        .read(authControllerProvider)
                        .errorMessage;
                    if (errorMessage != null) {
                      ChartToast.showError(
                        context,
                        title: 'Notice',
                        message: errorMessage,
                      );
                    }
                  }
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

  Widget _buildAvatar(SavedAccount account, ColorScheme colorScheme) {
    final avatarUrl = account.avatar;
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
