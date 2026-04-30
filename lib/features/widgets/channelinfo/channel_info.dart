import 'package:crown/profile/models/charter_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme_provider.dart';
import 'package:crown/gifts/horizontalgiftscroll/horizontal_gift_scroll.dart';
import 'package:crown/gifts/widgets/gift_sheet.dart';
import 'package:crown/gifts/models/gift_recipient.dart';
import 'package:crown/core/localization/localization_provider.dart';

// Corrected relative imports
import '../memberimage/starter_image.dart';
import '../chartstarter/starter_name.dart';
import '../chartmembers/member_count.dart';
import '../channelname/channel_name.dart';

class ChannelInfo extends StatelessWidget {
  final String? channelTitle;
  final String? staterName;
  final String? staterAvatarUrl;
  final bool isActive;
  final int? memberCount;
  final bool isPrivate;
  final int subchannelCount;
  final ValueNotifier<GlobalKey?>? recipientKeyNotifier;
  final ValueNotifier<CharterModel?>? activeContestantNotifier;

  const ChannelInfo({
    super.key,
    this.channelTitle,
    this.staterName,
    this.staterAvatarUrl,
    this.isActive = true,
    this.memberCount,
    this.isPrivate = true,
    this.subchannelCount = 0,
    this.recipientKeyNotifier,
    this.activeContestantNotifier,
  });

  @override
  Widget build(BuildContext context) {
    // Read the current dynamically synchronized color from ThemeProvider
    final currentColor = context.read<ThemeProvider>().currentColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (channelTitle != null)
          ChannelName(text: channelTitle!, color: currentColor)
        else
          ChannelName(color: currentColor),
        const SizedBox(height: 12),
        HorizontalGiftScroll(
          themeColor: currentColor,
          targetKeyNotifier: recipientKeyNotifier,
          onSeeAll: () {
            final activeModel = activeContestantNotifier?.value;
            final activeKey = recipientKeyNotifier?.value;

            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) => GiftSheet(
                themeColor: currentColor,
                recipient: (activeModel != null && activeKey != null)
                    ? GiftRecipient(
                        id: activeModel.id,
                        name: activeModel.username,
                        avatarUrl: activeModel.profileImageUrl,
                        avatarKey: activeKey,
                      )
                    : null,
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MemberImage(
              imageUrl: staterAvatarUrl,
              showStatusRing: true,
              showActiveDot: isActive,
            ),
            const SizedBox(width: 16),
            Flexible(
              child: StarterName(name: staterName ?? "Chart stater's name"),
            ),
          ],
        ),
        const SizedBox(height: 16),
        MemberCount(count: memberCount ?? 560),
        const SizedBox(height: 8),
        Text(
          isPrivate ? context.tr('private') : context.tr('public'),
          style: TextStyle(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.5),
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
























