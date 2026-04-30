import 'package:crown/features/auth/application/auth_controller.dart';
import 'package:crown/features/showcase/chart_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/router/app_router.dart';
import 'package:crown/core/utils/responsive_size.dart';

import 'package:lucide_icons/lucide_icons.dart';

class ChartTitlePage extends ConsumerStatefulWidget {
  const ChartTitlePage({super.key});

  @override
  ConsumerState<ChartTitlePage> createState() => _ChartTitlePageState();
}

class _ChartTitlePageState extends ConsumerState<ChartTitlePage> {
  late final TextEditingController _customTitleController;
  String? _selectedTitle;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final savedTitle = ref
        .read(authControllerProvider)
        .pendingSignUp
        ?.ChartTitle;
    _customTitleController = TextEditingController(text: savedTitle ?? '');
    _selectedTitle = savedTitle;
  }

  List<String> _getLocalizedTitles(LocalizationProvider localization) {
    final pending = ref.watch(authControllerProvider).pendingSignUp;
    final country = pending?.countryName ?? 'Unknown';
    final name = pending?.displayName ?? 'User';
    final gender = pending?.gender ?? 'other';
    final code = country.length >= 2
        ? country.substring(0, 2).toUpperCase()
        : country.toUpperCase();

    if (gender == 'male') {
      return [
        "${localization.tr('title_mr')} $country",
        "$name ${localization.tr('title_Top_of')} $country",
        "$name ${localization.tr('title_prince_of')} $country",
        "$name ${localization.tr('title_emperor_of')} $country",
        "${localization.tr('title_best_musician')} of $country",
        "${localization.tr('title_best_footballer')} of $country",
        "$name ${localization.tr('title_legend_of')} $country",
        "$name ${localization.tr('title_star_of')} $country",
        "Top of $code",
        "Hero of $code",
      ];
    } else if (gender == 'female') {
      return [
        "${localization.tr('title_miss')} $country",
        "${localization.tr('title_ms')} $country",
        "$name ${localization.tr('title_Star_of')} $country",
        "$name ${localization.tr('title_princess_of')} $country",
        "$name ${localization.tr('title_empress_of')} $country",
        "${localization.tr('title_best_musician')} of $country",
        "${localization.tr('title_best_footballer')} of $country",
        "$name ${localization.tr('title_legend_of')} $country",
        "$name ${localization.tr('title_star_of')} $country",
        "Star of $code",
      ];
    } else {
      return [
        "${localization.tr('title_mr')}/${localization.tr('title_ms')} $country",
        "$name the Ruler of $country",
        "${localization.tr('title_best_musician')} as the Pride of $country",
        "${localization.tr('title_best_footballer')} as the Pride of $country",
        "$name ${localization.tr('title_legend_of')} $country",
        "$name ${localization.tr('title_star_of')} $country",
        "Global Icon of $code",
        "Noble of $code",
      ];
    }
  }

  @override
  void dispose() {
    _customTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = Provider.of<LocalizationProvider>(context);
    final pending = ref.watch(authControllerProvider).pendingSignUp;
    final gender = pending?.gender ?? 'other';
    final titles = _getLocalizedTitles(localization);

    String questionKey = gender == 'male'
        ? 'male_title_question'
        : (gender == 'female'
              ? 'female_title_question'
              : 'other_title_question');

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(
        title: '',
        showBack: true,
        showBorder: true,
        isLoading: _isLoading,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Text(
                localization.tr('Chart_title_header'),
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                localization.tr(questionKey),
                style: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.8),
                  fontSize: 16.sp,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 40.h),
              Center(
                child: SizedBox(
                  height: 140.h,
                  width: 240.w,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 10.h,
                        right: 30.w,
                        child: CircleAvatar(
                          radius: 35.w,
                          backgroundImage: const NetworkImage(
                            'https://i.pravatar.cc/150?u=1',
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20.h,
                        left: 20.w,
                        child: CircleAvatar(
                          radius: 30.w,
                          backgroundImage: const NetworkImage(
                            'https://i.pravatar.cc/150?u=2',
                          ),
                        ),
                      ),
                      Positioned(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.primary,
                              width: 2.w,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 45.w,
                            backgroundImage: const NetworkImage(
                              'https://i.pravatar.cc/150?u=3',
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        child: Text('👑', style: TextStyle(fontSize: 32.sp)),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 48.h),
              Text(
                localization.tr('suggested_titles'),
                style: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              SizedBox(height: 16.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 12.h,
                children: titles.map((title) {
                  final isSelected =
                      _selectedTitle == title &&
                      _customTitleController.text.isEmpty;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTitle = title;
                        _customTitleController.clear();
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primary.withOpacity(0.1)
                            : colorScheme.onSurface.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(24.w),
                        border: Border.all(
                          color: isSelected
                              ? colorScheme.primary
                              : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              style: TextStyle(
                                color: isSelected
                                    ? colorScheme.onSurface
                                    : colorScheme.onSurface.withOpacity(0.7),
                                fontSize: 13.sp,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (isSelected) ...[
                            SizedBox(width: 8.w),
                            Icon(
                              LucideIcons.check,
                              color: colorScheme.primary,
                              size: 14.sp,
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 24.h),
              TextField(
                controller: _customTitleController,
                onChanged: (val) {
                  setState(() {
                    if (val.isNotEmpty) _selectedTitle = null;
                  });
                },
                style: TextStyle(color: colorScheme.onSurface),
                minLines: 1,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: localization.tr('custom_title_hint'),
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.3),
                  ),
                  filled: true,
                  fillColor: colorScheme.onSurface.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.w),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                ),
              ),
              SizedBox(height: 48.h),
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          final title = _customTitleController.text.isNotEmpty
                              ? _customTitleController.text.trim()
                              : _selectedTitle;

                          // --- STRICT VALIDATION START ---
                          if (title == null || title.isEmpty) {
                            ChartToast.showError(
                              context,
                              title: 'Missing Title',
                              message:
                                  'Please select a suggested title or write your own.',
                            );
                            return;
                          }
                          // --- STRICT VALIDATION END ---

                          setState(() => _isLoading = true);

                          final success = await ref
                              .read(authControllerProvider.notifier)
                              .updateProfile({'Chart_title': title});

                          if (!mounted) return;
                          setState(() => _isLoading = false);

                          if (success) {
                            context.push(AppRoutes.profilePicture);
                          } else {
                            final error = ref
                                .read(authControllerProvider)
                                .errorMessage;
                            ChartToast.showError(
                              context,
                              title: 'Update Failed',
                              message:
                                  error ??
                                  'Could not save title. Please try again.',
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
      ),
    );
  }
}











