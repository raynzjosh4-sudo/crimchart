import 'dart:io';

import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';

class GoogleSignInPage extends StatefulWidget {
  const GoogleSignInPage({super.key});

  @override
  State<GoogleSignInPage> createState() => _GoogleSignInPageState();
}

class _GoogleSignInPageState extends State<GoogleSignInPage> {
  bool _loading = true;
  String? _error;
  List<String> _emails = [];

  @override
  void initState() {
    super.initState();
    _loadDeviceAccounts();
  }

  static const MethodChannel _accountChannel = MethodChannel(
    'Chart.dev/account',
  );

  Future<void> _loadDeviceAccounts() async {
    final localization = Provider.of<LocalizationProvider>(
      context,
      listen: false,
    );
    if (!Platform.isAndroid) {
      setState(() {
        _loading = false;
        _error = localization.tr('google_android_only');
      });
      return;
    }

    try {
      final List<dynamic>? accounts = await _accountChannel.invokeMethod(
        'getAccount',
      );
      final mapped = (accounts ?? <dynamic>[])
          .whereType<String>()
          .where((email) => email.contains('@'))
          .toSet()
          .toList();

      setState(() {
        _emails = mapped;
        _loading = false;
        if (_emails.isEmpty) {
          _error = localization.tr('google_no_accounts');
        }
      });
    } on PlatformException catch (e) {
      setState(() {
        _loading = false;
        _error = '${localization.tr('google_error_reading')}: ${e.message}';
        _emails = [];
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = '${localization.tr('google_error_reading')}: $e';
        _emails = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = Provider.of<LocalizationProvider>(context);
    final isDark = theme.brightness == Brightness.dark;

    final accountWidgets = _emails.map((email) {
      final initials = email.isNotEmpty ? email[0].toUpperCase() : 'A';
      return Column(
        children: [
          _buildAccountTile(
            name: email.split('@').first,
            email: email,
            avatarInitial: initials,
            avatarColor: Colors.blue,
            theme: theme,
          ),
          Divider(height: 1, color: isDark ? Colors.white10 : Colors.black12),
        ],
      );
    }).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            LucideIcons.chevronLeft,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: 40.h),
                  Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Google_2015_logo.svg/1200px-Google_2015_logo.svg.png',
                    height: 32.h,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    localization.tr('choose_account'),
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${localization.tr('continue_to')} ',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        'Chart',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),

            Expanded(
              child: _loading
                  ? Center(child: CircularProgressIndicator())
                  : _emails.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: Text(
                          _error ?? localization.tr('google_no_accounts'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    )
                  : ListView(
                      padding: EdgeInsets.zero,
                      children: accountWidgets,
                    ),
            ),

            ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 32.w,
                vertical: 8.h,
              ),
              leading: Icon(
                LucideIcons.userPlus,
                size: 20.sp,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              title: Text(
                localization.tr('use_another'),
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(height: 1, color: isDark ? Colors.white10 : Colors.black12),

            Padding(
              padding: EdgeInsets.all(24.w),
              child: Text(
                localization.tr('google_privacy_notice'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 12.sp,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountTile({
    required String name,
    required String email,
    required String avatarInitial,
    required Color avatarColor,
    required ThemeData theme,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
      leading: CircleAvatar(
        radius: 16.w,
        backgroundColor: avatarColor,
        child: Text(
          avatarInitial,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        name,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        email,
        style: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.7),
          fontSize: 12.sp,
        ),
      ),
      onTap: () {
        Navigator.pop(context, email);
      },
    );
  }
}











