import 'package:crimchart/channelcreatepage/channel_create_page.dart';
import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/features/widgets/memberimage/starter_image.dart';
import 'package:crimchart/profile/chart/dummydata/dummy_chart_data.dart';
import 'package:flutter/material.dart';
import '../widgets/chart_list_item.dart';
import '../widgets/poll_carousel.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // colorScheme removed as requested by lint

    final List<PollItem> pollItems = [
      const PollItem(
        id: 'poll1',
        title: 'Mulago is the best hospital in Uganda',
        mediaUrl: 'https://picsum.photos/seed/hospital/600/400',
        type: PollMediaType.image,
        points: 450,
        suggestedBy: 'Dr. Moses',
      ),
      const PollItem(
        id: 'poll2',
        title: 'Who was the most influential president?',
        mediaUrl: 'https://picsum.photos/seed/politics/600/400',
        type: PollMediaType.image,
        points: 820,
        suggestedBy: 'Sarah',
      ),
      const PollItem(
        id: 'poll3',
        title: 'New Health Policy Update',
        type: PollMediaType.text,
        points: 120,
        suggestedBy: 'Admin',
      ),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(
        title: 'INBOX',
        showBack: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChannelCreatePage()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildActiveStories(),
          const Divider(height: 1, thickness: 0.1, color: Colors.grey),
          PollCarousel(items: pollItems, title: 'User Suggestions'),
          Expanded(
            child: ListView.builder(
              itemCount: dummyCharts.length,
              itemBuilder: (context, index) {
                return ChartListItem(chart: dummyCharts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveStories() {
    return Container(
      height: 125.h,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 8, // Dummy stories
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildAddStory(context);
          }
          final name = index % 2 == 0 ? 'Vincent' : 'Sudo';
          final imageUrl = 'https://picsum.photos/seed/story$index/100/100';
          return Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Column(
              children: [
                MemberImage(
                  size: 62.w,
                  imageUrl: imageUrl,
                  showStatusRing: true,
                  showActiveDot: index.isEven,
                ),
                SizedBox(height: 6.h),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddStory(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: Column(
        children: [
          SizedBox(
            width: 62.w,
            height: 62.w,
            child: Stack(
              children: [
                MemberImage(
                  size: 62.w,
                  imageUrl: 'https://picsum.photos/seed/me/100/100',
                  showStatusRing: false,
                  showActiveDot: false,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: const Icon(Icons.add, size: 14, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Create',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white60,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
