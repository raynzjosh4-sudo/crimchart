import '../entities/channel_moment_entity.dart';

abstract class MomentRepository {
  /// Shares a piece of media as a channel moment.
  Future<ChannelMomentEntity?> shareMoment({
    required String channelId,
    required String mediaUrl,
    required String mediaType,
    String? caption,
  });

  /// Deletes expired moments from remote and local storage.
  Future<void> cleanupExpiredMoments(String channelId);

  /// Synchronizes moments from the server to the local database.
  Future<void> syncMoments({required String channelId, int offset = 0});

  /// Synchronizes moments for all provided channel IDs.
  Future<void> syncJoinedMoments(List<String> channelIds);
}
