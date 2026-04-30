import 'package:country_picker/country_picker.dart';
import 'package:crown/features/auth/application/auth_controller.dart';
import 'package:crown/features/showcase/chart_toast.dart';
import 'package:crown/signing/google_signin_page.dart';
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

class MobileNumberPage extends ConsumerStatefulWidget {
  const MobileNumberPage({super.key});

  @override
  ConsumerState<MobileNumberPage> createState() => _MobileNumberPageState();
}

class _MobileNumberPageState extends ConsumerState<MobileNumberPage> {
  late final TextEditingController _phoneNumberController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final savedEmail =
        ref.read(authControllerProvider).pendingSignUp?.phoneNumber ?? '';
    _phoneNumberController = TextEditingController(text: savedEmail);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = Provider.of<LocalizationProvider>(context);
    final authState = ref.watch(authControllerProvider);
    final countryCode = authState.pendingSignUp?.countryCode ?? '+1';

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
                localization.tr('mobile_title'),
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                localization.tr('mobile_subtitle'),
                style: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 14.sp,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 32.h),

              // Phone Input Area
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: colorScheme.onSurface.withOpacity(0.15),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12.w),
                  color: colorScheme.surface,
                ),
                child: Row(
                  children: [
                    // Country Code Selector
                    InkWell(
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          onSelect: (Country country) {
                            ref
                                .read(authControllerProvider.notifier)
                                .startSignUp(
                                  countryCode: '+${country.phoneCode}',
                                  countryName: country.name,
                                );
                          },
                        );
                      },
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.w),
                        bottomLeft: Radius.circular(12.w),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              countryCode,
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: colorScheme.onSurface.withOpacity(0.4),
                              size: 18.sp,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Vertical Divider
                    Container(
                      height: 24.h,
                      width: 1.5,
                      color: colorScheme.onSurface.withOpacity(0.1),
                    ),

                    // Phone Input
                    Expanded(
                      child: TextField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                          ),
                          border: InputBorder.none,
                          hintText: '000 000 0000',
                          hintStyle: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.2),
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                          final phone = _phoneNumberController.text.trim();
                          if (phone.isEmpty || phone.length < 7) {
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
                              .setPhoneNumber(phone);

                          // Mock loading
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

              // Bottom Section: Alternate Signup Options & Login
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Use Email
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            context.push(AppRoutes.email);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  LucideIcons.mail,
                                  size: 18.sp,
                                  color: colorScheme.onSurface.withOpacity(0.7),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  localization.tr('email'),
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
                  // Already have account subtext (optional, but keep it clean)
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











