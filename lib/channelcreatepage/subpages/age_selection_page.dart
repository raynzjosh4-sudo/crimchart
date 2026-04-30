import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/core/localization/localization_provider.dart';
import 'package:flutter/material.dart';

class AgeSelectionPage extends StatefulWidget {
  final String currentAge;

  const AgeSelectionPage({super.key, required this.currentAge});

  @override
  State<AgeSelectionPage> createState() => _AgeSelectionPageState();
}

class _AgeSelectionPageState extends State<AgeSelectionPage> {
  late String _selectedAge;

  final List<String> _ages = ['All Ages', '13+', '16+', '18+', '21+'];

  @override
  void initState() {
    super.initState();
    _selectedAge = widget.currentAge;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Dynamically update the localized string for 'All Ages'
    final List<String> localizedAges = [
      '${context.tr('all')} Ages',
      '13+',
      '16+',
      '18+',
      '21+',
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(
        title: 'SELECT ${context.tr('age_restriction').toUpperCase()}',
        showBack: true,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: localizedAges.length,
        itemBuilder: (context, index) {
          final age = localizedAges[index];
          // We must map it back to the original format when returning
          final rawAge = _ages[index];

          return RadioListTile<String>(
            title: Text(
              age,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            value: rawAge,
            groupValue: _selectedAge,
            activeColor: colorScheme.primary,
            onChanged: (val) {
              if (val != null) {
                setState(() => _selectedAge = val);
                // Instant close and return value
                Navigator.of(context).pop(val);
              }
            },
          );
        },
      ),
    );
  }
}











