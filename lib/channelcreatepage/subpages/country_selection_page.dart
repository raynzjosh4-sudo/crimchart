import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/core/localization/localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CountrySelectionPage extends StatefulWidget {
  final List<String> currentCountries;

  const CountrySelectionPage({super.key, required this.currentCountries});

  @override
  State<CountrySelectionPage> createState() => _CountrySelectionPageState();
}

class _CountrySelectionPageState extends State<CountrySelectionPage> {
  late Set<String> _selectedCountries;
  List<Country> _allCountries = [];
  List<Country> _filteredCountries = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedCountries = Set.from(widget.currentCountries);
    _allCountries = CountryService().getAll();
    _filteredCountries = _allCountries;

    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        _filteredCountries = _allCountries
            .where((c) => c.name.toLowerCase().contains(query))
            .toList();
      });
    });
  }

  void _toggleCountry(String countryName) {
    setState(() {
      if (countryName == 'Global') {
        _selectedCountries.clear();
        _selectedCountries.add('Global');
      } else {
        _selectedCountries.remove(
          'Global',
        ); // Remove global if a specific country is chosen
        if (_selectedCountries.contains(countryName)) {
          _selectedCountries.remove(countryName);
        } else {
          _selectedCountries.add(countryName);
        }

        // If everything is deselected, fallback to Global
        if (_selectedCountries.isEmpty) {
          _selectedCountries.add('Global');
        }
      }
    });
  }

  void _onSave() {
    Navigator.of(context).pop(_selectedCountries.toList());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(
        title: context.tr('select_countries'),
        showBack: true,
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _onSave,
            child: Text(
              context.tr('done'),
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: context.tr('search_country'),
                hintStyle: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                prefixIcon: Icon(
                  LucideIcons.search,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHigh.withValues(
                  alpha: 0.5,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: _filteredCountries.length + 1, // +1 for Global
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Global Option
                  final isSelected = _selectedCountries.contains('Global');
                  return _buildCountryTile(
                    context.tr('all'),
                    '🌍',
                    isSelected,
                    colorScheme,
                    id: 'Global',
                  );
                }

                final country = _filteredCountries[index - 1];
                final isSelected = _selectedCountries.contains(country.name);
                return _buildCountryTile(
                  country.name,
                  country.flagEmoji,
                  isSelected,
                  colorScheme,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryTile(
    String name,
    String emoji,
    bool isSelected,
    ColorScheme colorScheme, {
    String? id,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Text(emoji, style: const TextStyle(fontSize: 24)),
      title: Text(
        name,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      trailing: isSelected
          ? Icon(LucideIcons.checkCircle2, color: colorScheme.primary)
          : Icon(
              LucideIcons.circle,
              color: colorScheme.onSurface.withValues(alpha: 0.2),
            ),
      onTap: () => _toggleCountry(id ?? name),
    );
  }
}











