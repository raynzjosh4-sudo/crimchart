import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

final audioControllerProvider =
    StateNotifierProvider<AudioController, AudioState>((ref) {
      return AudioController();
    });

class AudioState {
  final bool isPlaying;
  final String? currentUrl;
  final String? currentTrackId;
  final double progress;
  final Duration totalDuration;
  final Duration currentPosition;

  AudioState({
    this.isPlaying = false,
    this.currentUrl,
    this.currentTrackId,
    this.progress = 0.0,
    this.totalDuration = Duration.zero,
    this.currentPosition = Duration.zero,
  });

  AudioState copyWith({
    bool? isPlaying,
    String? currentUrl,
    String? currentTrackId,
    double? progress,
    Duration? totalDuration,
    Duration? currentPosition,
  }) {
    return AudioState(
      isPlaying: isPlaying ?? this.isPlaying,
      currentUrl: currentUrl ?? this.currentUrl,
      currentTrackId: currentTrackId ?? this.currentTrackId,
      progress: progress ?? this.progress,
      totalDuration: totalDuration ?? this.totalDuration,
      currentPosition: currentPosition ?? this.currentPosition,
    );
  }
}

class AudioController extends StateNotifier<AudioState> {
  final AudioPlayer _player = AudioPlayer();

  AudioController() : super(AudioState()) {
    _initListeners();
  }

  void _initListeners() {
    _player.playerStateStream.listen((playerState) {
      state = state.copyWith(isPlaying: playerState.playing);
    });

    _player.positionStream.listen((position) {
      final total = state.totalDuration;
      if (total.inMilliseconds > 0) {
        state = state.copyWith(
          currentPosition: position,
          progress: position.inMilliseconds / total.inMilliseconds,
        );
      }
    });

    _player.durationStream.listen((duration) {
      if (duration != null) {
        state = state.copyWith(totalDuration: duration);
      }
    });
  }

  Future<void> toggle(String url, String trackId) async {
    if (state.currentTrackId == trackId) {
      if (state.isPlaying) {
        await _player.pause();
      } else {
        await _player.play();
      }
    } else {
      await _player.stop();
      state = state.copyWith(currentUrl: url, currentTrackId: trackId);

      try {
        await _player.setUrl(url);
        await _player.play();
      } catch (e) {
        print("Error loading audio: $e");
      }
    }
  }

  Future<void> stop() async {
    await _player.stop();
    state = state.copyWith(
      isPlaying: false,
      progress: 0.0,
      currentTrackId: null,
    );
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> play(String url, String trackId) async {
    if (state.currentTrackId == trackId) {
      await _player.play();
    } else {
      await _player.stop();
      state = state.copyWith(currentUrl: url, currentTrackId: trackId);
      try {
        await _player.setUrl(url);
        await _player.play();
      } catch (e) {
        print("Error loading audio: $e");
      }
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}





























