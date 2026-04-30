import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:minio/minio.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';

@lazySingleton
class CloudMediaService {
  final _minio = Minio(
    endPoint: '3d658adeecc895ef7099eec66a501902.r2.cloudflarestorage.com',
    accessKey: '8b70f8bce8e6bde6982684acac1b047a',
    secretKey: 'e0309cde8aa80e2b327de7d3b6cf4fadaa8e8707b886debd332f17d417bf2c46',
    region: 'auto',
    pathStyle: true,
  );

  /// 👑 BUCKET NAME MUST BE ALL LOWERCASE!
  String get bucketName => 'crown-media-bucket';

  /// Uploads any media type to a specific folder in Cloudflare R2.
  /// Structure: users/{user_id}/{folderName}/Chart_{timestamp}.ext
  Future<String?> uploadMedia(File imageFile, {required String userId, required String folderName, void Function(int, int)? onProgress}) async {
    final extension = path.extension(imageFile.path);
    final rawFileName = 'Chart_${DateTime.now().millisecondsSinceEpoch}$extension';
    
    // 👑 STRICT HIERARCHY: Every file is isolated under users/{user_id}
    // We maintain the requested folder structure to prevent creating new top-level folders.
    // 👑 Path construction: DIRECTLY under users/userId and folderName
    final objectKey = 'users/$userId/$folderName/$rawFileName';

    try {
      debugPrint('☁️ [R2] Uploading to bucket: $bucketName');
      debugPrint('☁️ [R2] Object key: $objectKey');
      
      final fileSize = await imageFile.length();
      int uploadedBytes = 0;

      final mimeType = lookupMimeType(imageFile.path) ?? 'application/octet-stream';
      
      // 👑 PROGRESS WRAPPER: Convert file into a stream that we can monitor
      final stream = imageFile.openRead().map((chunk) {
        uploadedBytes += chunk.length;
        if (onProgress != null) {
          onProgress(uploadedBytes, fileSize);
        }
        return Uint8List.fromList(chunk);
      });

      await _minio.putObject(
        bucketName,
        objectKey,
        stream,
        size: fileSize,
        metadata: {
          'Content-Type': mimeType,
        },
      );

      // Generating the public-facing URL
      final publicUrl = 'https://crown.nexassearch.com/$objectKey';
      debugPrint('✅ [R2] Upload success! URL: $publicUrl');
      return publicUrl;
    } catch (e, stackTrace) {
      debugPrint('❌ [R2] Upload FAILED: $e');
      debugPrint('❌ [R2] Stack: $stackTrace');
      return null;
    }
  }

  /// Bulk upload helper
  Future<List<String>> uploadBatch(List<File> files, {required String userId, required String folderName}) async {
    final List<Future<String?>> uploads = [];
    for (int i = 0; i < files.length; i++) {
        uploads.add(uploadMedia(files[i], userId: userId, folderName: folderName));
    }
    
    final results = await Future.wait(uploads);
    return results.whereType<String>().toList();
  }

  /// 👑 Deletes a file directly from R2 using its public URL
  Future<bool> deleteMediaFromUrl(String publicUrl) async {
    try {
      const prefix = 'https://crown.nexassearch.com/';
      if (!publicUrl.startsWith(prefix)) {
        debugPrint('⚠️ [R2] URL is not in our bucket. Ignoring delete: $publicUrl');
        return true;
      }
      
      final objectKey = publicUrl.substring(prefix.length);
      debugPrint('🗑️ [R2] Deleting object key: $objectKey');
      
      await _minio.removeObject(bucketName, objectKey);
      debugPrint('✅ [R2] Delete success!');
      return true;
    } catch (e) {
      debugPrint('❌ [R2] Delete FAILED: $e');
      return false;
    }
  }
}
