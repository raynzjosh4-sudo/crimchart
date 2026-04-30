import 'package:crown/mainFeed/features/cardwidgets/chartsandstars/widgets/charter_star_avatar_stack.dart';
import 'package:crown/profile/models/charter_model.dart';
import 'package:flutter/material.dart';
import '../../../../../../features/channel/pages/channel_page.dart';
import '../../../../../../gifts/horizontalgiftscroll/horizontal_gift_scroll.dart';
import '../../../../../../gifts/widgets/gift_sheet.dart';
import '../../../../../../gifts/models/gift_recipient.dart';

class ChannelChartSlide extends StatefulWidget {
  final List<CharterModel> contestants;
  final Color themeColor;

  const ChannelChartSlide({
    super.key,
    required this.contestants,
    required this.themeColor,
  });

  @override
  State<ChannelChartSlide> createState() => _ChannelChartSlideState();
}

class _ChannelChartSlideState extends State<ChannelChartSlide>
    with SingleTickerProviderStateMixin {
  final GlobalKey _avatarKey = GlobalKey();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late CharterModel _focusedContestant;
  // Mutable ordered list — controls which position each contestant sits in.
  // When a swap happens, the old leader is pushed to the END (furthest behind).
  late List<CharterModel> _orderedContestants;

  @override
  void initState() {
    super.initState();
    _orderedContestants = List<CharterModel>.from(widget.contestants);
    _focusedContestant = _orderedContestants.isNotEmpty
        ? _orderedContestants.first
        : CharterModel(
            id: 'default',
            username: 'Unknown',
            displayName: 'Unknown',
            profileImageUrl: '',
            title: 'Participant',
            category: 'Category',
            chartCount: 0,
          );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handleSwap(CharterModel tappedContestant) {
    if (_focusedContestant.id == tappedContestant.id) return;
    setState(() {
      final CharterModel oldLeader = _focusedContestant;
      // Remove the tapped competitor from the ordered list
      _orderedContestants.remove(tappedContestant);
      // Remove the old leader too so we can re-insert them at the back
      _orderedContestants.remove(oldLeader);
      // New leader goes to the front of the ordered list
      _orderedContestants.insert(0, tappedContestant);
      // Old leader goes to the VERY END (furthest behind in the stack)
      _orderedContestants.add(oldLeader);
      _focusedContestant = tappedContestant;
    });
  }

  GiftRecipient get _recipient => GiftRecipient(
    id: _focusedContestant.id,
    name: _focusedContestant.username,
    avatarUrl: _focusedContestant.profileImageUrl,
    avatarKey: _avatarKey,
  );

  void _openGiftSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          GiftSheet(themeColor: widget.themeColor, recipient: _recipient),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.contestants.isEmpty) return const SizedBox.shrink();

    // Competitors in the ordered list (old leader always at the back)
    final remainingCompetitors = _orderedContestants
        .where((c) => c.id != _focusedContestant.id)
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated Background Glow
          Positioned(
            top: 40,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: widget.themeColor.withValues(alpha: 0.12),
                          blurRadius: 80,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top: Top/Star Avatar Stack
                TopStarAvatarStack(
                  person: _focusedContestant,
                  competitors: remainingCompetitors,
                  gold: widget.themeColor,
                  onSwap: _handleSwap,
                  width: 150,
                  height: 110,
                  mainSize: 80,
                  spacing: 18,
                  recipientKey: _avatarKey,
                  onLeaderTap: () {
                    final otherContestants = widget.contestants
                        .where((c) => c.id != _focusedContestant.id)
                        .toList();
                    final sortedNavList = [
                      _focusedContestant,
                      ...otherContestants,
                    ];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChannelPage(contestants: sortedNavList),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                Text(
                  _focusedContestant.username.toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                Text(
                  '${_focusedContestant.chartCount} KP',
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.8),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 18),

                // Reintegrated Gifts Section
                HorizontalGiftScroll(
                  themeColor: widget.themeColor,
                  recipient: _recipient,
                  onSeeAll: () => _openGiftSheet(context),
                  onGiftTap: (giftId) {
                    // Direct gifting logic handled by overlay
                  },
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}











