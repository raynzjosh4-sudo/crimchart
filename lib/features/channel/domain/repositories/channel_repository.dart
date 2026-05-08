import 'package:crimchart/profile/models/charter_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/channel_entity.dart';

abstract class ChannelRepository {
  Future<Either<Failure, ChannelEntity>> createChannel(
    Map<String, dynamic> channelData, {
    String? avatarUrl,
  });
  Future<Either<Failure, ChannelEntity>> updateChannel(
    String channelId,
    Map<String, dynamic> channelData, {
    String? avatarUrl,
  });
  Future<Either<Failure, List<ChannelEntity>>> getChannels(
    String filter, {
    int page = 0,
  });
  Stream<List<ChannelEntity>> watchChannels(String filter);

  // 👑 NEW PURE ARCHITECTURE: Offline-First Channels Loader
  Future<List<ChannelEntity>> getOfflineFirstChannels(String filter);

  Future<Either<Failure, List<CharterModel>>> getChannelMembers(
    String channelId,
  );

  // 👑 CROSS-CHANNEL INVITATIONS
  Future<Either<Failure, void>> sendInvitation({
    required String sourceChannelId,
    required String targetChannelId,
    String? channelName,
    String? channelImageUrl,
    String? channelTitle,
  });

  Future<Set<String>> getInvitedChannelIds(String targetChannelId);
}
