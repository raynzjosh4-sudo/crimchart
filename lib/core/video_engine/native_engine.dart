import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';

// Defines the function signatures
typedef _VeInitEngineC = ffi.Int32 Function();
typedef _VeInitEngineDart = int Function();

typedef _VePingC = ffi.Int32 Function(ffi.Int32 val);
typedef _VePingDart = int Function(int val);

typedef _VePrefetchVideoC = ffi.Int32 Function(ffi.Pointer<Utf8> url);
typedef _VePrefetchVideoDart = int Function(ffi.Pointer<Utf8> url);

typedef _VePlayVideoC = ffi.Int32 Function(ffi.Int32 textureId, ffi.Pointer<Utf8> url);
typedef _VePlayVideoDart = int Function(int textureId, ffi.Pointer<Utf8> url);

typedef _VeDisposeVideoC = ffi.Int32 Function(ffi.Int32 textureId);
typedef _VeDisposeVideoDart = int Function(int textureId);

typedef _VeStopVideoC = ffi.Int32 Function(ffi.Int32 textureId);
typedef _VeStopVideoDart = int Function(int textureId);

typedef _VePauseVideoC = ffi.Int32 Function(ffi.Int32 textureId);
typedef _VePauseVideoDart = int Function(int textureId);

typedef _VeResumeVideoC = ffi.Int32 Function(ffi.Int32 textureId);
typedef _VeResumeVideoDart = int Function(int textureId);

class NativeVideoEngine {
  static late final ffi.DynamicLibrary _lib;

  static late final _VeInitEngineDart _initEngine;
  static late final _VePingDart _ping;
  static late final _VePrefetchVideoDart _prefetchVideo;
  static late final _VePlayVideoDart _playVideo;
  static late final _VeDisposeVideoDart _disposeVideo;
  static late final _VeStopVideoDart _stopVideo;
  static late final _VePauseVideoDart _pauseVideo;
  static late final _VeResumeVideoDart _resumeVideo;

  static bool _initialized = false;

  static void initialize() {
    if (_initialized) return;

    if (Platform.isWindows) {
      _lib = ffi.DynamicLibrary.open('crimchart_native.dll');
    } else if (Platform.isAndroid) {
      // On Android, we build the C++ code into a shared object library
      _lib = ffi.DynamicLibrary.open('libcrimchart_native.so');
    } else if (Platform.isIOS) {
      // On iOS, C++ code is typically statically linked into the Runner executable
      _lib = ffi.DynamicLibrary.process();
    } else {
      throw UnsupportedError('Platform not supported for NativeVideoEngine');
    }

    _initEngine = _lib.lookupFunction<_VeInitEngineC, _VeInitEngineDart>(
      've_init_engine',
    );
    _ping = _lib.lookupFunction<_VePingC, _VePingDart>('ve_ping');
    _prefetchVideo = _lib
        .lookupFunction<_VePrefetchVideoC, _VePrefetchVideoDart>(
          've_prefetch_video',
        );
        
    try {
      _playVideo = _lib.lookupFunction<_VePlayVideoC, _VePlayVideoDart>('ve_play_video');
      _disposeVideo = _lib.lookupFunction<_VeDisposeVideoC, _VeDisposeVideoDart>('ve_dispose_video');
      _stopVideo = _lib.lookupFunction<_VeStopVideoC, _VeStopVideoDart>('ve_stop_video');
      _pauseVideo = _lib.lookupFunction<_VePauseVideoC, _VePauseVideoDart>('ve_pause_video');
      _resumeVideo = _lib.lookupFunction<_VeResumeVideoC, _VeResumeVideoDart>('ve_resume_video');
    } catch (e) {
      print('[NativeVideoEngine Dart] Optional ve_play_video, ve_stop_video, ve_pause_video, ve_resume_video or ve_dispose_video not found.');
    }

    final result = _initEngine();
    print('[NativeVideoEngine Dart] Initialization result: $result');

    _initialized = true;
  }

  static int ping(int val) {
    if (!_initialized) initialize();
    return _ping(val);
  }

  static void prefetch(String url) {
    if (!_initialized) initialize();
    final urlPointer = url.toNativeUtf8();
    try {
      final result = _prefetchVideo(urlPointer);
      print('[NativeVideoEngine Dart] Prefetch queued: $result');
    } finally {
      malloc.free(urlPointer);
    }
  }

  static void playVideo(int textureId, String url) {
    if (!_initialized) initialize();
    if (Platform.isWindows) return; // Not implemented on Windows yet
    final urlPointer = url.toNativeUtf8();
    try {
      final result = _playVideo(textureId, urlPointer);
      print('[NativeVideoEngine Dart] Play queued: $result');
    } finally {
      malloc.free(urlPointer);
    }
  }

  static void disposeVideo(int textureId) {
    if (!_initialized) return;
    if (Platform.isWindows) return;
    try {
      final result = _disposeVideo(textureId);
      print('[NativeVideoEngine Dart] Dispose video $textureId: $result');
    } catch (e) {
      print('[NativeVideoEngine Dart] Error disposing video: $e');
    }
  }

  static void stopVideo(int textureId) {
    if (!_initialized) return;
    if (Platform.isWindows) return;
    try {
      final result = _stopVideo(textureId);
      print('[NativeVideoEngine Dart] Stop video $textureId: $result');
    } catch (e) {
      print('[NativeVideoEngine Dart] Error stopping video: $e');
    }
  }

  static void pauseVideo(int textureId) {
    if (!_initialized) return;
    if (Platform.isWindows) return;
    try {
      final result = _pauseVideo(textureId);
      print('[NativeVideoEngine Dart] Pause video $textureId: $result');
    } catch (e) {
      print('[NativeVideoEngine Dart] Error pausing video: $e');
    }
  }

  static void preloadVideo(int textureId, String url) {
    if (!_initialized) initialize();
    if (Platform.isWindows) return;
    
    // First play the video
    playVideo(textureId, url);
    
    // Then immediately pause it to freeze on the first frame
    try {
      final result = _pauseVideo(textureId);
      print('[NativeVideoEngine Dart] Preload (Pause) queued $textureId: $result');
    } catch (e) {
      print('[NativeVideoEngine Dart] Error preloading video: $e');
    }
  }

  static void resumeVideo(int textureId) {
    if (!_initialized) initialize();
    if (Platform.isWindows) return;
    try {
      final result = _resumeVideo(textureId);
      print('[NativeVideoEngine Dart] Resume queued $textureId: $result');
    } catch (e) {
      print('[NativeVideoEngine Dart] Error resuming video: $e');
    }
  }

  /// Phase 2: The Texture Bridge
  /// Calls the Android Kotlin MethodChannel which creates a SurfaceTexture
  /// and passes the native window to C++.
  static const ffiChannel = MethodChannel('crown.dev/video_engine');

  static Future<int> createTexture() async {
    try {
      final int textureId = await ffiChannel.invokeMethod('createTexture');
      print('[NativeVideoEngine Dart] Got Hardware Texture ID: $textureId');
      return textureId;
    } catch (e) {
      print('[NativeVideoEngine Dart] Failed to create Texture: $e');
      return -1;
    }
  }

  static Future<void> disposeTexture(int textureId) async {
    try {
      await ffiChannel.invokeMethod('disposeTexture', {'textureId': textureId});
      print('[NativeVideoEngine Dart] Kotlin Surface/Texture released: $textureId');
    } catch (e) {
      print('[NativeVideoEngine Dart] Failed to dispose Texture: $e');
    }
  }
}
