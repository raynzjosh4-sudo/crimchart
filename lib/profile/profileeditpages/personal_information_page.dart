import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/features/auth/application/auth_controller.dart';
import 'package:crown/features/showcase/chart_toast.dart';
import 'package:flutter/material.dart';

import 'package:lucide_icons/lucide_icons.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';

class PersonalInformationPage extends ConsumerStatefulWidget {
  const PersonalInformationPage({super.key});

  @override
  ConsumerState<PersonalInformationPage> createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState
    extends ConsumerState<PersonalInformationPage> {
  DateTime? _selectedBirthday;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authControllerProvider).user;
    _selectedBirthday = user?.birthday;
    _selectedGender = user?.gender;
  }

  String get _birthdayText {
    if (_selectedBirthday == null) return 'Not set';
    return DateFormat('MMM dd, yyyy').format(_selectedBirthday!);
  }

  Future<void> _selectDate(BuildContext context) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthday ?? DateTime(1995, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: colorScheme.copyWith(
              surface: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedBirthday = picked;
      });
    }
  }

  void _selectGender(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.tr('select_gender'),
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w900,
                  fontSize: 11.sp,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 16.h),
              ...[
                context.tr('male'),
                context.tr('female'),
                context.tr('non_binary'),
                context.tr('prefer_not_to_say'),
              ].map(
                (gender) => ListTile(
                  title: Text(
                    gender,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 16.sp,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedGender = gender;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleSave() async {
    final updates = {
      'birthday': _selectedBirthday?.toIso8601String(),
      'gender': _selectedGender,
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

    // We'll show the auth email as the primary email for now
    final userEmail = (state.email?.isNotEmpty ?? false)
        ? state.email!
        : 'No email';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(
        title: context.tr('personal_info_title'),
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
        padding: EdgeInsets.symmetric(vertical: 24.h),
        children: [
          _buildSectionHeader(context.tr('basic_details')),
          _buildCapsuleField(
            label: context.tr('birthday'),
            value: _birthdayText,
            onTap: () => _selectDate(context),
          ),
          _buildCapsuleField(
            label: context.tr('gender'),
            value: _selectedGender ?? 'Not specified',
            onTap: () => _selectGender(context),
          ),

          SizedBox(height: 24.h),
          _buildSectionHeader(context.tr('email_addresses')),
          _buildEmailItem(userEmail, isPrimary: true, isHidden: false),
          _buildAddButton(context.tr('add_email')),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 12.h),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: colorScheme.onSurface.withValues(alpha: 0.4),
          fontWeight: FontWeight.w900,
          fontSize: 11.sp,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildCapsuleField({
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 6.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
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
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                value,
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                LucideIcons.chevronRight,
                color: colorScheme.onSurface.withValues(alpha: 0.2),
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailItem(
    String email, {
    bool isPrimary = false,
    bool isHidden = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 6.h),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: colorScheme.onSurface.withValues(alpha: isDark ? 0.08 : 0.04),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: colorScheme.onSurface.withValues(alpha: 0.05),
            width: 0.8,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w900,
                      fontSize: 14.sp,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                if (isPrimary)
                  Container(
                    margin: EdgeInsets.only(left: 8.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      context.tr('primary_tag'),
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                _buildSmallAction(
                  icon: isHidden ? LucideIcons.eyeOff : LucideIcons.eye,
                  label: isHidden ? context.tr('hidden') : context.tr('public'),
                  active: isHidden,
                  onTap: () {},
                ),
                SizedBox(width: 20.w),
                _buildSmallAction(
                  icon: LucideIcons.star,
                  label: context.tr('primary_tag'),
                  active: isPrimary,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallAction({
    required IconData icon,
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14.sp,
            color: active
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              color: active
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.4),
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(String label, {VoidCallback? onTap}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(LucideIcons.plus, size: 16.sp, color: colorScheme.primary),
        label: Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.w900,
              fontSize: 13.5.sp,
            ),
          ),
        ),
        style: TextButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}











