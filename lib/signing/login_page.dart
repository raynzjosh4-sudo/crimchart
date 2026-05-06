import 'package:crown/features/auth/application/auth_controller.dart';
import 'package:crown/features/showcase/chart_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/router/app_router.dart';
import 'package:crown/core/utils/responsive_size.dart';

import 'package:lucide_icons/lucide_icons.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final identifier = _identifierController.text.trim();
    final password = _passwordController.text.trim();
    final localization = Provider.of<LocalizationProvider>(
      context,
      listen: false,
    );
    if (identifier.isEmpty || password.isEmpty) {
      ChartToast.showError(
        context,
        title: localization.tr('error_title'),
        message: localization.tr('login_error_empty'),
      );
      return;
    }

    final success = await ref
        .read(authControllerProvider.notifier)
        .login(identifier: identifier, password: password);

    if (success && mounted) {
      context.go(AppRoutes.feed);
    } else if (!success && mounted) {
      final authState = ref.read(authControllerProvider);
      ChartToast.showError(
        context,
        title: localization.tr('error_title'),
        message: authState.errorMessage!
            .replaceAll('Instance of ', '')
            .replaceAll('\'', ''),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = Provider.of<LocalizationProvider>(context);
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(
        title: '',
        showBorder: false,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.h),

                    // Chart Logo with glowing background (Subtle)
                    Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.15),
                            blurRadius: 40.w,
                            spreadRadius: 10.w,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/icons/playstore.png',
                          width: 75.w,
                          height: 75.w,
                        ),
                      ),
                    ),

                    SizedBox(height: 54.h),

                    // Identifier Input
                    _buildInputField(
                      controller: _identifierController,
                      hint: localization.tr('login_identifier_hint'),
                      colorScheme: colorScheme,
                    ),

                    SizedBox(height: 16.h),

                    // Password Input
                    _buildInputField(
                      controller: _passwordController,
                      hint: localization.tr('login_password_hint'),
                      colorScheme: colorScheme,
                      isPassword: true,
                      obscureText: _obscureText,
                      onToggleVisibility: () =>
                          setState(() => _obscureText = !_obscureText),
                    ),

                    SizedBox(height: 20.h),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: authState.isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme
                              .primary, // Keeping Chart Primary Yellow
                          foregroundColor: colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.w),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          localization.tr('log_in'),
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Forgot Password
                    InkWell(
                      onTap: () {},
                      child: Text(
                        localization.tr('login_forgot_password'),
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.8),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // OR Separator
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.4,
                              ),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.15,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 32.h),

                    // Login with Google
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://www.gstatic.com/images/branding/product/2x/googleg_96dp.png',
                          width: 18.w,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          localization.tr('try_with_google'),
                          style: TextStyle(
                            color: colorScheme
                                .primary, // Using brand primary instead of hardcoded blue
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Footer: Create New Account
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Text(
                      localization.tr('login_no_account'),
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.landing),
                    child: Text(
                      localization.tr('login_signup'),
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required ColorScheme colorScheme,
    bool isPassword = false,
    bool? obscureText,
    VoidCallback? onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8.w),
        border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.1)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText ?? false,
        style: TextStyle(color: colorScheme.onSurface, fontSize: 14.sp),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
            color: colorScheme.onSurface.withValues(alpha: 0.3),
            fontSize: 14.sp,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText! ? LucideIcons.eye : LucideIcons.eyeOff,
                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                    size: 18.sp,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
        ),
      ),
    );
  }
}











