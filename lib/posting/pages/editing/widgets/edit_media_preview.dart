import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:video_player/video_player.dart';
import '../../../models/media_item.dart';
import '../functioning/edit_post_controller.dart';
import 'crop_grid_overlay.dart';

/// Full-screen swipeable media preview layer (photo / video / audio).
class EditMediaPreview extends StatelessWidget {
  final List<MediaItem> selectedMedia;
  final List<MediaEditState> mediaStates;
  final int currentPage;
  final PageController pageController;
  final bool isCropMode;
  final ColorFilter Function(MediaEditState) buildFilter;
  final void Function(int) onPageChanged;
  final void Function(MediaEditState) onTogglePlay;
  final void Function(MediaEditState, MediaOverlayUI, Offset) onMoveSticker;
  final VoidCallback onToggleCrop;
  final void Function(int) onRemoveItem;

  const EditMediaPreview({
    super.key,
    required this.selectedMedia,
    required this.mediaStates,
    required this.currentPage,
    required this.pageController,
    required this.isCropMode,
    required this.buildFilter,
    required this.onPageChanged,
    required this.onTogglePlay,
    required this.onMoveSticker,
    required this.onToggleCrop,
    required this.onRemoveItem,
  });

  // ── Helpers ────────────────────────────────────────────────────────────────

  ImageProvider _imgProvider(MediaItem item) {
    if (item.path.startsWith('http')) return CachedNetworkImageProvider(item.path);
    if (item.thumbnailBytes != null) return MemoryImage(item.thumbnailBytes!);
    if (item.type == MediaType.photo) return FileImage(File(item.path));
    return const AssetImage('assets/icons/playstore.png');
  }

  Widget _mediaImage(MediaItem item, {BoxFit fit = BoxFit.cover}) {
    if (item.path.startsWith('http')) {
      return CachedNetworkImage(imageUrl: item.path, fit: fit);
    }
    if (item.thumbnailBytes != null) {
      return Image.memory(item.thumbnailBytes!, fit: fit);
    }
    if (item.type == MediaType.photo) {
      return Image.file(File(item.path), fit: fit);
    }
    return Container(
      color: Colors.black12,
      child: const Center(
        child: Icon(LucideIcons.music, size: 40, color: Colors.white54),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemCount: selectedMedia.length,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        final state = mediaStates[index];
        if (state.item.type == MediaType.audio) {
          return _AudioPreview(state: state, imgProvider: _imgProvider(state.item));
        }
        return _MediaFrame(
          state: state,
          index: index,
          currentPage: currentPage,
          isCropMode: isCropMode,
          colorFilter: buildFilter(state),
          mediaImage: _mediaImage(state.item, fit: BoxFit.cover),
          onTogglePlay: () => onTogglePlay(state),
          onMoveSticker: (s, d) => onMoveSticker(state, s, d),
          onToggleCrop: onToggleCrop,
          onRemove: () => onRemoveItem(index),
        );
      },
    );
  }
}

// ── Audio-only preview ────────────────────────────────────────────────────────

class _AudioPreview extends StatelessWidget {
  final MediaEditState state;
  final ImageProvider imgProvider;

  const _AudioPreview({required this.state, required this.imgProvider});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: Colors.black.withValues(alpha: 0.05),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
                image: DecorationImage(image: imgProvider, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              state.item.title ?? 'Audio Title',
              style: TextStyle(
                color: cs.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              state.item.artist ?? 'Artist',
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.5),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Photo / Video frame ───────────────────────────────────────────────────────

class _MediaFrame extends StatefulWidget {
  final MediaEditState state;
  final int index;
  final int currentPage;
  final bool isCropMode;
  final ColorFilter colorFilter;
  final Widget mediaImage;
  final VoidCallback onTogglePlay;
  final void Function(MediaOverlayUI, Offset) onMoveSticker;
  final VoidCallback onToggleCrop;
  final VoidCallback onRemove;

  const _MediaFrame({
    required this.state,
    required this.index,
    required this.currentPage,
    required this.isCropMode,
    required this.colorFilter,
    required this.mediaImage,
    required this.onTogglePlay,
    required this.onMoveSticker,
    required this.onToggleCrop,
    required this.onRemove,
  });

  @override
  State<_MediaFrame> createState() => _MediaFrameState();
}

class _MediaFrameState extends State<_MediaFrame> {
  double _dragY = 0;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final isContentActive = !widget.isCropMode && widget.currentPage == widget.index;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // ── Filtered / pannable media content ──────────────────────────
            Transform.translate(
              offset: Offset(0, _dragY),
              child: Opacity(
                opacity: (1.0 - (_dragY.abs() / 400)).clamp(0.0, 1.0),
                child: ColorFiltered(
                  colorFilter: widget.colorFilter,
                  child: InteractiveViewer(
                    transformationController: widget.state.transformationController,
                    clipBehavior: Clip.none,
                    minScale: 1.0,
                    maxScale: 6.0,
                    panEnabled: !widget.isCropMode,
                    scaleEnabled: !widget.isCropMode,
                    child: Transform.rotate(
                      angle: widget.state.rotation * (3.1415 / 180),
                      child: SizedBox.expand(
                        child: widget.state.item.type == MediaType.video &&
                                widget.state.videoController?.value.isInitialized == true
                            ? FittedBox(
                                fit: BoxFit.cover,
                                child: SizedBox(
                                  width: widget.state.videoController!.value.size.width,
                                  height: widget.state.videoController!.value.size.height,
                                  child: VideoPlayer(widget.state.videoController!),
                                ),
                              )
                            : widget.mediaImage,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Crop grid overlay ───────────────────────────────────────────
            if (widget.isCropMode)
              CropGridOverlay(
                initialRect: widget.state.cropRect,
                onChanged: (rect) => widget.state.cropRect = rect,
              ),

            // ── Draggable stickers ──────────────────────────────────────────
            ...widget.state.stickers.map((sticker) {
              return Positioned(
                left: sticker.position.dx,
                top: sticker.position.dy,
                child: GestureDetector(
                  onPanUpdate: (d) => widget.onMoveSticker(sticker, d.delta),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: sticker.text != null
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: sticker.hasBackground ? sticker.color : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              sticker.text!,
                              style: TextStyle(
                                color: sticker.hasBackground ? Colors.white : sticker.color,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : Image.asset(sticker.imagePath!, width: 100, height: 100),
                  ),
                ),
              );
            }),

            // ── Main Tap-to-Play and Long-Press Slide-up Deletion Target ────────────────
            if (isContentActive)
              GestureDetector(
                onTap: widget.onTogglePlay,
                onLongPressStart: (_) => setState(() => _isDragging = true),
                onLongPressMoveUpdate: (d) {
                  if (_isDragging) {
                    setState(() => _dragY = d.localOffsetFromOrigin.dy);
                  }
                },
                onLongPressEnd: (d) {
                  if (_isDragging) {
                    if (_dragY < -150) {
                      widget.onRemove();
                    }
                    setState(() {
                      _dragY = 0;
                      _isDragging = false;
                    });
                  }
                },
                child: SizedBox.expand(
                  child: Container(color: Colors.transparent),
                ),
              ),

            // ── Play/Pause Toggle Overlay (Widget 3) ───────────────────────
            if (isContentActive)
              IgnorePointer(
                child: Center(
                  child: AnimatedOpacity(
                    opacity: widget.state.isPlaying ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 250),
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.state.isPlaying ? LucideIcons.pause : LucideIcons.play,
                        color: Colors.white,
                        size: 58,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
