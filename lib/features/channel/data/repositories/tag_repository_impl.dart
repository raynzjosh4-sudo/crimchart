import 'package:crimchart/core/db/chart_native_db.dart';
import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/tag_entity.dart';
import '../../domain/repositories/tag_repository.dart';
import '../sources/tag_remote_source.dart';

@LazySingleton(as: TagRepository)
class TagRepositoryImpl implements TagRepository {
  final TagRemoteSource _remoteSource;
  final ChartNativeDB _localDb;

  TagRepositoryImpl(this._remoteSource, this._localDb);

  @override
  Future<Either<Failure, TagEntity>> createTag({
    required String postId,
    required String sourceChannelId,
    required String targetChannelId,
    required List<String> linkChain,
  }) async {
    try {
      // 1. Sync to Supabase
      final tag = await _remoteSource.createTag(
        postId: postId,
        sourceChannelId: sourceChannelId,
        targetChannelId: targetChannelId,
        linkChain: linkChain,
      );

      // 2. Persist to Native C++ Local DB
      await _localDb.upsertChannelContentTag(tag.toJson());

      return Right(tag);
    } catch (e) {
      debugPrint('🚨 [TagRepositoryImpl] Error: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeTag(String tagId) async {
    try {
      await _remoteSource.removeTag(tagId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<bool> isPostTagged({
    required String postId,
    required String targetChannelId,
  }) async {
    try {
      return await _remoteSource.isPostTagged(
        postId: postId,
        targetChannelId: targetChannelId,
      );
    } catch (e) {
      return false;
    }
  }
}
