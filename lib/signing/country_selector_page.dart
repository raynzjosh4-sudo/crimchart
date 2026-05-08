import 'package:country_picker/country_picker.dart';
import 'package:crimchart/features/auth/application/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/router/app_router.dart';
import 'package:crimchart/core/utils/responsive_size.dart';

import 'package:lucide_icons/lucide_icons.dart';

class CountrySelectorPage extends ConsumerStatefulWidget {
  const CountrySelectorPage({super.key});

  @override
  ConsumerState<CountrySelectorPage> createState() =>
      _CountrySelectorPageState();
}

class _CountrySelectorPageState extends ConsumerState<CountrySelectorPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Country> _countries = [];
  List<Country> _filteredCountries = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _countries = CountryService().getAll();
    _filteredCountries = _countries;
  }

  void _filterCountries(String query) {
    setState(() {
      _filteredCountries = _countries
          .where(
            (country) =>
                country.name.toLowerCase().contains(query.toLowerCase()) ||
                country.phoneCode.contains(query) ||
                country.countryCode.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = Provider.of<LocalizationProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(
        title: localization.tr('select_country'),
        showBorder: true,
        centerTitle: true,
        isLoading: _isLoading,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              controller: _searchController,
              onChanged: _filterCountries,
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: localization.tr('search_country'),
                prefixIcon: Icon(
                  LucideIcons.search,
                  color: colorScheme.onSurface.withOpacity(0.5),
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
              itemCount: _filteredCountries.length,
              itemBuilder: (context, index) {
                final country = _filteredCountries[index];
                return ListTile(
                  onTap: _isLoading
                      ? null
                      : () async {
                          setState(() => _isLoading = true);

                          ref
                              .read(authControllerProvider.notifier)
                              .startSignUp(
                                countryCode: "+${country.phoneCode}",
                                countryName: country.name,
                              );

                          await Future.delayed(
                            const Duration(milliseconds: 300),
                          );

                          if (!mounted) return;
                          setState(() => _isLoading = false);

                          context.push(AppRoutes.phoneNumber);
                        },
                  title: Text(
                    country.name,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Text(
                    "${country.countryCode} +${country.phoneCode}",
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.5),
                      fontSize: 14.sp,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}











