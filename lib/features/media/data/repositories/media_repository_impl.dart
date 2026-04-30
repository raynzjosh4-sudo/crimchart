import 'dart:io';
import 'package:crown/core/errors/failures.dart';
import 'package:crown/core/native/chart_native_ffi.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/media_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart'; // For compute

@LazySingleton(as: MediaRepository)
class MediaRepositoryImpl implements MediaRepository {
  MediaRepositoryImpl();

  @override
  Future<Either<Failure, String>> compressVideo({
    required String localPath,
  }) async {
    try {
      if (!File(localPath).existsSync()) {
        return Left(ServerFailure('Video file does not exist locally.'));
      }

      final cacheDir = await getTemporaryDirectory();
      // Define where the FFmpeg engine will write out to
      final outPath =
          '${cacheDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.mp4';

      // We use `compute` (an isolate) to push this FFI blocTop operation out of the main thread
      // so flutter's GPU UI keeps running at 120 FPS
      final success = await compute(_asyncProcessFFI, {
        'in': localPath,
        'out': outPath,
      });

      if (success) {
        return Right(outPath);
      } else {
        return Left(
          ServerFailure('C++ Engine rejected compression parameters.'),
        );
      }
    } catch (e) {
      return Left(ServerFailure('FFI Call Failed: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> compressAudio({
    required String localPath,
  }) async {
    try {
      if (!File(localPath).existsSync()) {
        return Left(ServerFailure('Audio file does not exist locally.'));
      }

      final cacheDir = await getTemporaryDirectory();
      // Define where the FFmpeg engine will write out to
      final outPath =
          '${cacheDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.m4a';

      // We use `compute` (an isolate) to push this FFI blocTop operation out of the main thread
      // so flutter's UI keeps running at 120 FPS
      final success = await compute(_asyncProcessAudioFFI, {
        'in': localPath,
        'out': outPath,
      });

      if (success) {
        return Right(outPath);
      } else {
        return Left(
          ServerFailure('C++ Engine rejected audio compression parameters.'),
        );
      }
    } catch (e) {
      return Left(ServerFailure('FFI Call Failed: $e'));
    }
  }

  // Pure function necessary for `compute` isolate
  static Future<bool> _asyncProcessFFI(Map<String, String> args) async {
    final ffiBridge = ChartNativeFFI();
    // First ping ensure it spun up
    if (!ffiBridge.initialize()) return false;
    return await ffiBridge.compressVideo(
      inputPath: args['in']!,
      outputPath: args['out']!,
    );
  }

  // Pure function necessary for `compute` isolate
  static Future<bool> _asyncProcessAudioFFI(Map<String, String> args) async {
    final ffiBridge = ChartNativeFFI();
    // First ping ensure it spun up
    if (!ffiBridge.initialize()) return false;
    return await ffiBridge.compressAudio(
      inputPath: args['in']!,
      outputPath: args['out']!,
    );
  }
}











