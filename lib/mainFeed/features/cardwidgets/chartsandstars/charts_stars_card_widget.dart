import 'package:crown/mainFeed/features/cardwidgets/chartsandstars/widgets/Chart_queen_action_button.dart';
import 'package:crown/mainFeed/features/cardwidgets/chartsandstars/widgets/charter_star_avatar_stack.dart';
import 'package:crown/profile/models/charter_model.dart';
import 'package:flutter/material.dart';

class TopsStarsCardWidget extends StatelessWidget {
  final List<CharterModel> items;

  const TopsStarsCardWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gold = theme.primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.workspace_premium_rounded, color: gold, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'Tops & Stars',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
              Text(
                'See all',
                style: TextStyle(
                  fontSize: 13,
                  color: gold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // Horizontal list
        SizedBox(
          height: 300, // Increased for larger avatars and badges
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final person = items[index];
              return _TopStarTile(person: person, gold: gold);
            },
          ),
        ),
      ],
    );
  }
}

class _TopStarTile extends StatefulWidget {
  final CharterModel person;
  final Color gold;

  const _TopStarTile({required this.person, required this.gold});

  @override
  State<_TopStarTile> createState() => _TopStarTileState();
}

class _TopStarTileState extends State<_TopStarTile> {
  late CharterModel _currentPerson;
  late List<CharterModel> _competitors;

  @override
  void initState() {
    super.initState();
    _currentPerson = widget.person;
    _competitors = List.from(widget.person.competitors);
  }

  void _onSwap(CharterModel picked) {
    setState(() {
      final oldLeader = _currentPerson;

      // Remove the picked one from competitors
      _competitors.removeWhere((c) => c.id == picked.id);

      // Add the old leader to the end of the competitors
      _competitors.add(oldLeader);

      // Update the current focused leader
      _currentPerson = picked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 180, // Increased width
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E), // Premium dark grey
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: widget.gold.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 2),
            // Category Title (Top of Rap) - At top
            Text(
              '${_currentPerson.title} of ${_currentPerson.category}',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                color: widget.gold,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Stacked avatars (Extracted Widget)
            TopStarAvatarStack(
              person: _currentPerson,
              competitors: _competitors,
              gold: widget.gold,
              onSwap: _onSwap,
              width: 180,
              height: 150,
              mainSize: 100, // Slightly larger
              spacing: 24,
              isMainOnRight: true,
            ),

            const SizedBox(height: 10),

            // Member Name
            Text(
              _currentPerson.displayName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // Chart Number (Me/Ke)
            Text(
              '${_formatChart(_currentPerson.chartCount)}e',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            // Action Bar (Extracted Widget)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: TopStarActionButton(
                label: 'Flag',
                icon: Icons.flag_rounded,
                color: widget.gold,
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatChart(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return '$count';
  }
}











