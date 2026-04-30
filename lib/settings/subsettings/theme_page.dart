import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/theme/theme_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(title: context.tr('theme')),
      body: ListView(
        children: [
          _buildThemeOption(
            context,
            themeProvider,
            context.tr('light'),
            Icons.light_mode,
            ThemeMode.light,
          ),
          _buildThemeOption(
            context,
            themeProvider,
            context.tr('dark'),
            Icons.dark_mode,
            ThemeMode.dark,
          ),
          _buildThemeOption(
            context,
            themeProvider,
            context.tr('system_default'),
            Icons.settings_brightness,
            ThemeMode.system,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    ThemeProvider themeProvider,
    String title,
    IconData icon,
    ThemeMode mode,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      onTap: () => themeProvider.updateThemeMode(mode),
      leading: Icon(icon, color: colorScheme.onSurface),
      title: Text(
        title,
        style: TextStyle(color: colorScheme.onSurface, fontSize: 16.sp),
      ),
      trailing: Radio<ThemeMode>(
        value: mode,
        groupValue: themeProvider.themeMode,
        activeColor: colorScheme.primary,
        onChanged: (val) {
          if (val != null) themeProvider.updateThemeMode(val);
        },
      ),
    );
  }
}











