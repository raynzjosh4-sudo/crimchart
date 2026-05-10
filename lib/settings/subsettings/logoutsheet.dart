import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/router/app_router.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/features/auth/application/auth_controller.dart';
import 'package:crimchart/features/auth/application/saved_accounts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as p;
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogoutSheet extends ConsumerWidget {
  const LogoutSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = p.Provider.of<LocalizationProvider>(context);

    final savedAccountsAsync = ref.watch(savedAccountsProvider);

    return Container(
      padding: EdgeInsets.only(
        top: 12.h,
        bottom: MediaQuery.of(context).padding.bottom + 20.h,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
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
              color: colorScheme.onSurface.withOpacity(0.1),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          Text(
            localization.tr('log_out'),
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
            ),
          ),

          SizedBox(height: 24.h),

          // Accounts List
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 300.h),
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
                return ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: accounts.length,
                  separatorBuilder: (context, index) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) {
                    final account = accounts[index];
                    return ListTile(
                      onTap: () {
                        ref
                            .read(authControllerProvider.notifier)
                            .switchAccount(account.id);
                        Navigator.pop(context);
                      },
                      leading: CircleAvatar(
                        radius: 20.r,
                        backgroundImage: account.avatar.isNotEmpty
                            ? NetworkImage(account.avatar)
                            : null,
                        child: account.avatar.isEmpty
                            ? Icon(Icons.person, size: 20.r)
                            : null,
                      ),
                      title: Text(
                        account.name,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${account.email} • ${account.notificationsCount} ${localization.tr('notifications_count')}',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: TextButton(
                        onPressed: () {
                          ref
                              .read(authControllerProvider.notifier)
                              .switchAccount(account.id);
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: colorScheme.primary,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          localization.tr('switch').toUpperCase(),
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      contentPadding: EdgeInsets.only(left: 16.w, right: 8.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        side: BorderSide(
                          color: colorScheme.onSurface.withOpacity(0.05),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text(
                  'Error loading accounts',
                  style: TextStyle(color: colorScheme.error),
                ),
              ),
            ),
          ),

          SizedBox(height: 24.h),

          // Final Logout Options
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                _buildLogoutAction(
                  context,
                  localization.tr('log_out').toUpperCase(),
                  color: colorScheme.error,
                  onTap: () => _handleLogout(context, ref),
                ),
                SizedBox(height: 12.h),
                _buildLogoutAction(
                  context,
                  localization.tr('cancel').toUpperCase(),
                  color: colorScheme.onSurface.withOpacity(0.5),
                  onTap: () => Navigator.pop(context),
                  isSecondary: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutAction(
    BuildContext context,
    String text, {
    required Color color,
    required VoidCallback onTap,
    bool isSecondary = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 40.h,
      child: isSecondary
          ? OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: color),
                foregroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.w),
                ),
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  letterSpacing: 1.1,
                ),
              ),
            )
          : ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.w),
                ),
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  letterSpacing: 1.1,
                ),
              ),
            ),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    // 1. Clear session
    await ref.read(authControllerProvider.notifier).logout();

    // 2. Close sheet
    if (context.mounted) Navigator.pop(context);

    // 3. Navigate to Account Selector
    if (context.mounted) context.go(AppRoutes.accountSelector);
  }
}
