import 'dart:ffi' as ffi;
import 'dart:io' show Platform, File;
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit_config.dart';

// --- C type signatures (Windows / Desktop only) ---
typedef _InitC = ffi.Int32 Function();
typedef _InitD = int Function();
typedef _CompressVideoC =
    ffi.Int32 Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);
typedef _CompressVideoD = int Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);
typedef _GetVideoInfoC =
    ffi.Int32 Function(
      ffi.Pointer<Utf8>,
      ffi.Pointer<ffi.Double>,
      ffi.Pointer<ffi.Int32>,
      ffi.Pointer<ffi.Int32>,
      ffi.Pointer<ffi.Double>,
    );
typedef _GetVideoInfoD =
    int Function(
      ffi.Pointer<Utf8>,
      ffi.Pointer<ffi.Double>,
      ffi.Pointer<ffi.Int32>,
      ffi.Pointer<ffi.Int32>,
      ffi.Pointer<ffi.Double>,
    );
typedef _ExtractThumbnailC =
    ffi.Int32 Function(
      ffi.Pointer<Utf8>,
      ffi.Pointer<Utf8>,
      ffi.Double,
      ffi.Int32,
    );
typedef _ExtractThumbnailD =
    int Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>, double, int);
typedef _PreviewStripC =
    ffi.Int32 Function(
      ffi.Pointer<Utf8>,
      ffi.Pointer<Utf8>,
      ffi.Int32,
      ffi.Int32,
    );
typedef _PreviewStripD =
    int Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>, int, int);
typedef _CompressImageC =
    ffi.Int32 Function(
      ffi.Pointer<ffi.Uint8>,
      ffi.Int32,
      ffi.Int32,
      ffi.Int32,
      ffi.Pointer<ffi.Pointer<ffi.Uint8>>,
      ffi.Pointer<ffi.Int32>,
    );
typedef _CompressImageD =
    int Function(
      ffi.Pointer<ffi.Uint8>,
      int,
      int,
      int,
      ffi.Pointer<ffi.Pointer<ffi.Uint8>>,
      ffi.Pointer<ffi.Int32>,
    );
typedef _FreeBufferC = ffi.Void Function(ffi.Pointer<ffi.Uint8>);
typedef _FreeBufferD = void Function(ffi.Pointer<ffi.Uint8>);
typedef _CompressAudioC =
    ffi.Int32 Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>, ffi.Int32);
typedef _CompressAudioD =
    int Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>, int);
typedef _OverlayImageC =
    ffi.Int32 Function(
      ffi.Pointer<Utf8> inVideo,
      ffi.Pointer<Utf8> inImage,
      ffi.Pointer<Utf8> outVideo,
      ffi.Int32 x,
      ffi.Int32 y,
    );
typedef _OverlayImageDart =
    int Function(
      ffi.Pointer<Utf8> inVideo,
      ffi.Pointer<Utf8> inImage,
      ffi.Pointer<Utf8> outVideo,
      int x,
      int y,
    );
typedef _NativeMergeC =
    ffi.Int32 Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);
typedef _NativeMergeDart = int Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);

class VideoInfo {
  final double durationSec;
  final int width;
  final int height;
  final double fps;
  const VideoInfo({
    required this.durationSec,
    required this.width,
    required this.height,
    required this.fps,
  });
  @override
  String toString() =>
      'VideoInfo(${width}x$height @ ${fps.toStringAsFixed(2)}fps, ${durationSec.toStringAsFixed(2)}s)';
}

/// The Universal Media Engine.
/// Automatically picks between Native C++ FFI (Windows/Linux) and FFmpegKit (Android/iOS).
class ChartNativeFFI {
  static ChartNativeFFI? _instance;
  factory ChartNativeFFI() {
    _instance ??= ChartNativeFFI._internal();
    return _instance!;
  }

  ffi.DynamicLibrary? _lib;
  _InitD? _init;
  _CompressVideoD? _compressVideoNative;
  _GetVideoInfoD? _getVideoInfoNative;
  _ExtractThumbnailD? _extractThumbnailNative;
  _PreviewStripD? _previewStripNative;
  _CompressImageD? _compressImageNative;
  _FreeBufferD? _freeBufferNative;
  _CompressAudioD? _compressAudioNative;
  _OverlayImageDart? _overlayImageNative;
  _NativeMergeDart? _mergeVideosNative;

  ChartNativeFFI._internal() {
    try {
      if (Platform.isWindows) {
        _lib = ffi.DynamicLibrary.open('chart_native.dll');
      } else if (Platform.isAndroid) {
        // 👑 UNLOCK ANDROID C++: Loads the NDK-compiled shared library
        _lib = ffi.DynamicLibrary.open('libcrimchat_native.so');
      } else if (Platform.isIOS || Platform.isMacOS) {
        // 👑 UNLOCK IOS/MacOS C++: Uses the main process symbol lookups
        _lib = ffi.DynamicLibrary.process();
      }

      if (_lib != null) {
        _init = _lib!
            .lookup<ffi.NativeFunction<_InitC>>('initialize_media_engine')
            .asFunction();
        _compressVideoNative = _lib!
            .lookup<ffi.NativeFunction<_CompressVideoC>>('compress_video')
            .asFunction();
        _getVideoInfoNative = _lib!
            .lookup<ffi.NativeFunction<_GetVideoInfoC>>('get_video_info')
            .asFunction();
        _extractThumbnailNative = _lib!
            .lookup<ffi.NativeFunction<_ExtractThumbnailC>>('extract_thumbnail')
            .asFunction();
        _previewStripNative = _lib!
            .lookup<ffi.NativeFunction<_PreviewStripC>>(
              'generate_preview_strip',
            )
            .asFunction();
        _compressImageNative = _lib!
            .lookup<ffi.NativeFunction<_CompressImageC>>(
              'compress_image_to_jpeg',
            )
            .asFunction();
        _freeBufferNative = _lib!
            .lookup<ffi.NativeFunction<_FreeBufferC>>('free_native_buffer')
            .asFunction();
        _compressAudioNative = _lib!
            .lookup<ffi.NativeFunction<_CompressAudioC>>('compress_audio')
            .asFunction();
        _overlayImageNative = _lib!
            .lookup<ffi.NativeFunction<_OverlayImageC>>(
              'overlay_image_on_video',
            )
            .asFunction();
        _mergeVideosNative = _lib!
            .lookup<ffi.NativeFunction<_NativeMergeC>>('nativeMergeVideos')
            .asFunction();

        print("✅ Chart Native C++ Engine Loaded Successfully!");
      }
    } catch (e) {
      // Graceful fallback: functions remain null, so we use FFmpeg/Dart fallbacks
      print("⚠️ Native Library not available on this platform: $e");
    }
  }

  bool initialize() {
    if (Platform.isWindows) return _init?.call() == 1;
    return true; // Mobile FFmpeg loads on demand
  }

  /// PROXY: Transcodes video to H.264 uniquely optimized for emerging markets (MTN/Airtel Data Savers)
  Future<bool> compressVideo({
    required String inputPath,
    required String outputPath,
    bool isDataSaver = false,
  }) async {
    if (_compressVideoNative != null) {
      print("🎬 [C++] Transcoding video natively...");
      final inPtr = inputPath.toNativeUtf8();
      final outPtr = outputPath.toNativeUtf8();

      print('🎬 [C++] Starting native compression wrapper...');
      final result = _compressVideoNative!(inPtr, outPtr);
      print('🎬 [C++] Native compression returned: $result');

      malloc.free(inPtr);
      malloc.free(outPtr);

      if (result == 0 && File(outputPath).existsSync()) {
        return true;
      } else {
        print(
          '⚠️ [C++] Native compression FAILED (code: $result). Falling back to FFmpeg...',
        );
      }
    }

    // 👑 FALLBACK: C++ engine missing OR failed — use FFmpegKit on mobile
    print('⚡ [FFmpeg] Using FFmpegKit for video compression...');
    final command = isDataSaver
        // Data-Saver: 480p, H.264, tiny file sizes
        ? '-y -i "$inputPath" -vf "scale=480:-2" -c:v libx264 -preset superfast -crf 32 -c:a aac -ac 1 -ar 44100 "$outputPath"'
        // HD: 720p, H.264, balanced smart-quality (CRF 28)
        : '-y -i "$inputPath" -vf "scale=720:-2" -c:v libx264 -preset superfast -crf 28 -c:a aac -ac 2 -ar 44100 "$outputPath"';
    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();
    final success = ReturnCode.isSuccess(returnCode);
    if (!success) {
      final logs = await session.getLogsAsString();
      print('❌ [FFmpeg Video Fallback Failed]: $logs');
    } else {
      print('✅ [FFmpeg] Compression logic completed successfully');
    }
    return success;
  }

  /// PROXY: Voice Note Compression (WhatsApp Spec - Mono AAC @ 24kbps) for insane data savings
  Future<bool> compressAudio({
    required String inputPath,
    required String outputPath,
    int bitrate = 24000,
  }) async {
    // 👑 Use Native C++ if available on ANY platform
    if (_compressAudioNative != null) {
      final inPtr = inputPath.toNativeUtf8();
      final outPtr = outputPath.toNativeUtf8();
      final ret = _compressAudioNative!(inPtr, outPtr, bitrate);
      malloc.free(inPtr);
      malloc.free(outPtr);
      return ret == 0;
    } else {
      // Fallback to FFmpeg package (Mobile standard)
      final command =
          '-y -i "$inputPath" -vn -c:a aac -b:a ${bitrate ~/ 1000}k -ac 1 "$outputPath"';
      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();
      return ReturnCode.isSuccess(returnCode);
    }
  }

  /// PROXY: Fetch Metadata in O(1)
  Future<VideoInfo?> getVideoInfo(String path) async {
    // 👑 Use Native C++ if available on ANY platform
    if (_getVideoInfoNative != null) {
      final pathPtr = path.toNativeUtf8();
      final dur = malloc<ffi.Double>();
      final w = malloc<ffi.Int32>();
      final h = malloc<ffi.Int32>();
      final fps = malloc<ffi.Double>();
      final ret = _getVideoInfoNative!(pathPtr, dur, w, h, fps);
      VideoInfo? info;
      if (ret == 0)
        info = VideoInfo(
          durationSec: dur.value,
          width: w.value,
          height: h.value,
          fps: fps.value,
        );
      malloc.free(pathPtr);
      malloc.free(dur);
      malloc.free(w);
      malloc.free(h);
      malloc.free(fps);
      return info;
    } else {
      // Fallback to FFprobe tool
      final session = await FFprobeKit.getMediaInformation(path);
      final info = session.getMediaInformation();
      if (info == null) return null;
      final streams = info.getStreams();
      final video = streams.firstWhere((s) => s.getType() == 'video');
      return VideoInfo(
        durationSec: double.tryParse(info.getDuration() ?? '0') ?? 0.0,
        width: video.getWidth() ?? 0,
        height: video.getHeight() ?? 0,
        fps: double.tryParse(video.getAverageFrameRate() ?? '30') ?? 30.0,
      );
    }
  }

  /// PROXY: Instant Thumbnails
  Future<bool> extractThumbnail({
    required String inputPath,
    required String outputPath,
    double timeSec = 0.0,
    int thumbWidth = 320,
  }) async {
    // 👑 Use Native C++ if available on ANY platform
    if (_extractThumbnailNative != null) {
      final inPtr = inputPath.toNativeUtf8();
      final outPtr = outputPath.toNativeUtf8();
      
      print('🎬 [C++] Extracting thumbnail natively...');
      final ret = _extractThumbnailNative!(inPtr, outPtr, timeSec, thumbWidth);
      print('🎬 [C++] Native thumbnail extraction returned: $ret');

      malloc.free(inPtr);
      malloc.free(outPtr);
      
      if (ret == 0 && File(outputPath).existsSync()) {
        return true;
      } else {
        print('⚠️ [C++] Native thumbnail FAILED (code: $ret). Falling back...');
        return false;
      }
    } else {
      // Fallback to FFmpeg package (Mobile standard)
      final session = await FFmpegKit.execute(
        '-ss $timeSec -i "$inputPath" -vf "scale=$thumbWidth:-1" -vframes 1 "$outputPath"',
      );
      final returnCode = await session.getReturnCode();
      return ReturnCode.isSuccess(returnCode);
    }
  }

  /// PROXY: Scrub bar preview generation
  Future<int> generatePreviewStrip({
    required String inputPath,
    required String outputDir,
    int numFrames = 12,
    int thumbWidth = 160,
  }) async {
    if (Platform.isWindows && _previewStripNative != null) {
      final inPtr = inputPath.toNativeUtf8();
      final outPtr = outputDir.toNativeUtf8();
      final ret = _previewStripNative!(inPtr, outPtr, numFrames, thumbWidth);
      malloc.free(inPtr);
      malloc.free(outPtr);
      return ret;
    } else {
      // Batch extraction on Mobile
      final session = await FFmpegKit.execute(
        '-i "$inputPath" -vf "fps=$numFrames/duration,scale=$thumbWidth:-1" "$outputDir/%03d.jpg"',
      );
      final returnCode = await session.getReturnCode();
      return ReturnCode.isSuccess(returnCode) ? numFrames : 0;
    }
  }

  /// PROXY: High-Speed Image Resizer & Compressor Engine
  /// Natively compresses any image filepath into a target JPEG using the powerful FFmpeg engine.
  Future<bool> compressPhoto({
    required String inputPath,
    required String outputPath,
    int width = 720,
    int quality = 2, // 2 is very high quality, 31 is lowest
  }) async {
    try {
      // Scales proportionally to fit within 'width' while maintaining aspect ratio
      final command =
          '-y -i "$inputPath" -vf "scale=\'min($width,iw)\':-1" -q:v $quality "$outputPath"';
      final session = await FFmpegKit.execute(command);
      return ReturnCode.isSuccess(await session.getReturnCode());
    } catch (e) {
      print("❌ [FFmpeg Image Compressor Error]: $e");
      return false;
    }
  }

  /// PROXY: Fuse an image (sticker/watermark) onto a video at specific coordinates
  Future<bool> overlaySticker({
    required String videoPath,
    required String imagePath,
    required String outputPath,
    required int xPosition,
    required int yPosition,
  }) async {
    if (_overlayImageNative != null) {
      print("🎨 [FFI] Fusing image onto video at X:$xPosition Y:$yPosition...");
      final inVidPtr = videoPath.toNativeUtf8();
      final inImgPtr = imagePath.toNativeUtf8();
      final outVidPtr = outputPath.toNativeUtf8();

      final result = _overlayImageNative!(
        inVidPtr,
        inImgPtr,
        outVidPtr,
        xPosition,
        yPosition,
      );

      malloc.free(inVidPtr);
      malloc.free(inImgPtr);
      malloc.free(outVidPtr);

      return result == 0;
    }
    print("❌ [FFI] C++ Pro Engine not found! Cannot apply overlay.");
    return false;
  }

  /// PROXY: High-Performance C++ Video Merger
  /// Combines a list of media paths into a single output video natively.
  Future<bool> mergeMedia({
    required List<String> paths,
    required String outputPath,
    Map<String, dynamic>? recipe, // NLE JSON Recipe Payload
  }) async {
    if (_mergeVideosNative != null && Platform.isWindows && recipe == null) {
      print("🎬 [C++] Merging ${paths.length} segments natively...");
      final pathsPtr = paths.join(',').toNativeUtf8();
      final outPtr = outputPath.toNativeUtf8();

      final result = _mergeVideosNative!(pathsPtr, outPtr);

      malloc.free(pathsPtr);
      malloc.free(outPtr);

      if (result == 0) return true;
    }

    if (recipe != null) {
      print(
        "🚀 [FFmpeg NLE Engine] Parsing Recipe into Complex Filter Graph...",
      );
      try {
        final baseTrack = recipe['base_track'] as List<dynamic>;
        StringBuffer inputs = StringBuffer();
        StringBuffer filters = StringBuffer();

        // 1. Inputs Provisioning
        for (int i = 0; i < baseTrack.length; i++) {
          final item = baseTrack[i];
          final path = item['path'];
          final isImage = item['type'] == 'image';
          if (isImage) {
            // Because 'zoompan' inside the complex filter generates frames from a single image,
            // we MUST NOT loop the input here, otherwise zoompan will multiply the frames exponentially.
            inputs.write('-i "$path" ');
          } else {
            inputs.write('-i "$path" '); // Standard Video
          }
        }

        bool hasMusic = recipe['audio_track'] != null;
        if (hasMusic) inputs.write('-i "${recipe['audio_track']['path']}" ');

        // 2. Filter Graph Construction
        for (int i = 0; i < baseTrack.length; i++) {
          final isImage = baseTrack[i]['type'] == 'image';
          if (isImage) {
            // ANIMATION NODE: Dynamically Zoom and Pan a single image into a video stream.
            // d= frames (e.g. 30fps * 3s = 90 frames, or dynamically calculated).
            // We use the exact duration in seconds * 30fps.
            final durSec =
                ((baseTrack[i]['end_ms'] ?? 3000) -
                    (baseTrack[i]['start_ms'] ?? 0)) /
                1000.0;
            final frames = (durSec * 30).toInt();

            filters.write(
              '[$i:v]scale=720:1280:force_original_aspect_ratio=increase,crop=720:1280,zoompan=z=\'min(zoom+0.0015,1.5)\':d=$frames:s=720x1280:fps=30[v$i]; ',
            );

            // AUDIO MOCK: Generate silent audio for the image so concatenation doesn't crash
            filters.write('anullsrc=r=44100:cl=stereo:d=$durSec[a$i]; ');
          } else {
            // SCALING NODE: Normalizing videos to 720x1280 Portrait
            filters.write(
              '[$i:v]scale=720:1280:force_original_aspect_ratio=increase,crop=720:1280,setsar=1[v$i]; ',
            );
            filters.write(
              '[$i:a]aformat=sample_rates=44100:channel_layouts=stereo[a$i]; ',
            );
          }
        }

        // CONCAT NODE
        for (int i = 0; i < baseTrack.length; i++) filters.write('[v$i][a$i]');
        filters.write(
          'concat=n=${baseTrack.length}:v=1:a=1[v_concat][a_concat]; ',
        );

        // OVERLAY MANAGER
        String currentVideo = 'v_concat';
        final overlays = recipe['overlay_track'] as List<dynamic>? ?? [];
        int overlayInputIndex = baseTrack.length + (hasMusic ? 1 : 0);

        for (int j = 0; j < overlays.length; j++) {
          final o = overlays[j];
          if (o['type'] == 'text') {
            // FFmpeg DrawText Generator (Decodes Dart ARGB to FFmpeg RGB)
            final colorFull = o['color_hex']?.toString() ?? 'ffffffff';
            final colorBg = o['has_bg'] == true
                ? ':box=1:boxcolor=black@0.5'
                : '';
            final color = colorFull.length == 8
                ? colorFull.substring(2)
                : 'ffffff';
            final text = o['content']?.toString().replaceAll("'", "\\'") ?? '';
            filters.write(
              '[$currentVideo]drawtext=text=\'$text\':fontcolor=$color:fontsize=50:x=${o['x']}:y=${o['y']}$colorBg[v_out$j]; ',
            );
            currentVideo = 'v_out$j';
          } else {
            // Sticker Layer Fusion
            inputs.write('-i "${o['content']}" ');
            filters.write(
              '[$overlayInputIndex:v]scale=-1:100[sticker$j]; [$currentVideo][sticker$j]overlay=${o['x']}:${o['y']}[v_out$j]; ',
            );
            currentVideo = 'v_out$j';
            overlayInputIndex++;
          }
        }

        // AUDIO MIXER NODE
        String finalAudioMap = 'a_concat';
        if (hasMusic) {
          final musicIdx = baseTrack.length;
          filters.write(
            '[a_concat][$musicIdx:a]amix=inputs=2:duration=first:dropout_transition=2[a_mixed]; ',
          );
          finalAudioMap = 'a_mixed';
        }

        // Execute the Masterpiece
        final appDir = await getTemporaryDirectory();
        final filterFile = File(
          '${appDir.path}/complex_filter_${DateTime.now().millisecondsSinceEpoch}.txt',
        );
        await filterFile.writeAsString(filters.toString().trim());

        final command =
            '-y ${inputs.toString()}-filter_complex_script "${filterFile.path}" -map "[$currentVideo]" -map "[$finalAudioMap]" -c:v libx264 -preset ultrafast -pix_fmt yuv420p -c:a aac -b:a 128k "$outputPath"';

        print("🔥 [FFmpeg Compiled Graph Execution]: \n$command");

        FFmpegKitConfig.enableLogCallback((log) {
          final msg = log.getMessage();
          if (msg.contains("frame=") || msg.contains("Error")) {
            print("📺 [FFmpeg]: $msg");
          }
        });

        final session = await FFmpegKit.execute(command);
        FFmpegKitConfig.enableLogCallback(null); // Cleanup
        final returnCode = await session.getReturnCode();

        if (ReturnCode.isSuccess(returnCode))
          return true;
        else
          print("❌ [FFmpeg Failed Graph]: \${await session.getLogsAsString()}");
      } catch (e) {
        print("❌ [FFmpeg NLE Compiler Crash]: $e");
      }
    }

    // 👑 Basic Fallback / No-Recipe Concat
    print("🎬 [FFmpegKit] Fallback Merging ${paths.length} segments...");
    try {
      final appDir = await getTemporaryDirectory();
      final listFile = File(
        '${appDir.path}/merge_list_${DateTime.now().millisecondsSinceEpoch}.txt',
      );

      final sb = StringBuffer();
      for (var path in paths) {
        sb.writeln("file '$path'");
      }
      await listFile.writeAsString(sb.toString());

      final command =
          '-y -f concat -safe 0 -i "${listFile.path}" -c copy "$outputPath"';
      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      if (await listFile.exists()) await listFile.delete();
      return ReturnCode.isSuccess(returnCode);
    } catch (e) {
      print("❌ Error during merge fallback: $e");
      return false;
    }
  }

  /// PROXY: High-Performance Single Item Baker (For Story / Post Carousel modes)
  /// Bakes text, stickers, and filters permanently into a single .jpg or .mp4
  Future<bool> bakeSingleMedia({
    required Map<String, dynamic> itemRecipe,
    required List<dynamic> overlays,
    required String outputPath,
  }) async {
    try {
      final isImage = itemRecipe['type'] == 'image';
      final path = itemRecipe['path'];

      StringBuffer inputs = StringBuffer();
      StringBuffer filters = StringBuffer();

      inputs.write('-y -i "$path" ');

      String currentStream = '0:v';

      // 1. Base Scaling
      if (isImage) {
        filters.write(
          '[$currentStream]scale=720:1280:force_original_aspect_ratio=increase,crop=720:1280[v_base]; ',
        );
      } else {
        filters.write(
          '[$currentStream]scale=720:1280:force_original_aspect_ratio=increase,crop=720:1280,setsar=1[v_base]; ',
        );
      }
      currentStream = 'v_base';

      // 2. Overlays
      int overlayIdx = 1;
      for (int j = 0; j < overlays.length; j++) {
        final o = overlays[j];
        // Only process overlays meant for this item (simplified for now as they are all passed)
        if (o['type'] == 'text') {
          final colorFull = o['color_hex']?.toString() ?? 'ffffffff';
          final colorBg = o['has_bg'] == true
              ? ':box=1:boxcolor=black@0.5'
              : '';
          final color = colorFull.length == 8
              ? colorFull.substring(2)
              : 'ffffff';
          final text = o['content']?.toString().replaceAll("'", "\\'") ?? '';
          filters.write(
            '[$currentStream]drawtext=text=\'$text\':fontcolor=$color:fontsize=50:x=${o['x']}:y=${o['y']}$colorBg[v_out$j]; ',
          );
          currentStream = 'v_out$j';
        } else {
          inputs.write('-i "${o['content']}" ');
          filters.write(
            '[$overlayIdx:v]scale=-1:100[sticker$j]; [$currentStream][sticker$j]overlay=${o['x']}:${o['y']}[v_out$j]; ',
          );
          currentStream = 'v_out$j';
          overlayIdx++;
        }
      }

      final appDir = await getTemporaryDirectory();
      final filterFile = File(
        '${appDir.path}/bake_filter_${DateTime.now().millisecondsSinceEpoch}.txt',
      );
      await filterFile.writeAsString(filters.toString().trim());

      String filterCmd = filters.toString().trim().isEmpty
          ? ""
          : '-filter_complex_script "${filterFile.path}"';
      String mapCmd = filters.toString().trim().isEmpty
          ? ""
          : '-map "[$currentStream]"';

      // If video, map audio too.
      if (!isImage && filters.toString().trim().isNotEmpty) {
        mapCmd += ' -map 0:a?';
      }

      String outputArgs = isImage
          ? "-vframes 1 -q:v 2"
          : "-c:v libx264 -preset ultrafast -pix_fmt yuv420p -c:a copy";

      final command =
          '${inputs.toString()} $filterCmd $mapCmd $outputArgs "$outputPath"';
      print("🔥 [FFmpeg Single Baker]: \n$command");

      final session = await FFmpegKit.execute(command);
      return ReturnCode.isSuccess(await session.getReturnCode());
    } catch (e) {
      print("❌ [FFmpeg Baker Crash]: $e");
      return false;
    }
  }
}
