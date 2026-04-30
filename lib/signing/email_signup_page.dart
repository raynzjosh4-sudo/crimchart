import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/router/app_router.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/features/auth/application/auth_controller.dart';
import 'package:crown/features/showcase/chart_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'google_signin_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;

import 'package:email_validator/email_validator.dart';

class EmailSignupPage extends ConsumerStatefulWidget {
  const EmailSignupPage({super.key});

  @override
  ConsumerState<EmailSignupPage> createState() => _EmailSignupPageState();
}

class _EmailSignupPageState extends ConsumerState<EmailSignupPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = Provider.of<LocalizationProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(title: '', showBorder: true, isLoading: _isLoading),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              Text(
                localization.tr('email_signup_title'),
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                localization.tr('email_signup_subtitle'),
                style: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 14.sp,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 32.h),

              // Email Input Area
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: colorScheme.onSurface.withOpacity(0.15),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12.w),
                  color: colorScheme.surface,
                ),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    border: InputBorder.none,
                    hintText: 'user@example.com',
                    hintStyle: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.2),
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // Next Button
              SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          final email = _emailController.text.trim();
                          if (email.isEmpty ||
                              !EmailValidator.validate(email)) {
                            ChartToast.showError(
                              context,
                              title: localization.tr('error_title'),
                              message: localization.tr('login_error_empty'),
                            );
                            return;
                          }

                          setState(() => _isLoading = true);
                          ref
                              .read(authControllerProvider.notifier)
                              .setEmail(email);

                          await Future.delayed(
                            const Duration(milliseconds: 600),
                          );

                          if (!mounted) return;
                          setState(() => _isLoading = false);
                          context.push(AppRoutes.name);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.w),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    localization.tr('next'),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Bottom Section
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Use Phone
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            context.push(AppRoutes.phoneNumber);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  LucideIcons.phone,
                                  size: 18.sp,
                                  color: colorScheme.onSurface.withOpacity(0.7),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  localization.tr('phone'),
                                  style: TextStyle(
                                    color: colorScheme.onSurface,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Splitter
                      Container(
                        height: 20.h,
                        width: 1,
                        color: colorScheme.onSurface.withOpacity(0.1),
                      ),

                      // Use Google
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GoogleSignInPage(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
                                  width: 18.w,
                                  height: 18.w,
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  localization.tr('google'),
                                  style: TextStyle(
                                    color: colorScheme.onSurface,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Center(
                    child: Text(
                      localization.tr('login_divider').toUpperCase(),
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.4),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Divider(
                    color: colorScheme.onSurface.withOpacity(0.08),
                    thickness: 1.0,
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        localization.tr('already_have_account'),
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.5),
                          fontSize: 13.sp,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.login),
                        child: Text(
                          localization.tr('login_action'),
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}











