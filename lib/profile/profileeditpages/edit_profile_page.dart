import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/features/auth/application/auth_controller.dart';
import 'package:crimchart/features/showcase/chart_toast.dart';
import 'package:crimchart/features/widgets/memberimage/starter_image.dart';
import 'package:crimchart/profile/profileeditpages/edit_profile_image_page.dart';
import 'package:crimchart/profile/profileeditpages/personal_information_page.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _ChartTitleController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authControllerProvider).user;
    _nameController = TextEditingController(text: user?.displayName ?? '');
    _usernameController = TextEditingController(text: user?.username ?? '');
    _ChartTitleController = TextEditingController(text: user?.ChartTitle ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _ChartTitleController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final updates = {
      'display_name': _nameController.text,
      'username': _usernameController.text,
      'Chart_title': _ChartTitleController.text,
    };

    final success = await ref
        .read(authControllerProvider.notifier)
        .updateProfile(updates);

    if (mounted) {
      if (success) {
        ChartToast.showSuccess(
          context,
          title: context.tr('success', listen: false),
          message: context.tr('profile_updated_success', listen: false),
        );
        Navigator.pop(context);
      } else {
        final error = ref.read(authControllerProvider).errorMessage;
        ChartToast.showError(
          context,
          title: context.tr('error_title', listen: false),
          message: error ?? context.tr('profile_updated_error', listen: false),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(authControllerProvider);
    final user = state.user;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(
        title: context.tr('edit_profile_title'),
        centerTitle: true,
        isLoading: state.isLoading,
        actions: [
          TextButton(
            onPressed: state.isLoading ? null : _handleSave,
            child: Text(
              context.tr('save'),
              style: TextStyle(
                color: state.isLoading
                    ? colorScheme.primary.withValues(alpha: 0.5)
                    : colorScheme.primary,
                fontWeight: FontWeight.w900,
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 30.h),
        children: [
          // Profile Picture Section
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileImagePage(),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.w),
                        child: MemberImage(
                          imageUrl: user?.profileImageUrl,
                          size: 100.w,
                          useHexagon: true,
                          showStatusRing: true,
                          showActiveDot: false,
                        ),
                      ),
                      Positioned(
                        bottom: 4.h,
                        right: 4.w,
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.scaffoldBackgroundColor,
                              width: 2.5,
                            ),
                          ),
                          child: Icon(
                            LucideIcons.camera,
                            size: 14.sp,
                            color: Colors.black, // High contrast on gold
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileImagePage(),
                      ),
                    );
                  },
                  child: Text(
                    context.tr('edit_picture'),
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PersonalInformationPage(),
                      ),
                    );
                  },
                  child: Text(
                    context.tr('personal_info'),
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 13.5.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h),
          // Edit Fields
          _buildEditField(
            label: context.tr('name'),
            controller: _nameController,
            hint: context.tr('edit_name_hint'),
          ),
          _buildEditField(
            label: context.tr('username'),
            controller: _usernameController,
            hint: context.tr('edit_username_hint'),
          ),
          _buildEditField(
            label: context.tr('Chart_title'),
            controller: _ChartTitleController,
            hint: context.tr('edit_chart_title_hint'),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildEditField({
    required String label,
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.4),
              fontWeight: FontWeight.w900,
              fontSize: 11.sp,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(
                alpha: isDark ? 0.08 : 0.04,
              ),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: colorScheme.onSurface.withValues(alpha: 0.05),
                width: 0.8,
              ),
            ),
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 16.h),
                border: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.2),
                  fontSize: 15.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}











