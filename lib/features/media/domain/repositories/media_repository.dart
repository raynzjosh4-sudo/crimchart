import 'package:crown/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class MediaRepository {
  /// Compresses a video file via the native C++ FFI bindings asynchronously.
  ///
  /// Returns a path to the compressed video output on success.
  Future<Either<Failure, String>> compressVideo({required String localPath});

  /// Compresses an audio file via the native bindings asynchronously to Mono AAC @ 24kbps.
  ///
  /// Returns a path to the compressed audio output on success.
  Future<Either<Failure, String>> compressAudio({required String localPath});
}











