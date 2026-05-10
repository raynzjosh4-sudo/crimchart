import 'dart:async';
import 'package:flutter/material.dart';
import 'native_engine.dart';

/// Represents a single Video Player Instance from our Custom C++ Engine.
class NativeVideoPlayer {
  final int id;
  int? textureId;
  String? currentUrl;
  bool isPlaying = false;

  NativeVideoPlayer({required this.id});

  /// Asks the C++ Engine to load and prepare the video
  Future<void> load(String url) async {
    currentUrl = url;
    // TODO: FFI call to C++ ve_load_video(id, url) -> returns textureId
    // textureId = NativeVideoEngine.loadVideo(id, url);
    print("[Player $id] Loading video: $url");
  }

  /// Asks the C++ Engine to start playback
  void play() {
    if (currentUrl == null) return;
    isPlaying = true;
    // TODO: FFI call to C++ ve_play_video(id)
    print("[Player $id] Playing video");
  }

  /// Asks the C++ Engine to pause playback
  void pause() {
    isPlaying = false;
    // TODO: FFI call to C++ ve_pause_video(id)
    print("[Player $id] Paused video");
  }

  /// Frees the player in the C++ layer
  void dispose() {
    isPlaying = false;
    // TODO: FFI call to C++ ve_dispose_video(id)
    print("[Player $id] Disposed");
  }
}

/// The TikTok-Style Player Pool
/// Manages exactly 3 players to prevent memory leaks and ensure sub-100ms latency.
class VideoPlayerPool {
  static final VideoPlayerPool _instance = VideoPlayerPool._internal();
  factory VideoPlayerPool() => _instance;
  
  VideoPlayerPool._internal();

  final List<NativeVideoPlayer> _players = [];
  final int poolSize = 3;

  void initializePool() {
    if (_players.isNotEmpty) return;
    print("[VideoPlayerPool] Initializing $poolSize C++ Players...");
    for (int i = 0; i < poolSize; i++) {
      _players.add(NativeVideoPlayer(id: i));
    }
  }

  /// Gets an available player from the pool that isn't currently playing
  NativeVideoPlayer? getAvailablePlayer() {
    try {
      return _players.firstWhere((p) => !p.isPlaying);
    } catch (e) {
      // If all players are somehow playing, fallback to the first one
      print("[VideoPlayerPool] Warning: No free players available, forcing recycle.");
      return _players.first;
    }
  }

  /// Pre-warms the next video in the feed using the C++ prefetcher
  void prefetchNextVideo(String url) {
    NativeVideoEngine.prefetch(url);
  }

  void disposeAll() {
    for (var player in _players) {
      player.dispose();
    }
    _players.clear();
  }
}
