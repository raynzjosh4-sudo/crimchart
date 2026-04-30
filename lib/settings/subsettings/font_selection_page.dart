import 'package:crown/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'exportsettings.dart';

class FontSelectionPage extends StatelessWidget {
  const FontSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeProvider = Provider.of<ThemeProvider>(context);

    final fonts = [
      {'name': context.tr('font_default'), 'family': 'Inter'},
      {'name': context.tr('font_comic_relief'), 'family': 'Comic Relief'},
      {'name': context.tr('font_archivo_black'), 'family': 'Archivo Black'},
      {
        'name': context.tr('font_playfair_display'),
        'family': 'Playfair Display',
      },
      {
        'name': context.tr('font_roboto_condensed'),
        'family': 'Roboto Condensed',
      },
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(title: context.tr('fonts')),
      body: ListView.builder(
        itemCount: fonts.length,
        itemBuilder: (context, index) {
          final font = fonts[index];
          final isSelected = themeProvider.currentFontFamily == font['family'];

          return ListTile(
            onTap: () => themeProvider.updateFontFamily(font['family']!),
            title: AutoSizeText(
              font['name']!,
              maxLines: 1,
              minFontSize: 12,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                fontFamily: font['family'],
              ),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: AutoSizeText(
                context.tr('Chart_tagline'),
                maxLines: 1,
                style: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 13.sp,
                  fontFamily: font['family'],
                ),
              ),
            ),
            trailing: isSelected
                ? Icon(
                    LucideIcons.check,
                    color: colorScheme.primary,
                    size: 20.sp,
                  )
                : null,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 4.h,
            ),
          );
        },
      ),
    );
  }
}











