import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crown/chartappbar/chart_app_bar.dart';
import 'package:crown/core/di/injection.dart';
import '../../application/channels_list_controller.dart';
import '../../domain/entities/channel_entity.dart';
import '../../domain/repositories/channel_repository.dart';

class SelectCharterPage extends ConsumerStatefulWidget {
  final String rewardTitle;
  final String? channelId;
  final String? channelName;
  final String? channelImageUrl;

  const SelectCharterPage({
    super.key,
    this.rewardTitle = 'Invitation',
    this.channelId,
    this.channelName,
    this.channelImageUrl,
  });

  @override
  ConsumerState<SelectCharterPage> createState() => _SelectCharterPageState();
}

class _SelectCharterPageState extends ConsumerState<SelectCharterPage> {
  final Set<String> _invitedChannelIds = {};
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingInvited = true;

  @override
  void initState() {
    super.initState();
    _loadInitialState();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadInitialState() async {
    try {
      final repo = getIt<ChannelRepository>();
      final invitedIds = await repo.getInvitedChannelIds(
        widget.channelId ?? '',
      );

      if (mounted) {
        setState(() {
          _invitedChannelIds.addAll(invitedIds);
        });
      }
    } catch (e) {
      debugPrint(
        '⚠️ [Database Error]: $e. Migrations might need a Hot Restart.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingInvited = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(channelsListControllerProvider('all').notifier).loadChannels();
    }
  }

  Future<void> _sendInvitation(ChannelEntity targetChannel) async {
    if (_invitedChannelIds.contains(targetChannel.id)) return;

    debugPrint(
      '➡️ [InviteAction] Tapped INVITE button for channel: ${targetChannel.name} (${targetChannel.id})',
    );

    // Optimistically update UI
    setState(() {
      _invitedChannelIds.add(targetChannel.id);
    });

    final repo = getIt<ChannelRepository>();
    debugPrint('📤 [InviteAction] Calling repo.sendInvitation with:');
    debugPrint('   - sourceChannelId: ${targetChannel.id}');
    debugPrint('   - targetChannelId: ${widget.channelId}');
    debugPrint('   - channelName: ${widget.channelName}');

    final result = await repo.sendInvitation(
      sourceChannelId:
          targetChannel.id, // The channel where the invite is posted
      targetChannelId: widget.channelId ?? '', // The channel being invited to
      channelName: widget.channelName,
      channelImageUrl: widget.channelImageUrl,
      channelTitle: targetChannel.description,
    );

    result.fold(
      (failure) {
        // Revert on failure
        setState(() {
          _invitedChannelIds.remove(targetChannel.id);
        });
        debugPrint(
          '❌ [InviteAction] Failed to send to ${targetChannel.name}: ${failure.message}',
        );
      },
      (_) {
        debugPrint(
          '✅ [InviteAction] Successfully sent to ${targetChannel.name}',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // ☁️ WATCH PAGINATED STATE
    final channelsState = ref.watch(channelsListControllerProvider('all'));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(title: 'SELECT CHANNEL', showBorder: true),
      body: _isLoadingInvited
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child:
                      channelsState.status == ChannelsListStatus.loading &&
                          channelsState.channels.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : channelsState.status == ChannelsListStatus.error &&
                            channelsState.channels.isEmpty
                      ? Center(child: Text("Error: ${channelsState.error}"))
                      : RefreshIndicator(
                          onRefresh: () => ref
                              .read(
                                channelsListControllerProvider('all').notifier,
                              )
                              .loadChannels(refresh: true),
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            itemCount:
                                channelsState.channels.length +
                                (channelsState.hasReachedMax ? 0 : 1),
                            itemBuilder: (context, index) {
                              if (index == channelsState.channels.length) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20.h),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              final channel = channelsState.channels[index];

                              // Skip the current channel itself!
                              if (channel.id == widget.channelId)
                                return const SizedBox.shrink();

                              final isSent = _invitedChannelIds.contains(
                                channel.id,
                              );

                              return Padding(
                                padding: EdgeInsets.only(
                                  top: 12.h,
                                  bottom: 4.h,
                                ),
                                child: _buildChannelTile(
                                  channel: channel,
                                  isSent: isSent,
                                  onInvite: () => _sendInvitation(channel),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildChannelTile({
    required ChannelEntity channel,
    required bool isSent,
    required VoidCallback onInvite,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryGold = const Color(0xFFFFD700);

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          // Channel Avatar
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: channel.avatarUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(channel.avatarUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
              color: colorScheme.onSurface.withValues(alpha: 0.1),
            ),
            child: channel.avatarUrl.isEmpty
                ? Icon(
                    Icons.hub,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  )
                : null,
          ),
          SizedBox(width: 16.w),

          // Channel Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  channel.name,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  '${channel.memberCount} members',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),

          // 👑 INVITE/SENT BUTTON
          GestureDetector(
            onTap: isSent ? null : onInvite,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSent
                    ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
                    : primaryGold,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: isSent
                    ? []
                    : [
                        BoxShadow(
                          color: primaryGold.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isSent ? 'SENT' : 'INVITE',
                    style: TextStyle(
                      color: isSent
                          ? colorScheme.onSurface.withValues(alpha: 0.3)
                          : Colors.black,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w900,
                    ),
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
