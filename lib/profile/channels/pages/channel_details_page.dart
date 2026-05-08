import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/features/allchannels/models/chart_channel.dart';
import 'package:crimchart/features/widgets/memberimage/channel_avatar.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ChannelDetailsPage extends StatefulWidget {
  final ChartChannel channel;
  final bool isChartedIn;
  final bool isSubChannel;

  const ChannelDetailsPage({
    super.key,
    required this.channel,
    required this.isChartedIn,
    this.isSubChannel = false,
  });

  @override
  State<ChannelDetailsPage> createState() => _ChannelDetailsPageState();
}

class _ChannelDetailsPageState extends State<ChannelDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final backgroundColor = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: ChartAppBar(
        title: 'Group Info',
        showBack: true,
        backgroundColor: backgroundColor,
        titleStyle: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w900,
          fontSize: 16.sp,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // ── CHANNEL HEADER ──
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 10.h),
                ChannelAvatar(
                  imageUrl: widget.channel.staterAvatarUrl,
                  leaderAvatarUrl: widget.channel.leaderAvatarUrl,
                  size: 110.w,
                ),
                SizedBox(height: 16.h),
                Text(
                  widget.channel.title,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Community • 1,240 Members',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // ── ACTION GRID (WhatsApp Style) ──
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCircleAction(
                    colorScheme: colorScheme,
                    icon: LucideIcons.bell,
                    label: 'Mute',
                  ),
                  _buildCircleAction(
                    colorScheme: colorScheme,
                    icon: LucideIcons.userPlus,
                    label: 'Add',
                  ),
                  _buildCircleAction(
                    colorScheme: colorScheme,
                    icon: LucideIcons.search,
                    label: 'Search',
                  ),
                  _buildCircleAction(
                    colorScheme: colorScheme,
                    icon: LucideIcons.moreHorizontal,
                    label: 'More',
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: Divider(height: 1, thickness: 0.5, color: Colors.white10),
          ),

          // ── CHANNEL EARNINGS & STATS ──
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'YOUR EARNINGS IN THIS CHANNEL',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w900,
                      color: colorScheme.primary.withValues(alpha: 0.8),
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      _buildStatCard(
                        colorScheme: colorScheme,
                        title: '550',
                        subtitle: 'Gifts Received',
                        icon: LucideIcons.gift,
                        color: Colors.pinkAccent,
                      ),
                      SizedBox(width: 12.w),
                      _buildStatCard(
                        colorScheme: colorScheme,
                        title: '22,400',
                        subtitle: 'Coins Earned',
                        icon: LucideIcons.coins,
                        color: Colors.amber,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: Divider(height: 1, thickness: 0.5, color: Colors.white10),
          ),

          // ── CHANNEL INFO / DESCRIPTION ──
          SliverToBoxAdapter(
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 8.h,
              ),
              title: Text(
                'Description',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800),
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Text(
                  'Join our Modern AI Discussion group. We share the latest in GPT, Anthropic, and Google DeepMind news.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: Divider(height: 1, thickness: 0.5, color: Colors.white10),
          ),

          // ── GROUP SETTINGS & SAFETY ──
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildListAction(
                  colorScheme: colorScheme,
                  icon: LucideIcons.image,
                  title: 'Media, Links, and Docs',
                  count: '142',
                ),
                _buildListAction(
                  colorScheme: colorScheme,
                  icon: LucideIcons.star,
                  title: 'Starred Messages',
                ),
                _buildListAction(
                  colorScheme: colorScheme,
                  icon: LucideIcons.lock,
                  title: 'Encryption',
                ),

                const Divider(height: 1, thickness: 0.5, color: Colors.white10),

                _buildListAction(
                  colorScheme: colorScheme,
                  icon: LucideIcons.eraser,
                  title: 'Clear Chat',
                  color: Colors.orange,
                ),
                _buildListAction(
                  colorScheme: colorScheme,
                  icon: LucideIcons.megaphone,
                  title: 'Report Channel',
                  color: Colors.redAccent,
                ),
                _buildListAction(
                  colorScheme: colorScheme,
                  icon: LucideIcons.ban,
                  title: 'Block Channel',
                  color: Colors.red,
                ),
              ],
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 60.h)),
        ],
      ),
    );
  }

  Widget _buildCircleAction({
    required ColorScheme colorScheme,
    required IconData icon,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: colorScheme.primary, size: 22.sp),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required ColorScheme colorScheme,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20.sp),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListAction({
    required ColorScheme colorScheme,
    required IconData icon,
    required String title,
    String? count,
    Color? color,
  }) {
    return ListTile(
      onTap: () {},
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
      leading: Icon(
        icon,
        color: color ?? colorScheme.onSurface.withValues(alpha: 0.8),
        size: 22.sp,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          color: color ?? colorScheme.onSurface,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (count != null)
            Text(
              count,
              style: TextStyle(
                fontSize: 13.sp,
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          SizedBox(width: 8.w),
          Icon(
            LucideIcons.chevronRight,
            size: 16.sp,
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ],
      ),
    );
  }
}











