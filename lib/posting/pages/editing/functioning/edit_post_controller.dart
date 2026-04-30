import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../models/media_item.dart';

// ─── Data Models ───────────────────────────────────────────────────────────

class MediaOverlayUI {
  String? imagePath;
  String? text;
  Color? color;
  bool hasBackground;
  Offset position;
  double scale;
  double rotation;

  MediaOverlayUI({
    this.imagePath,
    this.text,
    this.color,
    this.hasBackground = false,
    required this.position,
    this.scale = 1.0,
    this.rotation = 0.0,
  });
}

class MediaEditState {
  final MediaItem item;
  int selectedFilterIndex = 0;
  double brightness = 0.0;
  double contrast = 1.0;
  double saturation = 1.0;
  double rotation = 0.0;
  double volume = 0.8;
  double trimStart = 0.0;
  double trimEnd = 1.0;
  double playbackSpeed = 1.0;
  Rect cropRect = const Rect.fromLTWH(0.1, 0.1, 0.8, 0.8);
  final TransformationController transformationController =
      TransformationController();

  VideoPlayerController? videoController;
  bool isPlaying = false;

  List<MediaOverlayUI> stickers = [];

  MediaEditState(this.item);

  void dispose() {
    transformationController.dispose();
    videoController?.dispose();
  }
}

// ─── Controller ────────────────────────────────────────────────────────────

enum EditFocusMode { none, trim, speed, audioTrim, volumeMixer, text, voiceover }

class EditPostController extends ChangeNotifier {
  final List<MediaItem> selectedMedia;

  late List<MediaEditState> mediaStates;
  int currentPage = 0;
  int currentMode = 0; // 0: Post, 1: Short Video, 2: Live
  bool isCropMode = false;
  EditFocusMode focusMode = EditFocusMode.none;
  
  // Undo/Redo Stack
  List<String> historyStack = [];
  int historyIndex = -1;
  
  // Audio Track State
  MediaItem? backgroundMusic;
  double musicVolume = 0.5;
  double musicTrimStartMs = 0.0;
  double musicTrimEndMs = 0.0;

  final List<String> filters = [
    'normal',
    'clarendon',
    'gingham',
    'moon',
    'lark',
    'reyes',
    'juno',
    'slumber',
  ];

  EditPostController({required this.selectedMedia}) {
    mediaStates = selectedMedia.map((item) => MediaEditState(item)).toList();
  }

  MediaEditState get currentState => mediaStates[currentPage];

  void addMedia(MediaItem item) {
    selectedMedia.add(item);
    mediaStates.add(MediaEditState(item));
    notifyListeners();
  }

  void removeMedia(int index) {
    if (selectedMedia.length > 1) {
      final state = mediaStates[index];
      state.dispose();
      selectedMedia.removeAt(index);
      mediaStates.removeAt(index);
      if (currentPage >= selectedMedia.length) {
        currentPage = selectedMedia.length - 1;
      }
      notifyListeners();
    }
  }

  void setBackgroundMusic(MediaItem item) {
    backgroundMusic = item;
    // Default the trim end to something sensible or leave as 0
    musicTrimEndMs = 30000.0; // Assume 30 second snippet by default
    notifyListeners();
  }

  void setMusicTrim(RangeValues val) {
    musicTrimStartMs = val.start;
    musicTrimEndMs = val.end;
    notifyListeners();
  }

  void setMusicVolume(double val) {
    musicVolume = val;
    notifyListeners();
  }

  // ── Video Initialisation ─────────────────────────────────────────────────

  Future<void> initCurrentPlayer() async {
    final state = mediaStates[currentPage];
    if (state.item.type != MediaType.photo && state.videoController == null) {
      if (state.item.path.startsWith('http')) {
        state.videoController = VideoPlayerController.networkUrl(
          Uri.parse(state.item.path),
        );
      } else {
        state.videoController = VideoPlayerController.file(
          File(state.item.path),
        );
      }
      await state.videoController!.initialize();

      if (state.trimEnd == 1.0 && state.trimStart == 0.0) {
        state.trimEnd =
            state.videoController!.value.duration.inMilliseconds.toDouble();
        if (state.trimEnd <= 0.0) state.trimEnd = 1000.0;
      }

      state.videoController!.addListener(() {
        if (state.isPlaying &&
            state.videoController!.value.position.inMilliseconds >=
                state.trimEnd.toInt() &&
            state.trimEnd > 1.0) {
          state.videoController!.seekTo(
            Duration(milliseconds: state.trimStart.toInt()),
          );
        }
      });

      state.videoController!.setVolume(state.volume);
      notifyListeners();
    }
  }

  // ── Page Change ──────────────────────────────────────────────────────────

  void onPageChanged(int index) {
    if (mediaStates[currentPage].videoController != null) {
      mediaStates[currentPage].videoController!.pause();
      mediaStates[currentPage].isPlaying = false;
    }
    currentPage = index;
    notifyListeners();
    initCurrentPlayer();
  }

  // ── Crop ─────────────────────────────────────────────────────────────────

  void toggleCropMode() {
    isCropMode = !isCropMode;
    notifyListeners();
  }

  void exitCropMode() {
    isCropMode = false;
    notifyListeners();
  }

  void setFocusMode(EditFocusMode mode) {
    focusMode = mode;
    notifyListeners();
  }

  void setPlaybackSpeed(MediaEditState state, double speed) {
    state.playbackSpeed = speed;
    state.videoController?.setPlaybackSpeed(speed);
    notifyListeners();
  }

  void setMode(int index) {
    currentMode = index;
    notifyListeners();
  }

  // ── Undo / Redo ──────────────────────────────────────────────────────────

  void saveStateToHistory() {
    final recipeJson = generateProcessRecipe();
    final jsonString = jsonEncode(recipeJson);
    
    // Clear any future redos if we are branching history here
    if (historyIndex < historyStack.length - 1) {
      historyStack = historyStack.sublist(0, historyIndex + 1);
    }
    
    historyStack.add(jsonString);
    historyIndex++;
    
    // Optional: cap history at 20 steps to save memory
    if (historyStack.length > 20) {
      historyStack.removeAt(0);
      historyIndex--;
    }
    notifyListeners();
  }

  void undo() {
    if (canUndo()) {
      historyIndex--;
      _restoreStateFromRecipe(historyStack[historyIndex]);
    }
  }

  void redo() {
    if (canRedo()) {
      historyIndex++;
      _restoreStateFromRecipe(historyStack[historyIndex]);
    }
  }

  bool canUndo() => historyIndex > 0;
  bool canRedo() => historyIndex < historyStack.length - 1;

  void _restoreStateFromRecipe(String jsonStr) {
    // Deep structural teardown and rebuild from JSON recipe strings.
    // In a fully built NLE, this reconstructs clips, trims, text overlays, and audio levels visually.
    jsonDecode(jsonStr); // Validate JSON format
    
    // Placeholder for actual complex state reconstruction logic 
    // e.g. parsing recipe['base_track'] and reconstructing mediaStates
    
    notifyListeners();
  }

  // ── Playback & Global Scrubbing ──────────────────────────────────────────

  void togglePlayback(MediaEditState state) {
    if (state.isPlaying) {
      state.isPlaying = false;
      state.videoController?.pause();
      notifyListeners();
      return;
    }

    // Playback starting
    state.isPlaying = true;
    notifyListeners();

    if (state.item.type != MediaType.photo && state.videoController?.value.isInitialized == true) {
      state.videoController!.play();
      
      // --- Combined Playback: Auto-Advance for Videos ---
      if (currentMode == 1) { // Short Video mode
        state.videoController!.addListener(_globalProgressListener);
      }
    } else if (state.item.type == MediaType.photo) {
      // --- Combined Playback: Auto-Advance for Photos ---
      // We simulate a 3-second playback for combined view
      Future.delayed(const Duration(seconds: 3), () {
        if (state.isPlaying) _onVideoComplete();
      });
    }
  }

  void _globalProgressListener() {
    final state = mediaStates[currentPage];
    if (state.isPlaying && state.videoController != null) {
      if (state.videoController!.value.position >= state.videoController!.value.duration) {
        state.videoController!.removeListener(_globalProgressListener); // clean up
        _onVideoComplete();
      } else {
        notifyListeners(); // Force timeline redraw
      }
    }
  }

  void _onVideoComplete() {
    if (currentMode == 1 && currentPage < selectedMedia.length - 1) {
      // Pause current
      mediaStates[currentPage].videoController?.pause();
      mediaStates[currentPage].isPlaying = false;
      
      // Go to next
      currentPage++;
      notifyListeners();
      
      // Start next
      initCurrentPlayer().then((_) {
        mediaStates[currentPage].videoController?.play();
        mediaStates[currentPage].isPlaying = true;
        // Re-attach listener to new clip
        if (mediaStates[currentPage].item.type != MediaType.photo) {
           mediaStates[currentPage].videoController?.addListener(_globalProgressListener);
        }
        notifyListeners();
      });
    } else if (currentMode == 1) {
      // Reached the end of the entire master timeline. Loop back!
      mediaStates[currentPage].isPlaying = false;
      mediaStates[currentPage].videoController?.pause();
      
      currentPage = 0;
      notifyListeners();
      initCurrentPlayer().then((_) {
        mediaStates[currentPage].videoController?.seekTo(Duration.zero);
        // Do not auto-play, let user hit play, or auto-play. We'll auto-play.
        togglePlayback(mediaStates[currentPage]);
      });
    }
  }

  double getGlobalProgress() {
    if (selectedMedia.isEmpty) return 0.0;
    
    // Each segment is 1 / total items in the combined view
    // A better NLE approach uses actual time, but since images default to 3s,
    // equal segments is a fair temporary visual representation if duration is unknown.
    double segmentRatio = 1.0 / selectedMedia.length;
    double finishedProgress = currentPage * segmentRatio;
    
    final active = currentState.videoController;
    double activeProgress = 0.0;
    if (active != null && active.value.isInitialized && active.value.duration.inMilliseconds > 0) {
      activeProgress = active.value.position.inMilliseconds / 
                       active.value.duration.inMilliseconds;
    }
    
    return (finishedProgress + (activeProgress * segmentRatio)).clamp(0.0, 1.0);
  }

  void seekToGlobalProgress(double ratio) {
    if (selectedMedia.isEmpty) return;
    
    // Pause everywhere instantly
    for (var s in mediaStates) {
      if (s.isPlaying) {
        s.isPlaying = false;
        s.videoController?.pause();
      }
    }
    
    // Find the right clip index
    double segmentRatio = 1.0 / selectedMedia.length;
    int targetIndex = (ratio / segmentRatio).floor().clamp(0, selectedMedia.length - 1);
    
    // Calculate local progress inside that specific clip
    double localProgress = (ratio - (targetIndex * segmentRatio)) / segmentRatio;
    
    currentPage = targetIndex;
    
    initCurrentPlayer().then((_) {
      final active = mediaStates[targetIndex].videoController;
      if (active != null && active.value.isInitialized) {
        final targetMs = active.value.duration.inMilliseconds * localProgress;
        active.seekTo(Duration(milliseconds: targetMs.toInt()));
      }
      notifyListeners();
    });
  }

  // ── Stickers ─────────────────────────────────────────────────────────────

  void addSticker(MediaEditState state, String assetPath) {
    state.stickers.add(
      MediaOverlayUI(imagePath: assetPath, position: const Offset(100, 100)),
    );
    // saveStateToHistory(); // Called separately via Done button usually
    notifyListeners();
  }

  void addTextOverlay(MediaEditState state, String text, Color color, bool hasBg) {
    state.stickers.add(
      MediaOverlayUI(
        text: text,
        color: color,
        hasBackground: hasBg,
        position: const Offset(150, 300), 
      ),
    );
    notifyListeners();
  }

  void moveSticker(MediaOverlayUI sticker, Offset delta) {
    sticker.position += delta;
    notifyListeners();
  }

  // ── Filter / Adjustments ─────────────────────────────────────────────────

  void setFilter(MediaEditState state, int index) {
    state.selectedFilterIndex = index;
    notifyListeners();
  }

  void setBrightness(MediaEditState state, double v) {
    state.brightness = v;
    notifyListeners();
  }

  void setContrast(MediaEditState state, double v) {
    state.contrast = v;
    notifyListeners();
  }

  void setSaturation(MediaEditState state, double v) {
    state.saturation = v;
    notifyListeners();
  }

  // ── Trim ─────────────────────────────────────────────────────────────────

  void setTrimRange(MediaEditState state, RangeValues val) {
    state.trimStart = val.start;
    state.trimEnd = val.end;
    state.videoController?.seekTo(Duration(milliseconds: val.start.toInt()));
    if (!state.isPlaying) {
      state.videoController?.play();
      state.isPlaying = true;
    }
    notifyListeners();
  }

  // ── Volume ───────────────────────────────────────────────────────────────

  void setVolume(MediaEditState state, double v) {
    state.volume = v;
    state.videoController?.setVolume(v);
    notifyListeners();
  }

  // ── Color Filter Math ────────────────────────────────────────────────────

  ColorFilter buildCombinedFilter(MediaEditState state) {
    if (state.item.type == MediaType.audio) {
      return const ColorFilter.mode(Colors.transparent, BlendMode.dst);
    }

    final double b = state.brightness * 255;
    final double c = state.contrast;
    final double s = state.saturation;

    if (state.selectedFilterIndex == 1) {
      return ColorFilter.mode(
        Colors.blue.withValues(alpha: 0.15),
        BlendMode.softLight,
      );
    } else if (state.selectedFilterIndex == 2) {
      return ColorFilter.mode(
        Colors.grey.withValues(alpha: 0.25),
        BlendMode.multiply,
      );
    } else if (state.selectedFilterIndex == 3) {
      return const ColorFilter.matrix([
        0.2126, 0.7152, 0.0722, 0, 0,
        0.2126, 0.7152, 0.0722, 0, 0,
        0.2126, 0.7152, 0.0722, 0, 0,
        0,      0,      0,      1, 0,
      ]);
    }

    const double lumR = 0.213;
    const double lumG = 0.715;
    const double lumB = 0.072;
    final double sr = (1 - s) * lumR;
    final double sg = (1 - s) * lumG;
    final double sb = (1 - s) * lumB;

    return ColorFilter.matrix([
      c * (sr + s), c * sg,       c * sb,       0, b,
      c * sr,       c * (sg + s), c * sb,       0, b,
      c * sr,       c * sg,       c * (sb + s), 0, b,
      0,            0,            0,            1, 0,
    ]);
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  String formatDuration(double totalMilliseconds) {
    int totalSeconds = totalMilliseconds ~/ 1000;
    int min = totalSeconds ~/ 60;
    int sec = totalSeconds % 60;
    return '$min:${sec.toString().padLeft(2, '0')}';
  }

  /// Commits sticker positions back onto each MediaItem before navigation.
  void commitOverlays() {
    for (var state in mediaStates) {
      if (state.stickers.isNotEmpty) {
        state.item.overlays = state.stickers
            .map(
              (s) => MediaOverlay(
                imagePath: s.imagePath,
                x: s.position.dx.toInt(),
                y: s.position.dy.toInt(),
                scale: s.scale,
                rotation: s.rotation,
              ),
            )
            .toList();
      }
    }
  }

  /// NLE Core: Generates the JSON 'Recipe' for the Native C++ Engine
  Map<String, dynamic> generateProcessRecipe() {
    commitOverlays();
    
    double totalDurationMs = 0;
    List<Map<String, dynamic>> baseTrack = [];
    List<Map<String, dynamic>> overlayTrack = [];

    for (var state in mediaStates) {
      double durationMs = 0;
      if (state.item.type == MediaType.video && state.videoController != null) {
        durationMs = state.trimEnd - state.trimStart;
      } else {
        durationMs = 3000.0; // Default 3 sec for images
      }

      baseTrack.add({
        "type": state.item.type == MediaType.video ? "video" : "image",
        "path": state.item.path,
        "start_ms": totalDurationMs,
        "end_ms": totalDurationMs + durationMs,
        if (state.item.type == MediaType.video) "trim_start": state.trimStart,
        if (state.item.type == MediaType.video) "trim_end": state.trimEnd,
        "speed": state.playbackSpeed,
        "volume": state.volume,
        "brightness": state.brightness,
        "contrast": state.contrast,
        "saturation": state.saturation,
        "filter_index": state.selectedFilterIndex,
      });

      for (var sticker in state.stickers) {
        overlayTrack.add({
          "type": sticker.text != null ? "text" : "image",
          "content": sticker.text ?? sticker.imagePath,
          if (sticker.text != null && sticker.color != null) "color_hex": sticker.color!.value.toRadixString(16),
          if (sticker.text != null) "has_bg": sticker.hasBackground,
          "start_ms": totalDurationMs,
          "end_ms": totalDurationMs + durationMs,
          "x": sticker.position.dx.toInt(),
          "y": sticker.position.dy.toInt(),
          "scale": sticker.scale,
          "rotation": sticker.rotation,
        });
      }

      totalDurationMs += durationMs;
    }

    // Connect transitions for adjacent video/photo clips smoothly 
    if (baseTrack.length > 1) {
      for (int i = 0; i < baseTrack.length - 1; i++) {
        baseTrack[i]["transition"] = "crossfade";
        baseTrack[i]["transition_duration_ms"] = 500;
      }
    }

    Map<String, dynamic> recipe = {
      "total_duration_ms": totalDurationMs,
      "base_track": baseTrack,
      "overlay_track": overlayTrack,
      "voiceover_track": [], // Scaffolded array ready for Mode.Voiceover recordings
    };

    if (backgroundMusic != null) {
      recipe["audio_track"] = {
        "path": backgroundMusic!.path,
        "trim_start_ms": musicTrimStartMs,
        "trim_end_ms": musicTrimEndMs > 0 ? musicTrimEndMs : totalDurationMs,
        "volume": musicVolume,
      };
    }

    return recipe;
  }

  @override
  void dispose() {
    for (var state in mediaStates) {
      state.dispose();
    }
    super.dispose();
  }
}
