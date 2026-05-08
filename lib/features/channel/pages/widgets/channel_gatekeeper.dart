import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crimchart/features/channel/application/is_member_provider.dart';

/// 👑 A Reusable Wrapper Widget for enforcing Channel Membership rules.
/// Uses an instant Drift read to determine initial state, then switches to
/// the reactive stream — eliminating any "Join" button flash on load.
class ChannelGatekeeper extends ConsumerWidget {
  final String channelId;
  final Widget memberUI;
  final Widget guestUI;
  final Widget? loadingUI;
  final bool initialIsMember;

  const ChannelGatekeeper({
    super.key,
    required this.channelId,
    required this.memberUI,
    required this.guestUI,
    this.initialIsMember = false,
    this.loadingUI,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Reactive stream for live updates (e.g. after joining)
    final liveStream = ref.watch(isMemberProvider(channelId));

    // 2. Determine membership: prioritize the live stream, but fall back to initialIsMember immediately
    // 👑 CRITICAL: If initialIsMember is true, don't let a stale local DB stream override it to false!
    final isMember = liveStream.maybeWhen(
      data: (val) => val || initialIsMember,
      orElse: () => initialIsMember,
    );

    return isMember ? memberUI : guestUI;
  }
}
