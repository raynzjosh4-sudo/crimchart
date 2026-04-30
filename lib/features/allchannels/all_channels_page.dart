import 'package:crown/features/channel/application/channels_list_controller.dart';
import 'package:crown/features/channel/pages/channel_page.dart';
import 'package:crown/features/newinsidechartstartpage/models/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../newinsidechartstartpage/widgets/existingcharts/existing_chart_tile.dart';
import '../newinsidechartstartpage/widgets/pagination_indicators.dart';

class AllChannelsPage extends ConsumerStatefulWidget {
  const AllChannelsPage({super.key});

  @override
  ConsumerState<AllChannelsPage> createState() => _AllChannelsPageState();
}

class _AllChannelsPageState extends ConsumerState<AllChannelsPage> {
  @override
  void initState() {
    super.initState();
    // 👑 Warm up the controller if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(channelsListControllerProvider('all').notifier).loadChannels();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(channelsListControllerProvider('all'));

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // ── Professional SliverAppBar ──
          SliverAppBar(
            pinned: true,
            expandedHeight: 120.0,
            backgroundColor: colorScheme.surface,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsetsDirectional.only(
                start: 56,
                bottom: 16,
              ),
              title: Text(
                'Explore Channels',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              centerTitle: false,
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search_rounded, color: colorScheme.onSurface),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),

          // ── Header Section ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 24, 16, 8),
              child: Text(
                'ALL AVAILABLE CHANNELS',
                style: TextStyle(
                  color: colorScheme.primary.withOpacity(0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),

          // 👑 OFFLINE-FIRST LIST
          if (state.status == ChannelsListStatus.loading &&
              state.channels.isEmpty)
            const SliverFillRemaining()
          else if (state.status == ChannelsListStatus.error &&
              state.channels.isEmpty)
            SliverFillRemaining(
              child: Center(child: Text(state.error ?? 'Unknown error')),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final entity = state.channels[index];
                final channel = Chart.fromEntity(entity);

                return ExistingChartTile(
                  chart: channel,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChannelPage(
                          channel: channel,
                          contestants: const [],
                        ),
                      ),
                    );
                  },
                );
              }, childCount: state.channels.length),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
