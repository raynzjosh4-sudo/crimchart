import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/channel_entity.dart';

abstract class ChannelRepository {
  Future<Either<Failure, ChannelEntity>> createChannel(Map<String, dynamic> channelData, {String? avatarUrl});
  Future<Either<Failure, ChannelEntity>> updateChannel(String channelId, Map<String, dynamic> channelData, {String? avatarUrl});
  Future<Either<Failure, List<ChannelEntity>>> getChannels(String filter);
  Stream<List<ChannelEntity>> watchChannels(String filter);
  
  // 👑 NEW PURE ARCHITECTURE: Offline-First Channels Loader
  Future<List<ChannelEntity>> getOfflineFirstChannels(String filter);
}
























