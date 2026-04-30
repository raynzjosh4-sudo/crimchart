import 'package:crown/core/localization/localization_provider.dart';
import 'package:flutter/material.dart';
import '../memberimage/starter_image.dart';
import '../chartmembers/member_count.dart';
import 'stacked_contestants.dart';
import 'see_all_button.dart';

class ChannelHeaderDetails extends StatelessWidget {
  final String? latestArgueText;
  final String argumentTitle;
  final int memberCount;
  final List<String?> avatarUrls;
  final String? insideChannelsText;
  final String? seeAllText;
  final String? staterName;
  final String? staterAvatarUrl;
  final bool isActive;
  final int? subchannelCount;

  const ChannelHeaderDetails({
    super.key,
    this.latestArgueText,
    this.argumentTitle = 'The massive influence of AI on modern art',
    this.memberCount = 560,
    this.avatarUrls = const [],
    this.insideChannelsText,
    this.seeAllText,
    this.staterName,
    this.staterAvatarUrl,
    this.isActive = true,
    this.subchannelCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Inside channels" heading
          Text(
            insideChannelsText ?? context.tr('inside_channels'),
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.54),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              MemberImage(
                size: 20,
                borderWidth: 1.5,
                imageUrl: staterAvatarUrl,
                showStatusRing: isActive,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  staterName ?? 'chart stater\'s name',
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.54),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Title
          Text(
            argumentTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 12),
          // Overlapping Contestant Avatars
          StackedContestants(
            avatarUrls: avatarUrls,
            avatarSize: 32,
            overlapOffset: 20,
          ),
          const SizedBox(height: 12),
          // Member count
          MemberCount(
            count: memberCount,
            label: context.tr('members'),
            countColor: Theme.of(context).colorScheme.onSurface,
            labelColor: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.54),
            fontSize: 13,
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 12),
          // Right-aligned See All button
          Align(
            alignment: Alignment.centerRight,
            child: SeeAllButton(
              count: subchannelCount,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            ),
          ),
        ],
      ),
    );
  }
}











