import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/repositories/moment_repository.dart';
import '../../../../core/di/injection.dart';

final momentControllerProvider = Provider((ref) => MomentController());

class MomentController {
  final _repository = getIt<MomentRepository>();

  Future<void> shareMoment({
    required String channelId,
    required String mediaUrl,
    required String mediaType,
    String? caption,
  }) async {
    await _repository.shareMoment(
      channelId: channelId,
      mediaUrl: mediaUrl,
      mediaType: mediaType,
      caption: caption,
    );
  }

  Future<void> cleanupExpiredMoments(String channelId) async {
    await _repository.cleanupExpiredMoments(channelId);
  }

  Future<void> syncMoments(String channelId, {int offset = 0}) async {
    await _repository.syncMoments(channelId: channelId, offset: offset);
  }
}
