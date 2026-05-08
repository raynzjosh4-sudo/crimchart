import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/router/app_router.dart';
import 'package:crimchart/core/utils/responsive_size.dart';

class ChannelSuggestionsPage extends StatefulWidget {
  const ChannelSuggestionsPage({super.key});

  @override
  State<ChannelSuggestionsPage> createState() => _ChannelSuggestionsPageState();
}

class _ChannelSuggestionsPageState extends State<ChannelSuggestionsPage> {
  final Set<int> _selectedChannels = {};

  // Dummy data for channels
  final List<Map<String, dynamic>> _channels = List.generate(
    15,
    (index) => {
      'id': index,
      'name': 'Channel ${index + 1}',
      'description': 'Description for channel ${index + 1}',
      'members': '${(index + 1) * 123}',
      'icon': 'https://i.pravatar.cc/150?u=channel$index',
    },
  );

  @override
  void initState() {
    super.initState();
    // Automatically select the first 10 as requested
    for (int i = 0; i < 10 && i < _channels.length; i++) {
      _selectedChannels.add(_channels[i]['id'] as int);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = Provider.of<LocalizationProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(
        title: '',
        showBorder: true,
        actions: [
          TextButton(
            onPressed: () => context.go(AppRoutes.feed),
            child: Text(
              localization.tr('skip'),
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.5),
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 8.h),
            child: Text(
              localization.tr('onboarding_channel_suggestions_title'),
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              localization.tr('onboarding_channel_suggestions_subtitle'),
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.6),
                fontSize: 14.sp,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              itemCount: _channels.length,
              itemBuilder: (context, index) {
                final channel = _channels[index];
                final isSelected = _selectedChannels.contains(channel['id']);

                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedChannels.remove(channel['id']);
                        } else {
                          _selectedChannels.add(channel['id'] as int);
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(16.w),
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primary.withOpacity(0.05)
                            : colorScheme.onSurface.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16.w),
                        border: Border.all(
                          color: isSelected
                              ? colorScheme.primary
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28.w,
                            backgroundImage: NetworkImage(
                              channel['icon'] as String,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  channel['name'] as String,
                                  style: TextStyle(
                                    color: colorScheme.onSurface,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  '${channel['members']} members',
                                  style: TextStyle(
                                    color: colorScheme.onSurface.withOpacity(
                                      0.5,
                                    ),
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Checkbox(
                            value: isSelected,
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  _selectedChannels.add(channel['id'] as int);
                                } else {
                                  _selectedChannels.remove(channel['id']);
                                }
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.w),
                            ),
                            activeColor: colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24.w),
            child: SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: () {
                  // Finalize joins and go to feed
                  context.go(AppRoutes.feed);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.w),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  localization.tr('onboarding_channel_suggestions_finish'),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}











