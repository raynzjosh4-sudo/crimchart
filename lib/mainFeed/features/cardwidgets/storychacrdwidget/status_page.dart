import 'package:crown/chartdialog/chart_options_dialog.dart';
import 'package:flutter/material.dart';
import '../../../../features/widgets/memberimage/starter_image.dart';
import '../../../../profile/pages/profile_page.dart';

class StatusPage extends StatefulWidget {
  final String username;
  final String userProfileImageUrl;
  final String statusImageUrl;
  final bool isChartable;
  final bool isPublic;

  const StatusPage({
    super.key,
    required this.username,
    required this.userProfileImageUrl,
    required this.statusImageUrl,
    this.isChartable = true,
    this.isPublic = true,
  });

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..forward().then((_) {
            if (mounted) Navigator.pop(context);
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showChartOptions(BuildContext context) {
    _controller.stop();
    ChartOptionsDialog.show(
      context,
      username: widget.username,
      userProfileImageUrl: widget.userProfileImageUrl,
      statusImageUrl: widget.statusImageUrl,
      isChartable: widget.isChartable,
      themeColor: Theme.of(context).primaryColor,
      onChartTap: () {
        _showChannelSelector(context);
      },
    ).then((_) {
      if (mounted) _controller.forward();
    });
  }

  void _showChannelSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(
                  Icons.emoji_events,
                  color: Theme.of(context).primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  'SELECT CHANNEL',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const CircleAvatar(child: Text('G')),
              title: const Text('Global Arena'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const CircleAvatar(child: Text('D')),
              title: const Text('Discovery Channel'),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onLongPress: () => _showChartOptions(context),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.network(widget.statusImageUrl, fit: BoxFit.cover),
            ),

            // Top Gradient
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 150,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // UI Layer
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return LinearProgressIndicator(
                          value: _controller.value,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          minHeight: 2,
                        );
                      },
                    ),
                    const SizedBox(height: 12),
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
                          size: 40,
                          imageUrl: widget.userProfileImageUrl,
                          showStatusRing: false,
                          showActiveDot: false,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const Text(
                                'Just now',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}











