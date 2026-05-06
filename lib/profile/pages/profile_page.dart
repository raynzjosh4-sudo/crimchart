import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/features/auth/application/auth_controller.dart';
import 'package:crown/features/widgets/memberimage/starter_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:crown/core/router/app_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../tabs/photos_profile_tab.dart';
import '../tabs/videos_profile_tab.dart';
import '../tabs/audio_profile_tab.dart';
import '../profileeditpages/edit_profile_image_page.dart';
import '../profileeditpages/edit_profile_page.dart';
import '../../settings/settings_page.dart';
import '../widgets/discover_charts.dart';
import '../dummydata/profile_dummy_data.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerStatefulWidget {
  final bool showBack;
  final String? userId; // ✅ ADDED: To support viewing specific users
  const ProfilePage({super.key, this.showBack = true, this.userId});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with TickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 3,
    vsync: this,
  );

  bool _isRequestSent = false;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("💎💎💎 ProfilePage build CALLED");
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final state = ref.watch(authControllerProvider);
    final user = state.user;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(
        title: user?.username ?? context.tr('profile'),
        showBack: widget.showBack,
        titleStyle: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w900,
          fontSize: 16.sp,
          letterSpacing: -0.2,
        ),
        actions: [
          IconButton(
            icon: Icon(
              LucideIcons.history,
              color: colorScheme.onSurface,
              size: 22.sp,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          // Profile Header
          SliverToBoxAdapter(child: _buildProfileHeader(context)),
          // Discover Empires (Charts) horizontal list
          SliverToBoxAdapter(
            child: discoverTops(
              suggestions: suggestedCharts,
              onSeeAll: () {
                // Handle see all logic if needed
              },
            ),
          ),

          // Sticky Tab Bar
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                indicatorColor: colorScheme.primary,
                labelColor: colorScheme.onSurface,
                unselectedLabelColor: colorScheme.onSurface.withValues(
                  alpha: 0.4,
                ),
                indicatorWeight: 2,
                dividerHeight: 0.5,
                dividerColor: colorScheme.onSurface.withValues(alpha: 0.08),
                tabs: [
                  Tab(
                    icon: Icon(
                      LucideIcons.layoutGrid,
                      size: 22.sp,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      LucideIcons.play,
                      size: 22.sp,
                      color: colorScheme.onSurface.withValues(
                        alpha: _tabController.index == 1 ? 1.0 : 0.4,
                      ),
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      LucideIcons.mic,
                      size: 22.sp,
                      color: colorScheme.onSurface.withValues(
                        alpha: _tabController.index == 2 ? 1.0 : 0.4,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [ProfilePhotosTab(), ProfileVideosTab(), ProfileAudioTab()],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = ref.watch(authControllerProvider).user;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.displayName ?? '',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w900,
                        fontSize: 22.sp,
                        letterSpacing: -0.8,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileImagePage(),
                  ),
                ),
                child: MemberImage(
                  imageUrl: user?.profileImageUrl,
                  size: 95.w,
                  useHexagon: false,
                  showStatusRing: false,
                  showActiveDot: false,
                  heroTag: 'avatar_${widget.userId ?? user?.id}',
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: _buildStatBadge(
                  context,
                  context.tr('Charts'),
                  (user?.followersCount ?? 0).toString(),
                  isHighlighted: true,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildStatBadge(
                  context,
                  context.tr('posts'),
                  (user?.followingCount ?? 0).toString(),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildStatBadge(
                  context,
                  context.tr('Chart'),
                  (user?.channelsCount ?? 0).toString(),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    if (widget.showBack && !_isRequestSent) {
                      setState(() {
                        _isRequestSent = true;
                      });
                    } else if (!widget.showBack) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfilePage(),
                        ),
                      );
                    }
                  },
                  child: _buildActionButton(
                    widget.showBack
                        ? (_isRequestSent
                              ? context.tr('inbox_sent')
                              : context.tr('request_inbox'))
                        : context.tr('edit_profile'),
                    isPrimary: true,
                    context: context,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    context.push(AppRoutes.inbox);
                  },
                  child: _buildActionButton(
                    context.tr('channel'),
                    isPrimary: false,
                    context: context,
                  ),
                ),
              ),
            ],
          ),
          if (user?.ChartTitle != null && user!.ChartTitle!.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Center(
              child: Text(
                user.ChartTitle!.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.3,
                ),
              ),
            ),
          ],
          if (user?.bio != null && user!.bio!.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Text(
              user.bio!,
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.8),
                fontSize: 13.sp,
                height: 1.4,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatBadge(
    BuildContext context,
    String label,
    String value, {
    bool isHighlighted = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(
        color: isHighlighted
            ? colorScheme.primary.withValues(alpha: 0.05)
            : colorScheme.onSurface.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(10.w),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: isHighlighted
                  ? colorScheme.primary
                  : colorScheme.onSurface,
              fontSize: 15.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: isHighlighted
                  ? colorScheme.primary.withValues(alpha: 0.7)
                  : colorScheme.onSurface.withValues(alpha: 0.4),
              fontSize: 7.5.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label, {
    bool isPrimary = false,
    required BuildContext context,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 34.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isPrimary
            ? colorScheme.primary
            : colorScheme.onSurface.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10.w),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isPrimary ? Colors.white : colorScheme.onSurface,
            fontWeight: FontWeight.w800,
            fontSize: 12.sp,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _SliverTabBarDelegate(this._tabBar, {required this.backgroundColor});

  final TabBar _tabBar;
  final Color backgroundColor;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: backgroundColor, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => true;
}
