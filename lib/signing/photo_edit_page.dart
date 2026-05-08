import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/utils/responsive_size.dart';

import 'package:lucide_icons/lucide_icons.dart';

class PhotoEditPage extends StatefulWidget {
  const PhotoEditPage({super.key});

  @override
  State<PhotoEditPage> createState() => _PhotoEditPageState();
}

class _PhotoEditPageState extends State<PhotoEditPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = Provider.of<LocalizationProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(
        title: localization.tr('gallery_title'),
        showBorder: true,
        isLoading: _isLoading,
        actions: [
          TextButton(
            onPressed: _isLoading
                ? null
                : () async {
                    setState(() => _isLoading = true);
                    await Future.delayed(const Duration(milliseconds: 800));

                    if (!mounted) return;
                    setState(() => _isLoading = false);

                    Navigator.pop(context, true);
                  },
            child: Text(
              localization.tr('save'),
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const Spacer(),
          Center(
            child: Container(
              width: 300.w,
              height: 300.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.onSurface.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: ClipOval(
                child: Container(
                  color: colorScheme.onSurface.withOpacity(0.05),
                  child: Center(
                    child: Icon(
                      LucideIcons.user,
                      color: colorScheme.onSurface.withOpacity(0.1),
                      size: 150.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: _isLoading
                ? null
                : () async {
                    setState(() => _isLoading = true);
                    await Future.delayed(const Duration(milliseconds: 800));

                    if (!mounted) return;
                    setState(() => _isLoading = false);

                    _showGlobalImagePicker(context, localization);
                  },
            child: Text(
              localization.tr('change_photo'),
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.7),
                fontSize: 16.sp,
              ),
            ),
          ),
          SizedBox(height: 60.h),
        ],
      ),
    );
  }

  void _showGlobalImagePicker(
    BuildContext context,
    LocalizationProvider localization,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.w)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                localization.tr('gallery_title'),
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4.w,
                    mainAxisSpacing: 4.h,
                  ),
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorScheme.onSurface.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8.w),
                          ),
                          child: Icon(
                            LucideIcons.camera,
                            color: colorScheme.onSurface,
                            size: 30.sp,
                          ),
                        ),
                      );
                    }
                    return Container(
                      decoration: BoxDecoration(
                        color: colorScheme.onSurface.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8.w),
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://i.pravatar.cc/150?u=$index',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
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











