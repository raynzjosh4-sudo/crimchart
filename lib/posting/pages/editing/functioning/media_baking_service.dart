import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';

import '../../../models/media_item.dart';
import 'edit_post_controller.dart';
import '../../../../core/native/chart_native_ffi.dart';

/// Result of a single baked media item.
class BakedMediaResult {
  final String outputPath;
  final MediaType type;
  final bool success;
  final String? error;

  const BakedMediaResult({
    required this.outputPath,
    required this.type,
    required this.success,
    this.error,
  });
}

/// Progress update emitted during baking.
class BakeProgress {
  final int currentItem;
  final int totalItems;
  final String stage; // e.g. "Compressing video 1/3", "Baking text overlay..."

  const BakeProgress({
    required this.currentItem,
    required this.totalItems,
    required this.stage,
  });

  double get fraction =>
      totalItems == 0 ? 0 : currentItem / totalItems;
}

/// The MediaBakingService converts the non-destructive EditPostController
/// state (the "recipe") into final, export-ready media files.
///
/// Architecture:
///   1. Read the recipe from EditPostController.generateProcessRecipe()
///   2. For each base track item, apply:
///      a. Compression (C++ native → FFmpeg fallback)
///      b. Crop/Rotation (FFmpeg lavfi)
///      c. Color adjustments (brightness/contrast/saturation via FFmpeg eq filter)
///      d. Text & emoji overlays (Flutter screenshot → PNG → FFmpeg drawtext/overlay)
///      e. Speed adjustment (FFmpeg setpts + atempo)
///   3. For multi-clip compositions, concatenate using FFmpeg concat demuxer
///   4. Return a List<BakedMediaResult> for the upload pipeline.
class MediaBakingService {
  static MediaBakingService? _instance;
  factory MediaBakingService() {
    _instance ??= MediaBakingService._internal();
    return _instance!;
  }
  MediaBakingService._internal();

  final ChartNativeFFI _native = ChartNativeFFI();

  // ── Public API ────────────────────────────────────────────────────────────

  /// Bakes all media in [controller] according to its edit state.
  /// Reports progress via [onProgress].
  Future<List<BakedMediaResult>> bakeAll(
    EditPostController controller, {
    ValueChanged<BakeProgress>? onProgress,
  }) async {
    final recipe = controller.generateProcessRecipe();
    final baseTrack = List<Map<String, dynamic>>.from(recipe['base_track']);
    final overlayTrack =
        List<Map<String, dynamic>>.from(recipe['overlay_track']);
    final tmpDir = await getTemporaryDirectory();

    final results = <BakedMediaResult>[];

    for (int i = 0; i < baseTrack.length; i++) {
      final clip = baseTrack[i];
      final state = controller.mediaStates[i];

      onProgress?.call(BakeProgress(
        currentItem: i + 1,
        totalItems: baseTrack.length,
        stage: 'Processing clip ${i + 1} of ${baseTrack.length}…',
      ));

      try {
        final result = await _bakeClip(
          clip: clip,
          state: state,
          overlays: overlayTrack
              .where((o) =>
                  (o['start_ms'] as num) >= (clip['start_ms'] as num) &&
                  (o['start_ms'] as num) < (clip['end_ms'] as num))
              .toList(),
          tmpDir: tmpDir,
          index: i,
          onProgress: (stage) => onProgress?.call(BakeProgress(
            currentItem: i + 1,
            totalItems: baseTrack.length,
            stage: stage,
          )),
        );
        results.add(result);
      } catch (e) {
        results.add(BakedMediaResult(
          outputPath: clip['path'] as String,
          type: clip['type'] == 'video' ? MediaType.video : MediaType.photo,
          success: false,
          error: e.toString(),
        ));
      }
    }

    return results;
  }

  // ── Internal per-clip baking ───────────────────────────────────────────────

  Future<BakedMediaResult> _bakeClip({
    required Map<String, dynamic> clip,
    required MediaEditState state,
    required List<Map<String, dynamic>> overlays,
    required Directory tmpDir,
    required int index,
    ValueChanged<String>? onProgress,
  }) async {
    final inputPath = clip['path'] as String;
    final isVideo = clip['type'] == 'video';
    final mediaType = isVideo ? MediaType.video : MediaType.photo;

    // Step 1: Compression
    onProgress?.call('Step 1/4 — Compressing media…');
    final compressed = '${tmpDir.path}/bake_${index}_compressed.${isVideo ? 'mp4' : 'jpg'}';
    final compressOk = await _compress(
      inputPath: inputPath,
      outputPath: compressed,
      isVideo: isVideo,
    );
    final workingPath = compressOk ? compressed : inputPath;

    // Step 2: Crop + Rotation + Color Grading
    onProgress?.call('Step 2/4 — Applying crop, rotation & color grade…');
    final graded = '${tmpDir.path}/bake_${index}_graded.${isVideo ? 'mp4' : 'jpg'}';
    final gradeOk = await _applyColorGrade(
      inputPath: workingPath,
      outputPath: graded,
      isVideo: isVideo,
      cropRect: state.cropRect,
      rotationDeg: state.rotation,
      brightness: state.brightness,
      contrast: state.contrast,
      saturation: state.saturation,
      speed: (clip['speed'] as num?)?.toDouble() ?? 1.0,
    );
    final gradedPath = gradeOk ? graded : workingPath;

    // Step 3: Bake overlays (text/emoji)
    onProgress?.call('Step 3/4 — Baking text & emoji overlays…');
    final baked = '${tmpDir.path}/bake_${index}_final.${isVideo ? 'mp4' : 'jpg'}';
    final bakeOk = await _bakeOverlays(
      inputPath: gradedPath,
      outputPath: baked,
      overlays: overlays,
      isVideo: isVideo,
    );
    final finalPath = bakeOk ? baked : gradedPath;

    // Step 4: Cleanup intermediates
    onProgress?.call('Step 4/4 — Finalizing…');
    try {
      if (compressOk && compressed != finalPath) File(compressed).deleteSync();
      if (gradeOk && graded != finalPath) File(graded).deleteSync();
    } catch (_) {}

    return BakedMediaResult(
      outputPath: finalPath,
      type: mediaType,
      success: true,
    );
  }

  // ── Step 1: Compression (C++ → FFmpeg fallback) ───────────────────────────

  Future<bool> _compress({
    required String inputPath,
    required String outputPath,
    required bool isVideo,
  }) async {
    if (isVideo) {
      return _native.compressVideo(
        inputPath: inputPath,
        outputPath: outputPath,
      );
    } else {
      // Images: use FFmpeg to re-encode as high quality JPEG
      final session = await FFmpegKit.execute(
        '-y -i "$inputPath" -q:v 2 "$outputPath"',
      );
      final rc = await session.getReturnCode();
      return ReturnCode.isSuccess(rc);
    }
  }

  // ── Step 2: Color Grade + Crop + Rotation ─────────────────────────────────

  Future<bool> _applyColorGrade({
    required String inputPath,
    required String outputPath,
    required bool isVideo,
    required Rect cropRect,
    required double rotationDeg,
    required double brightness,
    required double contrast,
    required double saturation,
    required double speed,
  }) async {
    // Build FFmpeg vf filter chain
    final filters = <String>[];

    // 1. Crop: cropRect is normalized [0..1], we need actual pixel values
    //    FFmpeg crop=w:h:x:y using iw/ih expressions
    final cx = cropRect.left;
    final cy = cropRect.top;
    final cw = cropRect.width;
    final ch = cropRect.height;
    if (cx > 0.01 || cy > 0.01 || cw < 0.99 || ch < 0.99) {
      filters.add(
        'crop=iw*$cw:ih*$ch:iw*$cx:ih*$cy',
      );
    }

    // 2. Rotation (transpose for 90° steps, or rotate for arbitrary)
    final rot = rotationDeg % 360;
    if (rot == 90) {
      filters.add('transpose=1');
    } else if (rot == 180) {
      filters.add('transpose=2,transpose=2');
    } else if (rot == 270) {
      filters.add('transpose=2');
    } else if (rot.abs() > 0.5) {
      // Arbitrary free rotation
      filters.add('rotate=${rot * 3.14159265 / 180}');
    }

    // 3. Color grading via eq filter
    // FFmpeg eq: brightness [-1..1], contrast [0..2], saturation [0..3]
    final eqBrightness = (brightness / 255).clamp(-1.0, 1.0);
    final eqContrast = contrast.clamp(0.0, 2.0);
    final eqSaturation = saturation.clamp(0.0, 3.0);

    if (eqBrightness.abs() > 0.01 ||
        (eqContrast - 1.0).abs() > 0.01 ||
        (eqSaturation - 1.0).abs() > 0.01) {
      filters.add(
        'eq=brightness=$eqBrightness:contrast=$eqContrast:saturation=$eqSaturation',
      );
    }

    final vfChain = filters.isEmpty ? null : filters.join(',');

    // Build audio filters (speed adjustment)
    final af = speed != 1.0 ? 'atempo=${speed.clamp(0.5, 100.0)}' : null;
    // Speed via video setpts
    final pts = speed != 1.0 ? 'setpts=${(1.0 / speed).toStringAsFixed(6)}*PTS' : null;

    // Final vf chain with speed
    final finalVf = [
      if (vfChain != null) vfChain,
      if (pts != null) pts,
    ].join(',');

    String command;
    if (isVideo) {
      command = '-y -i "$inputPath"'
          '${finalVf.isNotEmpty ? ' -vf "$finalVf"' : ''}'
          '${af != null ? ' -af "$af"' : ''}'
          ' -c:v libx264 -preset superfast -crf 26 -c:a aac "$outputPath"';
    } else {
      command = '-y -i "$inputPath"'
          '${finalVf.isNotEmpty ? ' -vf "$finalVf"' : ''}'
          ' -q:v 2 "$outputPath"';
    }

    final session = await FFmpegKit.execute(command);
    final rc = await session.getReturnCode();
    if (!ReturnCode.isSuccess(rc)) {
      final logs = await session.getLogsAsString();
      debugPrint('⚠️ [Bake] Color grade failed: $logs');
      return false;
    }
    return true;
  }

  // ── Step 3: Text & Emoji Overlay Baking ───────────────────────────────────

  Future<bool> _bakeOverlays({
    required String inputPath,
    required String outputPath,
    required List<Map<String, dynamic>> overlays,
    required bool isVideo,
  }) async {
    if (overlays.isEmpty) {
      // Nothing to overlay — just copy
      await File(inputPath).copy(outputPath);
      return true;
    }

    // Build a drawtext filter for each text overlay.
    // For image overlays (emoji rendered as text), we use drawtext too.
    final filters = <String>[];

    for (final overlay in overlays) {
      final type = overlay['type'] as String;
      if (type != 'text') continue; // Skip image overlays (not supported yet)

      final content = (overlay['content'] as String? ?? '').replaceAll("'", "\\'").replaceAll(':', '\\:');
      final x = (overlay['x'] as num?)?.toInt() ?? 0;
      final y = (overlay['y'] as num?)?.toInt() ?? 0;
      final scale = (overlay['scale'] as num?)?.toDouble() ?? 1.0;
      final fontSize = (26 * scale).round();
      final hasBg = (overlay['has_bg'] as bool?) ?? false;
      final colorHex = overlay['color_hex'] as String? ?? 'ffffff';
      final fontColor = '0x$colorHex';

      // Background box
      final box = hasBg ? ':box=1:boxcolor=0x$colorHex@0.8:boxborderw=8' : '';

      // FFmpeg on Android needs an absolute path to a font file, otherwise it crashes trying to find 'Sans'.
      // We use the standard Roboto font present on all Android devices as a safe fallback.
      final fontFile = Platform.isAndroid ? '/system/fonts/Roboto-Regular.ttf' : '';
      final fontParam = fontFile.isNotEmpty ? ":fontfile='$fontFile'" : '';

      filters.add(
        "drawtext=text='$content':x=$x:y=$y:fontsize=$fontSize$fontParam"
        ":fontcolor=$fontColor$box"
        ":shadowcolor=black:shadowx=1:shadowy=1",
      );
    }

    if (filters.isEmpty) {
      await File(inputPath).copy(outputPath);
      return true;
    }

    final vf = filters.join(',');
    final command = isVideo
        ? '-y -i "$inputPath" -vf "$vf" -c:v libx264 -preset superfast -crf 26 -c:a copy "$outputPath"'
        : '-y -i "$inputPath" -vf "$vf" -q:v 2 "$outputPath"';

    final session = await FFmpegKit.execute(command);
    final rc = await session.getReturnCode();
    if (!ReturnCode.isSuccess(rc)) {
      final logs = await session.getLogsAsString();
      debugPrint('⚠️ [Bake] Overlay bake failed: $logs');
      return false;
    }
    return true;
  }

  // ── Convenience: dump recipe as pretty JSON (for debugging) ──────────────

  static String dumpRecipe(Map<String, dynamic> recipe) {
    return const JsonEncoder.withIndent('  ').convert(recipe);
  }
}
