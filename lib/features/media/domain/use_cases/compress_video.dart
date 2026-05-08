import 'package:crimchart/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../repositories/media_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CompressVideo {
  final MediaRepository repository;

  CompressVideo(this.repository);

  /// Triggers the extremely fast video compression algorithms on a device
  Future<Either<Failure, String>> call(String fileUri) {
    return repository.compressVideo(localPath: fileUri);
  }
}











