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

class BirthdayPage extends ConsumerStatefulWidget {
  const BirthdayPage({super.key});

  @override
  ConsumerState<BirthdayPage> createState() => _BirthdayPageState();
}

class _BirthdayPageState extends ConsumerState<BirthdayPage> {
  late DateTime _selectedDate;
  late DateTime _maxDate;
  String? _selectedGender;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // 1. Set the maximum allowed date to exactly 13 years ago today
    _maxDate = DateTime(now.year - 13, now.month, now.day);

    final savedDate = ref.read(authControllerProvider).pendingSignUp?.birthday;
    final savedGender = ref.read(authControllerProvider).pendingSignUp?.gender;

    _selectedDate = savedDate ?? _maxDate;
    _selectedGender = savedGender;
  }

  // 2. Helper function to calculate exact age
  int _calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1 ||
        (month1 == month2 && birthDate.day > currentDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = Provider.of<LocalizationProvider>(context);

    final genders = [
      {'id': 'male', 'label': localization.tr('male'), 'icon': Icons.male},
      {
        'id': 'female',
        'label': localization.tr('female'),
        'icon': Icons.female,
      },
      {
        'id': 'other',
        'label': localization.tr('other'),
        'icon': Icons.person_outline,
      },
    ];

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
              localization.tr('birthday_title'),
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              localization.tr('birthday_subtitle'),
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.6),
                fontSize: 14.sp,
                height: 1.4,
              ),
            ),
            SizedBox(height: 32.h),
            Center(
              child: SizedBox(
                height: 160.h,
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: _selectedDate,
                    // The date picker won't let them scroll past 13 years ago
                    maximumDate: _maxDate,
                    onDateTimeChanged: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              localization.tr('select_gender'),
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: genders.map((gender) {
                final isSelected = _selectedGender == gender['id'];
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedGender = gender['id'] as String;
                        });
                      },
                      borderRadius: BorderRadius.circular(12.w),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primary.withOpacity(0.1)
                              : colorScheme.onSurface.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12.w),
                          border: Border.all(
                            color: isSelected
                                ? colorScheme.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              gender['icon'] as IconData,
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.onSurface.withOpacity(0.5),
                              size: 20.sp,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              gender['label'] as String,
                              style: TextStyle(
                                color: isSelected
                                    ? colorScheme.onSurface
                                    : colorScheme.onSurface.withOpacity(0.5),
                                fontSize: 12.sp,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                // Button is completely disabled if they haven't picked a gender
                onPressed: (_selectedGender == null || _isLoading)
                    ? null
                    : () async {
                        // --- STRICT VALIDATION START ---
                        final age = _calculateAge(_selectedDate);
                        if (age < 13) {
                          ChartToast.showError(
                            context,
                            title: localization.tr('birthday_error_age_title'),
                            message: localization.tr(
                              'birthday_error_age_message',
                            ),
                          );
                          return; // Stop the function here
                        }
                        // --- STRICT VALIDATION END ---

                        setState(() => _isLoading = true);

                        // Phase 3: Live Update to Database
                        final success = await ref
                            .read(authControllerProvider.notifier)
                            .updateProfile({
                              'birthday': _selectedDate.toIso8601String(),
                              'gender': _selectedGender,
                            });

                        if (!mounted) return;
                        setState(() => _isLoading = false);

                        if (success) {
                          context.push(AppRoutes.ChartTitle);
                        } else {
                          final error = ref
                              .read(authControllerProvider)
                              .errorMessage;
                          ChartToast.showError(
                            context,
                            title: localization.tr(
                              'birthday_error_update_title',
                            ),
                            message:
                                error ??
                                localization.tr(
                                  'birthday_error_update_message',
                                ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: colorScheme.onSurface.withOpacity(
                    0.1,
                  ),
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











