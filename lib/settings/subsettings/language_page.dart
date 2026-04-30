import 'package:crown/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'exportsettings.dart';
import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _languages = AppStrings.languages;

  List<Map<String, String>> _filteredLanguages = [];

  @override
  void initState() {
    super.initState();
    _filteredLanguages = _languages;
  }

  void _filterLanguages(String query) {
    setState(() {
      _filteredLanguages = _languages
          .where(
            (lang) =>
                lang['native']!.toLowerCase().contains(query.toLowerCase()) ||
                lang['english']!.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(title: context.tr('select_language')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              controller: _searchController,
              onChanged: _filterLanguages,
              decoration: InputDecoration(
                hintText: context.tr('search_language'),
                prefixIcon: Icon(
                  LucideIcons.search,
                  color: colorScheme.primary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.w),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: colorScheme.onSurface.withOpacity(0.05),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredLanguages.length,
              itemBuilder: (context, index) {
                final lang = _filteredLanguages[index];
                return ListTile(
                  onTap: () {
                    final provider = Provider.of<LocalizationProvider>(
                      context,
                      listen: false,
                    );
                    provider.setLocale(lang['code']!);
                    Navigator.pop(context);
                  },
                  title: Text(
                    lang['native']!,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    lang['english']!,
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.5),
                      fontSize: 14.sp,
                    ),
                  ),
                  trailing:
                      context.watch<LocalizationProvider>().currentLocale ==
                          lang['code']
                      ? Icon(
                          LucideIcons.check,
                          color: colorScheme.primary,
                          size: 20.sp,
                        )
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}











