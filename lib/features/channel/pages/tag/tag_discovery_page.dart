import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/features/channel/application/channels_list_controller.dart';
import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/features/channel/application/tag_controller.dart';
import 'widgets/tag_list_tile.dart';
// Reuse shimmer if possible or create new one

/// A vertical discovery page for Tagging.
/// Shows all available channels in a high-fidelity list format.
class TagDiscoveryPage extends ConsumerStatefulWidget {
  final String postId;
  final String sourceChannelId;
  final List<String> linkChain;

  const TagDiscoveryPage({
    super.key,
    required this.postId,
    required this.sourceChannelId,
    required this.linkChain,
  });

  @override
  ConsumerState<TagDiscoveryPage> createState() => _TagDiscoveryPageState();
}

class _TagDiscoveryPageState extends ConsumerState<TagDiscoveryPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200.h) {
      ref.read(channelsListControllerProvider('').notifier).loadChannels();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final channelsState = ref.watch(channelsListControllerProvider(''));

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: ChartAppBar(
        title: 'Tag Options',
        showBack: true,
        backgroundColor: colorScheme.surface,
      ),
      body: _buildBody(channelsState),
    );
  }

  Widget _buildBody(ChannelsListState state) {
    if (state.status == ChannelsListStatus.loading && state.channels.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white24),
      );
    }

    if (state.status == ChannelsListStatus.error && state.channels.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.white24,
              size: 48,
            ),
            SizedBox(height: 16.h),
            Text(
              'Failed to load channels',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
            ),
            TextButton(
              onPressed: () => ref
                  .read(channelsListControllerProvider('').notifier)
                  .loadChannels(refresh: true),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      controller: _scrollController,
      padding: EdgeInsets.only(top: 12.h, bottom: 40.h),
      itemCount:
          state.channels.length +
          (state.status == ChannelsListStatus.loading ? 1 : 0),
      separatorBuilder: (_, __) => Divider(
        color: Colors.white.withValues(alpha: 0.05),
        height: 1,
        indent: 92.w,
      ),
      itemBuilder: (context, index) {
        if (index < state.channels.length) {
          final channel = state.channels[index];
          return TagListTile(
            title: channel.name,
            subtitle: channel.description,
            imageUrl: channel.avatarUrl,
            buttonText: 'Tag',
            onTap: () {
              ref.read(tagControllerProvider.notifier).tagPost(
                    postId: widget.postId,
                    sourceChannelId: widget.sourceChannelId,
                    targetChannelId: channel.id,
                    linkChain: [...widget.linkChain, channel.id],
                  );
              Navigator.pop(context);
            },
          );
        } else {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white24,
              ),
            ),
          );
        }
      },
    );
  }
}
