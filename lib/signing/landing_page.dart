import 'package:crown/core/theme/theme_provider.dart';
import 'package:crown/signing/google_signin_page.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/router/app_router.dart';
import 'package:crown/core/utils/responsive_size.dart';

import 'package:lucide_icons/lucide_icons.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = Provider.of<LocalizationProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40), // Spacer
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            themeProvider.updateThemeMode(
                              isDark ? ThemeMode.light : ThemeMode.dark,
                            );
                          },
                          icon: Icon(
                            isDark ? LucideIcons.sun : LucideIcons.moon,
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                            size: 20.sp,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.push(AppRoutes.accountSelector);
                          },
                          style: TextButton.styleFrom(
                            splashFactory: NoSplash.splashFactory,
                            overlayColor: Colors.transparent,
                          ),
                          child: Text(
                            localization.tr('log_in'),
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),

              // Logo/Icon
              Center(
                child: Image.asset(
                  'assets/icons/playstore.png',
                  width: 150.w,
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: 32.h),

              // Language Selector
              GestureDetector(
                onTap: () {
                  context.push(AppRoutes.language);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      localization.tr('language'),
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                      size: 20.sp,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 60.h),

              // Main Buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: () {
                          context.push(AppRoutes.signupCountry);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.w),
                          ),
                        ),
                        child: Text(
                          localization.tr('sign_up'),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Divider
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: colorScheme.onSurface.withValues(alpha: 0.1),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        localization.tr('or'),
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: colorScheme.onSurface.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Try with Google
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GoogleSignInPage(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: Image.network(
                          'https://www.gstatic.com/images/branding/product/2x/googleg_96dp.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        localization.tr('try_with_google'),
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

              SizedBox(height: 40.h),

              // Footer / Terms
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 24.h),
                child: Text.rich(
                  TextSpan(
                    text: 'By continuing, you agree to our ',
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.4),
                      fontSize: 11.sp,
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(
                        text: 'Terms of Service',
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
