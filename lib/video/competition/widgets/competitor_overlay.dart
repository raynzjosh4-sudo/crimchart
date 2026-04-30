import 'package:flutter/material.dart';
import '../../../../profile/models/charter_model.dart';

class CompetitorOverlay extends StatelessWidget {
  final List<CharterModel> competitors;

  const CompetitorOverlay({super.key, required this.competitors});

  @override
  Widget build(BuildContext context) {
    if (competitors.isEmpty) return const SizedBox.shrink();

    return Column(
      children: competitors.map((competitor) => _CompetitorIcon(competitor: competitor)).toList(),
    );
  }
}

class _CompetitorIcon extends StatelessWidget {
  final CharterModel competitor;

  const _CompetitorIcon({required this.competitor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(competitor.profileImageUrl),
          ),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.local_fire_department, color: Colors.white, size: 12),
          ),
        ],
      ),
    );
  }
}





























