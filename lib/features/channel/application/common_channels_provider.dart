import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/db/chart_native_db.dart';
import '../../../core/di/injection.dart';
import '../../auth/application/auth_controller.dart';
import 'package:crown/features/allchannels/models/chart_channel.dart';

part 'common_channels_provider.g.dart';

@riverpod
Stream<List<ChartChannel>> commonChannels(
  CommonChannelsRef ref,
  String otherUserId,
) async* {
  final currentUser = ref.watch(authControllerProvider).user;
  if (currentUser == null) {
    yield [];
    return;
  }

  final nativeDb = getIt<ChartNativeDB>();
  yield* nativeDb.watchCommonChannels(currentUser.id, otherUserId).map((rows) {
    return rows.map((row) {
      return ChartChannel(
        id: row['id'] as String,
        title:
            (row['title'] as String?) ?? (row['name'] as String?) ?? 'Channel',
        imageUrl: row['imageUrl'] as String?,
        description: row['subtitle'] as String?,
      );
    }).toList();
  });
}
