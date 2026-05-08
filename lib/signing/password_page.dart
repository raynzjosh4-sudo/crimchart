import 'dart:math';

import 'package:crimchart/features/auth/application/auth_controller.dart';
import 'package:crimchart/features/showcase/chart_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:password_strength_checker/password_strength_checker.dart';
import 'package:provider/provider.dart';
import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/router/app_router.dart';
import 'package:crimchart/core/utils/responsive_size.dart';

import 'package:lucide_icons/lucide_icons.dart';

class PasswordPage extends ConsumerStatefulWidget {
  const PasswordPage({super.key});

  @override
  ConsumerState<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends ConsumerState<PasswordPage> {
  late final TextEditingController _passwordController;
  final _strengthNotifier = ValueNotifier<PasswordStrength?>(null);
  bool _obscureText = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final savedPassword =
        ref.read(authControllerProvider).pendingSignUp?.password ?? '';
    _passwordController = TextEditingController(text: savedPassword);
    if (savedPassword.isNotEmpty) {
      _strengthNotifier.value = PasswordStrength.calculate(text: savedPassword);
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _strengthNotifier.dispose();
    super.dispose();
  }

  // Helper function to auto-generate a secure password
  void _generateStrongPassword() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$&*~';
    final random = Random.secure();
    // Generate a 16-character password
    final password = List.generate(
      16,
      (index) => chars[random.nextInt(chars.length)],
    ).join();

    setState(() {
      _passwordController.text = password;
      _obscureText =
          false; // Briefly show it so they can see what was generated
      _strengthNotifier.value = PasswordStrength.calculate(text: password);
    });

    final localization = Provider.of<LocalizationProvider>(
      context,
      listen: false,
    );
    ChartToast.showInfo(
      context,
      title: localization.tr('password_generated_title'),
      message: localization.tr('password_generated_message'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = Provider.of<LocalizationProvider>(context);

    // Enforce Minimum Strength for the Next button
    final bool isPasswordValid =
        _strengthNotifier.value != null &&
        (_strengthNotifier.value == PasswordStrength.strong ||
            _strengthNotifier.value == PasswordStrength.secure);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(title: '', showBorder: true, isLoading: _isLoading),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              localization.tr('password_title'),
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              localization.tr('password_subtitle'),
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.6),
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 24.h),
            TextField(
              controller: _passwordController,
              obscureText: _obscureText,
              onChanged: (value) {
                _strengthNotifier.value = PasswordStrength.calculate(
                  text: value,
                );
                setState(() {}); // Rebuild to update button state
              },
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                labelText: localization.tr('password'),
                labelStyle: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.5),
                ),
                filled: true,
                fillColor: colorScheme.onSurface.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.w),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? LucideIcons.eye : LucideIcons.eyeOff,
                    color: colorScheme.onSurface.withOpacity(0.5),
                    size: 20.sp,
                  ),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Password Strength Indicator fixed to use ValueNotifier
            PasswordStrengthChecker(strength: _strengthNotifier),
            SizedBox(height: 8.h),
            Text(
              localization.tr('password_requirement_strong'),
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.4),
                fontSize: 12.sp,
              ),
            ),

            SizedBox(height: 8.h),
            // The Auto-Generate Button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _generateStrongPassword,
                icon: Icon(
                  LucideIcons.key,
                  size: 16.sp,
                  color: colorScheme.primary,
                ),
                label: Text(
                  localization.tr('password_auto_generate'),
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: (_isLoading || !isPasswordValid)
                    ? null
                    : () async {
                        setState(() => _isLoading = true);

                        final notifier = ref.read(
                          authControllerProvider.notifier,
                        );

                        // 1. Save Password to memory
                        notifier.setPassword(_passwordController.text);

                        // 2. Trigger Official Signup in Supabase (Phase 2)
                        // This bundles Country, Email, Name, and Password.
                        final success = await notifier.completeSignUp();

                        if (!mounted) return;
                        setState(() => _isLoading = false);

                        if (success) {
                          // Success! User is now officially created and logged in.
                          // Move to Phase 3: Metadata Updates
                          context.push(AppRoutes.birthday);
                        } else {
                          // Handle Error
                          final authState = ref.read(authControllerProvider);
                          ChartToast.showError(
                            context,
                            title: localization.tr('error_title'),
                            message: authState.errorMessage!,
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  disabledBackgroundColor: colorScheme.onSurface.withOpacity(
                    0.1,
                  ),
                  elevation: 0,
                ),
                child: Text(
                  localization.tr('next'),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}











