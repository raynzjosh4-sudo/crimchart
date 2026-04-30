import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import '../../../features/allchannels/models/chart_channel.dart';

class ChannelTags extends StatefulWidget {
  final List<ChartChannel> channels;
  final List<String> selectedChannels;
  final Function(String) onChannelSelected;

  const ChannelTags({
    super.key,
    required this.channels,
    required this.selectedChannels,
    required this.onChannelSelected,
  });

  @override
  State<ChannelTags> createState() => _ChannelTagsState();
}

class _ChannelTagsState extends State<ChannelTags> {
  final ScrollController _scrollController = ScrollController();
  int _visibleCount = 10;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() async {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_isLoadingMore) {
      if (_visibleCount < widget.channels.length) {
        setState(() => _isLoadingMore = true);

        // Simulate network delay
        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          setState(() {
            _visibleCount = (_visibleCount + 10).clamp(
              0,
              widget.channels.length,
            );
            _isLoadingMore = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 100.h,
      margin: EdgeInsets.only(bottom: 8.h),
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: _visibleCount + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _visibleCount) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            );
          }

          final channel = widget.channels[index];
          final isSelected = widget.selectedChannels.contains(channel.title);

          return GestureDetector(
            onTap: () => widget.onChannelSelected(channel.title),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 100.w,
              margin: EdgeInsets.only(right: 12.w),
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.05),
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Overlapping Avatars
                      SizedBox(
                        width: 50.w,
                        height: 32.h,
                        child: Stack(
                          children: List.generate(
                            channel.memberAvatarUrls
                                .where((u) => u != null)
                                .take(3)
                                .length,
                            (idx) {
                              return Positioned(
                                left: idx * 12.0.w,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? colorScheme.primary
                                          : theme.scaffoldBackgroundColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 14.r,
                                    backgroundImage: NetworkImage(
                                      channel.memberAvatarUrls
                                          .where((u) => u != null)
                                          .elementAt(idx)!,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        channel.staterName ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.black
                              : colorScheme.onSurface,
                          fontSize: 12.sp,
                          fontWeight: isSelected
                              ? FontWeight.w900
                              : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  if (isSelected)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          size: 10.sp,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}











