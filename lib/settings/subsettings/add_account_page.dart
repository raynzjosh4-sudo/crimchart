import 'package:crimchart/backicon/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/utils/responsive_size.dart';

class AddAccountPage extends StatelessWidget {
  const AddAccountPage({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final accounts = [
      {
        'name': 'Josh raynz',
        'info': '',
        'avatar':
            'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=200',
      },
      {
        'name': 'The Star of China',
        'info': '👑 Chart Title',
        'avatar': 'https://i.pravatar.cc/150?img=11',
      },
      {'name': 'raynzjosh4@gmail.com', 'info': '', 'avatar': ''},
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomBackButton(
                      onPressed: () => Navigator.pop(context),
                      size: 26.sp,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _showLanguageMenu(context);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          context.tr('native_name'),
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.5),
                            fontSize: 13.sp,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: colorScheme.onSurface.withOpacity(0.5),
                          size: 16.sp,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 48.h),

            // Logo removed as per request
            SizedBox(height: 48.h),

            // Account List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                itemCount: accounts.length,
                itemBuilder: (context, index) {
                  final acc = accounts[index];
                  return _buildAccountTile(context, acc);
                },
              ),
            ),

            // Bottom Divider and Buttons
            Divider(height: 1, color: colorScheme.onSurface.withOpacity(0.1)),
            Row(
              children: [
                Expanded(
                  child: _buildBottomButton(
                    context,
                    context.tr('switch_accounts'),
                    onTap: () {},
                  ),
                ),
                Container(
                  width: 1,
                  height: 24.h,
                  color: colorScheme.onSurface.withOpacity(0.1),
                ),
                Expanded(
                  child: _buildBottomButton(
                    context,
                    context.tr('create_account'),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountTile(BuildContext context, Map<String, String> acc) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28.r,
            backgroundColor: colorScheme.onSurface.withOpacity(0.1),
            backgroundImage: acc['avatar']!.isNotEmpty
                ? NetworkImage(acc['avatar']!)
                : null,
            child: acc['avatar']!.isEmpty
                ? Icon(
                    Icons.person,
                    color: colorScheme.onSurface.withOpacity(0.3),
                    size: 28.sp,
                  )
                : null,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  acc['name']!,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (acc['info']!.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Row(
                      children: [
                        if (!acc['info']!.contains('Chart Title'))
                          Container(
                            width: 4.w,
                            height: 4.h,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        if (acc['info']!.contains('Chart Title'))
                          Icon(
                            LucideIcons.star,
                            color: colorScheme.primary,
                            size: 12.sp,
                          ),
                        SizedBox(width: 6.w),
                        Text(
                          acc['info']!,
                          style: TextStyle(
                            color: acc['info']!.contains('Chart Title')
                                ? colorScheme.primary
                                : colorScheme.onSurface.withOpacity(0.4),
                            fontSize: 12.sp,
                            fontWeight: acc['info']!.contains('Chart Title')
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              minimumSize: Size(60.w, 32.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            child: Text(
              context.tr('log_in'),
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 12.w),
          Icon(
            Icons.more_vert,
            color: colorScheme.onSurface.withOpacity(0.5),
            size: 20.sp,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(
    BuildContext context,
    String title, {
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 20.h),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: colorScheme.primary,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showLanguageMenu(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final languages = [
      {'name': 'English (US)', 'selected': true},
      {'name': 'English (UK)', 'selected': false},
      {'name': 'Luganda', 'selected': false},
      {'name': 'Kiswahili', 'selected': false},
      {'name': 'Spanish', 'selected': false},
      {'name': 'French', 'selected': false},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.tr('select_language'),
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    final lang = languages[index];
                    return ListTile(
                      title: Text(
                        lang['name'] as String,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 16.sp,
                        ),
                      ),
                      trailing: lang['selected'] as bool
                          ? Icon(Icons.check, color: colorScheme.primary)
                          : null,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}











