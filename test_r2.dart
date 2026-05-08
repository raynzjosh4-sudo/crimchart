import 'dart:io';
import 'package:minio/minio.dart';
import 'package:minio/io.dart';
import 'package:path/path.dart' as path;

Future<void> main() async {
  final minio = Minio(
    endPoint: '3d658adeecc895ef7099eec66a501902.r2.cloudflarestorage.com',
    accessKey: '8b70f8bce8e6bde6982684acac1b047a',
    secretKey: 'e0309cde8aa80e2b327de7d3b6cf4fadaa8e8707b886debd332f17d417bf2c46',
    region: 'auto',
  );

  final bucketName = 'crimchart-media-bucket';
  
  // Create dummy file
  final dummyFile = File('dummy.jpg');
  await dummyFile.writeAsString('dummy image data');

  final extension = path.extension(dummyFile.path);
  final fileName = 'crimchart_test_${DateTime.now().millisecondsSinceEpoch}$extension';

  try {
    print('Firing image to Cloudflare R2...');
    
    await minio.fPutObject(
      bucketName,
      fileName,
      dummyFile.path,
    );

    final publicUrl = 'https://crimchart.nexassearch.com/$fileName';
    print('Upload Successful! Image live at: $publicUrl');
  } catch (e) {
    print('Cloudflare Upload Error: $e');
  }
}




