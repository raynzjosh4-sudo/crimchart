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

class NamePage extends ConsumerStatefulWidget {
  const NamePage({super.key});

  @override
  ConsumerState<NamePage> createState() => _NamePageState();
}

class _NamePageState extends ConsumerState<NamePage> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final pending = ref.read(authControllerProvider).pendingSignUp;
    final savedDisplayName = pending?.displayName ?? '';

    if (savedDisplayName.isNotEmpty) {
      final nameParts = savedDisplayName.split(' ');
      _firstNameController = TextEditingController(text: nameParts.first);
      _lastNameController = TextEditingController(
        text: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
      );
    } else {
      _firstNameController = TextEditingController();
      _lastNameController = TextEditingController();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _extractNameFromEmail();
      });
    }
  }

  void _extractNameFromEmail() {
    // 1. Grab the email you saved in the previous step
    final email = ref.read(authControllerProvider).email;

    if (email != null && email.contains('@')) {
      // 2. Take everything before the '@' symbol
      final usernamePart = email.split('@')[0];

      // 3. Replace common separators (dots, underscores) with spaces
      final cleanName = usernamePart.replaceAll(RegExp(r'[._]'), ' ');

      // 4. Split it into words
      final nameParts = cleanName.split(' ');

      if (nameParts.isNotEmpty) {
        _firstNameController.text =
            nameParts[0].substring(0, 1).toUpperCase() +
            nameParts[0].substring(1); // Capitalize first name

        if (nameParts.length > 1) {
          // If there are more words, combine them for the Last Name
          final lastNameRaw = nameParts.sublist(1).join(' ');
          _lastNameController.text =
              lastNameRaw.substring(0, 1).toUpperCase() +
              lastNameRaw.substring(1);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = Provider.of<LocalizationProvider>(context);

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
              localization.tr('name_title'),
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              localization.tr('name_subtitle'),
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.6),
                fontSize: 14.sp,
                height: 1.4,
              ),
            ),
            SizedBox(height: 32.h),
            _buildTextField(
              localization.tr('first_name'),
              _firstNameController,
            ),
            SizedBox(height: 16.h),
            _buildTextField(localization.tr('last_name'), _lastNameController),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        // --- STRICT VALIDATION START ---
                        final firstName = _firstNameController.text.trim();
                        final lastName = _lastNameController.text.trim();

                        if (firstName.isEmpty || lastName.isEmpty) {
                          ChartToast.showError(
                            context,
                            title: localization.tr('error_title'),
                            message: localization.tr('login_error_empty'),
                          );
                          return; // Stops the function immediately.
                        }
                        // --- STRICT VALIDATION END ---

                        setState(() => _isLoading = true);

                        // Save the confirmed name to Riverpod
                        final displayName = "$firstName $lastName";
                        ref
                            .read(authControllerProvider.notifier)
                            .setDisplayName(displayName);

                        await Future.delayed(const Duration(milliseconds: 300));

                        if (!mounted) return;
                        setState(() => _isLoading = false);

                        // Navigate to the next page using GoRouter
                        context.push(AppRoutes.password);
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

  Widget _buildTextField(String label, TextEditingController controller) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      style: TextStyle(color: colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: colorScheme.onSurface.withOpacity(0.5),
          fontSize: 14.sp,
        ),
        filled: true,
        fillColor: colorScheme.onSurface.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.w),
          borderSide: BorderSide.none,
        ),
        floatingLabelStyle: TextStyle(color: colorScheme.primary),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      ),
    );
  }
}











