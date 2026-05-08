import 'package:crimchart/features/auth/application/auth_controller.dart';
import 'package:crimchart/signing/photo_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/router/app_router.dart';
import 'package:crimchart/core/utils/responsive_size.dart';

import 'package:lucide_icons/lucide_icons.dart';

class ProfilePicturePage extends ConsumerStatefulWidget {
  const ProfilePicturePage({super.key});

  @override
  ConsumerState<ProfilePicturePage> createState() => _ProfilePicturePageState();
}

class _ProfilePicturePageState extends ConsumerState<ProfilePicturePage> {
  bool _isLoading = false;

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
        showBorder: true,
        isLoading: _isLoading,
        actions: [
          TextButton(
            onPressed: _isLoading
                ? null
                : () {
                    // Phase 3: Skip profile picture (Metadata update not required)
                    context.push(AppRoutes.channelIntro);
                  },
            child: Text(
              localization.tr('skip'),
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              if (authState.errorMessage != null)
                Container(
                  padding: EdgeInsets.all(16.w),
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: colorScheme.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.w),
                    border: Border.all(
                      color: colorScheme.error.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    authState.errorMessage!,
                    style: TextStyle(color: colorScheme.error, fontSize: 14.sp),
                    textAlign: TextAlign.center,
                  ),
                ),
              Text(
                localization.tr('profile_picture_title'),
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                localization.tr('profile_picture_subtitle'),
                style: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 14.sp,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 60.h),
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 180.w,
                      height: 180.w,
                      decoration: BoxDecoration(
                        color: colorScheme.onSurface.withOpacity(0.05),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.primary.withOpacity(0.3),
                          width: 4.w,
                        ),
                      ),
                      child: Icon(
                        LucideIcons.user,
                        size: 80.sp,
                        color: colorScheme.onSurface.withOpacity(0.1),
                      ),
                    ),
                    InkWell(
                      onTap: _isLoading
                          ? null
                          : () async {
                              setState(() => _isLoading = true);
                              await Future.delayed(
                                const Duration(milliseconds: 800),
                              );

                              if (!mounted) return;
                              setState(() => _isLoading = false);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PhotoEditPage(),
                                ),
                              );
                            },
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          LucideIcons.camera,
                          color: colorScheme.onPrimary,
                          size: 24.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 80.h),
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          // Phase 3: Proceed to final step (Metadata update handled by photo upload logic)
                          context.push(AppRoutes.channelIntro);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    localization.tr('add_photo'),
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
      ),
    );
  }
}











