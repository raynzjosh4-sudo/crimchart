import 'package:crown/core/localization/localization_provider.dart';
import 'package:flutter/material.dart';
import '../../features/widgets/memberimage/starter_image.dart';
import '../../features/channel/pages/channel_page.dart';
import '../../features/allchannels/models/chart_channel.dart';
import '../../profile/pages/profile_page.dart';
import '../../profile/channels/pages/channels_page.dart';
import 'widgets/channel_selector_row.dart';

class ChartOptionsDialog extends StatefulWidget {
  final String username;
  final String userProfileImageUrl;
  final String statusImageUrl;
  final bool isChartable;
  final Color themeColor;
  final VoidCallback onChartTap;

  const ChartOptionsDialog({
    super.key,
    required this.username,
    required this.userProfileImageUrl,
    required this.statusImageUrl,
    required this.isChartable,
    required this.themeColor,
    required this.onChartTap,
  });

  static Future<void> show(
    BuildContext context, {
    required String username,
    required String userProfileImageUrl,
    required String statusImageUrl,
    required bool isChartable,
    required Color themeColor,
    required VoidCallback onChartTap,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ChartOptionsDialog(
        username: username,
        userProfileImageUrl: userProfileImageUrl,
        statusImageUrl: statusImageUrl,
        isChartable: isChartable,
        themeColor: themeColor,
        onChartTap: onChartTap,
      ),
    );
  }

  @override
  State<ChartOptionsDialog> createState() => _ChartOptionsDialogState();
}

class _ChartOptionsDialogState extends State<ChartOptionsDialog> {
  bool _showChannels = false;
  int _selectedChannelIndex = -1;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: screenHeight * 0.85),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Handle Bar
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: User Attribution
                      Row(
                        children: [
                          MemberImage(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfilePage(),
                                ),
                              );
                            },
                            size: 32,
                            imageUrl: widget.userProfileImageUrl,
                            showStatusRing: true,
                            showActiveDot: false,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.username,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                context.tr('his_User'),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Second Level: Content Identity
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 42),
                          // Status Thumbnail
                          Container(
                            width: 80,
                            height: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white12,
                                width: 1.5,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(widget.statusImageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Expansion Toggle
                          Column(
                            children: [
                              const SizedBox(height: 34),
                              GestureDetector(
                                onTap: () => setState(
                                  () => _showChannels = !_showChannels,
                                ),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: _showChannels
                                        ? Theme.of(
                                            context,
                                          ).primaryColor.withValues(alpha: 0.1)
                                        : colorScheme.surfaceContainerHighest
                                              .withValues(alpha: 0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _showChannels
                                        ? Icons.cached_rounded
                                        : Icons.sync_rounded,
                                    color: _showChannels
                                        ? Theme.of(context).primaryColor
                                        : colorScheme.onSurface.withValues(
                                            alpha: 0.6,
                                          ),
                                    size: 26,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                if (_showChannels) ...[
                  const SizedBox(height: 10),
                  ChannelSelectorRow(
                    title: context.tr('select_channel_to_Chart'),
                    selectedIndex: _selectedChannelIndex,
                    onChannelSelect: (index) {
                      setState(() => _selectedChannelIndex = index);
                    },
                    onChartConfirm: (index) {
                      // Navigate to ChannelPage ONLY on Chart Confirmation
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChannelPage(
                            channel: ChartChannel(
                              id: 'channel_$index',
                              title: 'Channel ${index + 1}',
                              imageUrl:
                                  'https://picsum.photos/seed/${index + 100}/800/1200',
                            ),
                          ),
                        ),
                      );
                    },
                    onBrowseAll: () {
                      // Open the full Channels Page
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChannelsPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                ],

                // Safety Options
                Column(
                  children: [
                    _buildAction(
                      context,
                      context.tr(
                        'block_user',
                        args: {'username': widget.username},
                      ),
                      isDestructive: true,
                    ),
                    _buildAction(
                      context,
                      context.tr(
                        'report_user',
                        args: {'username': widget.username},
                      ),
                      isDestructive: true,
                    ),
                    _buildAction(context, context.tr('view_profile')),
                    _buildAction(context, context.tr('share_status')),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAction(
    BuildContext context,
    String title, {
    bool isDestructive = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: InkWell(
        onTap: () => Navigator.pop(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                isDestructive
                    ? Icons.report_problem_rounded
                    : Icons.person_rounded,
                size: 18,
                color: isDestructive
                    ? Colors.redAccent
                    : colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDestructive
                      ? Colors.redAccent
                      : colorScheme.onSurface.withValues(alpha: 0.9),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right_rounded,
                size: 16,
                color: colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}











