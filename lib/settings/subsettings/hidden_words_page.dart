import 'package:flutter/material.dart';
import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/utils/responsive_size.dart';

class HiddenWordsPage extends StatefulWidget {
  const HiddenWordsPage({super.key});

  @override
  State<HiddenWordsPage> createState() => _HiddenWordsPageState();
}

class _HiddenWordsPageState extends State<HiddenWordsPage> {
  bool _manualFilter = true;
  final TextEditingController _wordsController = TextEditingController();
  final List<String> _hiddenWords = ['scam', 'spam', 'ads'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(title: context.tr('hidden_words')),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          Text(
            context.tr('hidden_words_desc'),
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.8),
              fontSize: 14.sp,
              height: 1.4,
            ),
          ),
          SizedBox(height: 32.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  context.tr('manual_filter'),
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: _manualFilter,
                  onChanged: (val) => setState(() => _manualFilter = val),
                  activeThumbColor: colorScheme.primary,
                ),
              ),
            ],
          ),
          if (_manualFilter) ...[
            SizedBox(height: 24.h),
            Text(
              context.tr('custom_words_phrases'),
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: TextField(
                controller: _wordsController,
                style: TextStyle(color: colorScheme.onSurface, fontSize: 15.sp),
                decoration: InputDecoration(
                  hintText: context.tr('add_words_placeholder'),
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.3),
                  ),
                  contentPadding: EdgeInsets.all(12.w),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add_circle, color: colorScheme.primary),
                    onPressed: () {
                      if (_wordsController.text.isNotEmpty) {
                        setState(() {
                          final newWords = _wordsController.text
                              .split(',')
                              .map((e) => e.trim())
                              .where(
                                (e) =>
                                    e.isNotEmpty && !_hiddenWords.contains(e),
                              );
                          _hiddenWords.addAll(newWords);
                          _wordsController.clear();
                        });
                      }
                    },
                  ),
                ),
                onSubmitted: (val) {
                  if (val.isNotEmpty) {
                    setState(() {
                      final newWords = val
                          .split(',')
                          .map((e) => e.trim())
                          .where(
                            (e) => e.isNotEmpty && !_hiddenWords.contains(e),
                          );
                      _hiddenWords.addAll(newWords);
                      _wordsController.clear();
                    });
                  }
                },
              ),
            ),
            SizedBox(height: 16.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: _hiddenWords
                  .map(
                    (word) => Chip(
                      label: Text(
                        word,
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
                      backgroundColor: colorScheme.onSurface.withOpacity(0.05),
                      deleteIcon: Icon(
                        Icons.close,
                        size: 16.sp,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                      onDeleted: () =>
                          setState(() => _hiddenWords.remove(word)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      side: BorderSide.none,
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}











