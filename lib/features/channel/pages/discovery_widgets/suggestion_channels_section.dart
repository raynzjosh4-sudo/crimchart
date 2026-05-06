import 'package:flutter/material.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/features/newinsidechartstartpage/models/chart.dart';
import 'person_card.dart';

class SuggestionChannelsSection extends StatefulWidget {
  final List<Chart> channels;
  final VoidCallback? onSeeAll;
  final String title;

  const SuggestionChannelsSection({
    super.key,
    required this.channels,
    this.onSeeAll,
    this.title = 'Suggestion Channels',
  });

  @override
  State<SuggestionChannelsSection> createState() =>
      _SuggestionChannelsSectionState();
}

class _SuggestionChannelsSectionState extends State<SuggestionChannelsSection> {
  // 👑 Track local button states for immediate UI feedback
  final Map<String, String> _buttonStates = {};

  String _getButtonText(Chart channel) {
    return _buttonStates[channel.id] ?? 'Follow';
  }

  void _handleTap(Chart channel) {
    final currentState = _getButtonText(channel);

    if (currentState == 'Follow') {
      // 👑 STAGE 1: Transition to Join/Request
      setState(() {
        if (channel.joinMethod == 'anybody' || channel.joinMethod == 'public') {
          _buttonStates[channel.id] = 'Join';
        } else {
          _buttonStates[channel.id] = 'Request Join';
        }
      });
    } else {
      // 👑 STAGE 2: Execute actual join/request logic
      if (currentState == 'Join') {
        debugPrint('加入频道: ${channel.id}');
        // 👑 Optimistic update: Increment followers locally for the list
        setState(() {
          _buttonStates[channel.id] = 'Joined';
          // Since Chart is immutable, we just change the button text
          // but we could also track count if we had a more complex state map
        });
      } else if (currentState == 'Request Join') {
        debugPrint('发送加入请求: ${channel.id}');
        setState(() {
          _buttonStates[channel.id] = 'Sent';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.channels.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor == Colors.transparent
            ? Colors.transparent
            : theme.scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.onSurface.withValues(alpha: 0.1),
            width: 8.h,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              widget.title,
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 240.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount: widget.channels.length,
              separatorBuilder: (context, index) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                final channel = widget.channels[index];
                return PersonCard(
                  imageUrl: channel.imageUrl ?? '',
                  name: channel.title,
                  mutualFriendsText: '${channel.followersCount} followers',
                  buttonText: _getButtonText(channel),
                  onButtonPressed: () => _handleTap(channel),
                );
              },
            ),
          ),
          SizedBox(height: 20.h),
          Center(
            child: GestureDetector(
              onTap: widget.onSeeAll,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'See all',
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.chevron_right,
                    size: 18.sp,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
