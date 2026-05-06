import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/repositories/channel_repository.dart';
import '../../../../profile/models/charter_model.dart';
import '../../../../core/di/injection.dart';

/// Provides a list of [CharterModel] members for a given channel.
final channelMembersProvider = StateNotifierProvider.autoDispose
    .family<ChannelMembersNotifier, AsyncValue<List<CharterModel>>, String>((
      ref,
      channelId,
    ) {
      final repo = getIt<ChannelRepository>();
      return ChannelMembersNotifier(repo, channelId);
    });

class ChannelMembersNotifier
    extends StateNotifier<AsyncValue<List<CharterModel>>> {
  final ChannelRepository _repository;
  final String channelId;

  ChannelMembersNotifier(this._repository, this.channelId)
    : super(const AsyncValue.loading()) {
    refresh();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final result = await _repository.getChannelMembers(channelId);

    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.toString(), StackTrace.current),
      (members) => state = AsyncValue.data(members),
    );
  }
}
