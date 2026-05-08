import 'dart:io';
import 'package:crimchart/features/channel/pages/messages_tab/widgets/emoji_picker_panel.dart';
import 'package:crimchart/posting/models/media_item.dart';
import 'package:crimchart/posting/pages/editing/functioning/edit_post_controller.dart';
import 'package:crimchart/posting/pages/editing/functioning/media_baking_service.dart';
import 'package:crimchart/posting/pages/editing/widgets/edit_media_preview.dart';
import 'package:flutter/material.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:lucide_icons/lucide_icons.dart';

// ─── Tool modes ───────────────────────────────────────────────────────────────
enum _EditorTool { none, draw, text, emoji }

class MediaCaptionBottomSheet extends StatefulWidget {
  final List<Map<String, String>> items;
  final Function(String caption, List<Map<String, String>> items) onSend;

  const MediaCaptionBottomSheet({
    super.key,
    required this.items,
    required this.onSend,
  });

  static void show(
    BuildContext context, {
    required List<Map<String, String>> items,
    required Function(String caption, List<Map<String, String>> items) onSend,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      useSafeArea: true,
      // Prevent accidental swipe-down dismissal
      isDismissible: false,
      enableDrag: false,
      builder: (_) => MediaCaptionBottomSheet(items: items, onSend: onSend),
    );
  }

  @override
  State<MediaCaptionBottomSheet> createState() =>
      _MediaCaptionBottomSheetState();
}

class _MediaCaptionBottomSheetState extends State<MediaCaptionBottomSheet> {
  final TextEditingController _captionController = TextEditingController();
  late EditPostController _editController;
  late PageController _pageController;
  int _currentIndex = 0;
  _EditorTool _activeTool = _EditorTool.none;

  // ── Drawing palette ───────────────────────────────────────────────────────
  static const _drawColors = [
    Colors.white,
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.cyan,
    Colors.blue,
    Colors.pink,
    Colors.orange,
    Colors.black,
  ];
  int _drawColorIndex = 0;
  double _drawStrokeWidth = 5.0;

  // ── Text palette ──────────────────────────────────────────────────────────
  static const _textColors = [
    Colors.white,
    Colors.yellow,
    Colors.black,
    Colors.red,
    Colors.cyan,
    Colors.green,
    Colors.orange,
    Colors.pink,
  ];
  int _textColorIndex = 0;
  bool _textHasBg = true;

  final List<String> _appFonts = [
    'monospace',
    'Comic Relief',
    'Archivo Black',
    'Inter',
    'Playfair Display',
    'Roboto Condensed',
  ];

  @override
  void initState() {
    super.initState();
    final mediaItems = widget.items
        .map(
          (item) => MediaItem(
            path: item['url']!,
            type: item['type'] == 'video' ? MediaType.video : MediaType.photo,
            source: MediaSource.device,
          ),
        )
        .toList();

    _editController = EditPostController(selectedMedia: mediaItems);
    _pageController = PageController();
    _editController.addListener(_onUpdate);
    _editController.initCurrentPlayer();
  }

  void _onUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _editController.removeListener(_onUpdate);
    _editController.dispose();
    _captionController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  void _toggleTool(_EditorTool tool) {
    setState(() {
      _activeTool = _activeTool == tool ? _EditorTool.none : tool;
      if (_activeTool != _EditorTool.none && _editController.isCropMode) {
        _editController.exitCropMode();
      }
    });
    // Sync drawing color to controller
    _editController.currentState.currentDrawingColor =
        _drawColors[_drawColorIndex];
    _editController.currentState.drawingStrokeWidth = _drawStrokeWidth;
  }

  void _openTextDialog({MediaOverlayUI? existingSticker}) {
    if (_editController.isCropMode) _editController.exitCropMode();
    _activeTool = _EditorTool.text;
    final tc = TextEditingController(text: existingSticker?.text ?? '');

    // If editing, try to match the color/bg state
    if (existingSticker != null) {
      _textColorIndex = _textColors.indexOf(
        existingSticker.color ?? Colors.white,
      );
      if (_textColorIndex == -1) _textColorIndex = 0;
      _textHasBg = existingSticker.hasBackground;
    }

    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (ctx) => _TextInputDialog(
        controller: tc,
        selectedColorIndex: _textColorIndex,
        colors: _textColors,
        hasBg: _textHasBg,
        onColorChanged: (i) => setState(() => _textColorIndex = i),
        onHasBgChanged: (v) => setState(() => _textHasBg = v),
        onDone: () {
          final txt = tc.text.trim();
          if (txt.isNotEmpty) {
            if (existingSticker != null) {
              setState(() {
                existingSticker.text = txt;
                existingSticker.color = _textColors[_textColorIndex];
                existingSticker.hasBackground = _textHasBg;
              });
            } else {
              _editController.addTextOverlay(
                _editController.currentState,
                txt,
                _textColors[_textColorIndex],
                _textHasBg,
                fontFamily: _appFonts[0],
              );
            }
          }
          setState(() => _activeTool = _EditorTool.none);
          Navigator.pop(ctx);
        },
        onCancel: () {
          setState(() => _activeTool = _EditorTool.none);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _openTextAdjustSheet(MediaOverlayUI sticker) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _TextAdjustSheet(
        sticker: sticker,
        fonts: _appFonts,
        colors: _textColors,
        onUpdate: () => setState(() {}),
        onEditText: () {
          Navigator.pop(ctx);
          _openTextDialog(existingSticker: sticker);
        },
      ),
    );
  }

  void _onEmojiSelected(String emoji) {
    if (_editController.isCropMode) _editController.exitCropMode();
    // Pass null color + no background → routes to _EmojiOverlay (48px crisp emoji)
    _editController.currentState.stickers.add(
      MediaOverlayUI(
        text: emoji,
        color: null,
        hasBackground: false,
        position: Offset(
          80 + (_editController.currentState.stickers.length * 20) % 120,
          100 + (_editController.currentState.stickers.length * 20) % 80,
        ),
      ),
    );
    setState(() {
      _activeTool = _EditorTool.none;
    });
  }

  bool _isBaking = false;
  String _bakeStage = '';
  bool _isPreviewingBaked = false;

  bool get _requiresBaking {
    for (var state in _editController.mediaStates) {
      if (state.stickers.isNotEmpty ||
          state.drawingPaths.isNotEmpty ||
          state.cropRect != const Rect.fromLTWH(0.1, 0.1, 0.8, 0.8) ||
          state.rotation != 0.0 ||
          state.brightness != 0.0 ||
          state.contrast != 1.0 ||
          state.saturation != 1.0) {
        return true;
      }
    }
    return false;
  }

  Future<void> _sendMedia() async {
    if (_isBaking) return;

    // 1. If already baked or no edits exist, just send to the channel!
    if (!_requiresBaking || _isPreviewingBaked) {
      widget.onSend(
        _captionController.text.trim(),
        _editController.selectedMedia
            .map(
              (m) => {
                'url': m.path,
                'type': m.type == MediaType.video ? 'video' : 'photo',
              },
            )
            .toList(),
      );
      Navigator.pop(context);
      return;
    }

    // 2. Otherwise, bake the edits and show the preview
    setState(() {
      _isBaking = true;
      _bakeStage = 'Preparing…';
    });

    try {
      final results = await MediaBakingService().bakeAll(
        _editController,
        onProgress: (p) {
          if (mounted) setState(() => _bakeStage = p.stage);
        },
      );

      final bakedItems = results.asMap().entries.map((entry) {
        final original = _editController.selectedMedia[entry.key];
        return original.withPath(
          entry.value.success ? entry.value.outputPath : original.path,
        );
      }).toList();

      // Replace the active media with the baked ones so the user sees the final output
      _editController.replaceWithBaked(bakedItems);

      if (mounted) {
        setState(() {
          _isPreviewingBaked = true;
        });
      }
    } catch (e) {
      debugPrint('⚠️ [Bake] Pipeline error: $e');
      // If it fails, fallback to sending originals
      if (mounted) {
        widget.onSend(
          _captionController.text.trim(),
          _editController.selectedMedia
              .map(
                (m) => {
                  'url': m.path,
                  'type': m.type == MediaType.video ? 'video' : 'photo',
                },
              )
              .toList(),
        );
        Navigator.pop(context);
      }
    } finally {
      if (mounted) setState(() => _isBaking = false);
    }
  }

  // ── Edit guard ────────────────────────────────────────────────────────────

  bool get _hasEdits {
    return _requiresBaking || _captionController.text.trim().isNotEmpty;
  }

  Future<void> _confirmDiscard() async {
    if (!_hasEdits) {
      Navigator.pop(context);
      return;
    }
    final discard = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black87,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Discard edits?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          'Your drawings, stickers, and caption will be lost.',
          style: TextStyle(color: Colors.white60, fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Keep Editing',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14.sp,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Discard',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w700,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
    if ((discard ?? false) && mounted) Navigator.pop(context);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDrawing = _activeTool == _EditorTool.draw;
    final isEmoji = _activeTool == _EditorTool.emoji;

    return PopScope(
      // Intercept Android back button — always ask before discarding
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmDiscard();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // ── Full-screen media preview ──────────────────────────────────────
            Positioned.fill(
              child: EditMediaPreview(
                selectedMedia: _editController.selectedMedia,
                mediaStates: _editController.mediaStates,
                currentPage: _currentIndex,
                pageController: _pageController,
                isCropMode: _editController.isCropMode,
                isDrawingMode: isDrawing,
                buildFilter: _editController.buildCombinedFilter,
                onPageChanged: (i) {
                  setState(() => _currentIndex = i);
                  _editController.onPageChanged(i);
                },
                onTogglePlay: (s) => _editController.togglePlayback(s),
                onMoveSticker: (s, sticker, d, size) => _editController
                    .moveSticker(sticker, d, containerSize: size),
                onAdjustSticker: (sticker) => _openTextAdjustSheet(sticker),
                onRemoveSticker: (sticker) =>
                    _editController.removeSticker(sticker),
                onToggleCrop: () => _editController.toggleCropMode(),
                onRemoveItem: (i) => _editController.removeMedia(i),
                onStartDrawing: (s, p) {
                  s.currentDrawingColor = _drawColors[_drawColorIndex];
                  s.drawingStrokeWidth = _drawStrokeWidth;
                  _editController.startDrawingPath(s, p);
                },
                onUpdateDrawing: (s, p) =>
                    _editController.updateDrawingPath(s, p),
              ),
            ),

            // ── Top toolbar ────────────────────────────────────────────────────
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _TopBar(
                activeTool: _activeTool,
                isCropMode: _editController.isCropMode,
                onClose: _confirmDiscard,
                onCrop: () => setState(() {
                  _activeTool = _EditorTool.none;
                  _editController.toggleCropMode();
                }),
                onText: _openTextDialog,
                onDraw: () => _toggleTool(_EditorTool.draw),
                onEmoji: () => _toggleTool(_EditorTool.emoji),
                onUndo: () {
                  if (_activeTool == _EditorTool.draw &&
                      _editController.currentState.drawingPaths.isNotEmpty) {
                    _editController.currentState.drawingPaths.removeLast();
                    setState(() {});
                  } else {
                    _editController.undo();
                  }
                },
                onRotate: () => _editController.rotateCurrentMedia(),
              ),
            ),

            // ── Drawing toolbar (shows when draw tool is active) ───────────────
            if (isDrawing)
              Positioned(
                top: kToolbarHeight + MediaQuery.of(context).padding.top + 8.h,
                left: 12.w,
                right: 12.w,
                child: _DrawToolbar(
                  colors: _drawColors,
                  selectedIndex: _drawColorIndex,
                  strokeWidth: _drawStrokeWidth,
                  onColorChanged: (i) => setState(() => _drawColorIndex = i),
                  onStrokeChanged: (v) => setState(() => _drawStrokeWidth = v),
                ),
              ),

            // ── Emoji picker panel (slides from bottom) ────────────────────────
            if (isEmoji)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: EmojiPickerPanel(onEmojiSelected: _onEmojiSelected),
              ),

            // ── Bottom: thumbnails + caption + send ───────────────────────────
            if (!isEmoji)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _BottomSection(
                  editController: _editController,
                  captionController: _captionController,
                  currentIndex: _currentIndex,
                  pageController: _pageController,
                  theme: theme,
                  onSend: _sendMedia,
                  onThumbnailTap: (i) => _pageController.animateToPage(
                    i,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                  ),
                ),
              ),

            // ── Baking Progress Overlay ────────────────────────────────────────
            if (_isBaking)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        _bakeStage,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Top Bar ──────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final _EditorTool activeTool;
  final bool isCropMode;
  final VoidCallback onClose;
  final VoidCallback onCrop;
  final VoidCallback onText;
  final VoidCallback onDraw;
  final VoidCallback onEmoji;
  final VoidCallback onUndo;
  final VoidCallback onRotate;

  const _TopBar({
    required this.activeTool,
    required this.isCropMode,
    required this.onClose,
    required this.onCrop,
    required this.onText,
    required this.onDraw,
    required this.onEmoji,
    required this.onUndo,
    required this.onRotate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: isCropMode
              ? Row(
                  children: [
                    _TextBtn(label: 'Cancel', onTap: onCrop),
                    const Spacer(),
                    GestureDetector(
                      onTap: onRotate,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.rotateCcw,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Rotate',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    _TextBtn(label: 'Done', onTap: onCrop, primary: true),
                  ],
                )
              : Row(
                  children: [
                    _IconBtn(icon: Icons.close, onTap: onClose),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _ToolBtn(
                              icon: LucideIcons.crop,
                              active: false,
                              label: 'Crop',
                              onTap: onCrop,
                            ),
                            SizedBox(width: 8.w),
                            _ToolBtn(
                              icon: LucideIcons.type,
                              active: activeTool == _EditorTool.text,
                              label: 'Text',
                              onTap: onText,
                            ),
                            SizedBox(width: 8.w),
                            _ToolBtn(
                              icon: LucideIcons.pencil,
                              active: activeTool == _EditorTool.draw,
                              label: 'Draw',
                              onTap: onDraw,
                            ),
                            SizedBox(width: 8.w),
                            _ToolBtn(
                              icon: LucideIcons.smile,
                              active: activeTool == _EditorTool.emoji,
                              label: 'Emoji',
                              onTap: onEmoji,
                            ),
                          ],
                        ),
                      ),
                    ),
                    _IconBtn(icon: LucideIcons.cornerUpLeft, onTap: onUndo),
                  ],
                ),
        ),
      ),
    );
  }
}

class _ToolBtn extends StatelessWidget {
  final IconData icon;
  final bool active;
  final String label;
  final VoidCallback onTap;

  const _ToolBtn({
    required this.icon,
    required this.active,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: active ? Colors.black : Colors.white,
            ),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: active ? Colors.black : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool primary;

  const _TextBtn({
    required this.label,
    required this.onTap,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: primary ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border: primary ? null : Border.all(color: Colors.white24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: primary ? Colors.black : Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20.sp),
      ),
    );
  }
}

// ─── Draw Toolbar ─────────────────────────────────────────────────────────────

class _DrawToolbar extends StatelessWidget {
  final List<Color> colors;
  final int selectedIndex;
  final double strokeWidth;
  final void Function(int) onColorChanged;
  final void Function(double) onStrokeChanged;

  const _DrawToolbar({
    required this.colors,
    required this.selectedIndex,
    required this.strokeWidth,
    required this.onColorChanged,
    required this.onStrokeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Color swatches
          Row(
            children: List.generate(colors.length, (i) {
              final selected = i == selectedIndex;
              return GestureDetector(
                onTap: () => onColorChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: EdgeInsets.only(right: 8.w),
                  width: selected ? 32.w : 26.w,
                  height: selected ? 32.w : 26.w,
                  decoration: BoxDecoration(
                    color: colors[i],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? Colors.white : Colors.white38,
                      width: selected ? 2.5 : 1,
                    ),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: colors[i].withValues(alpha: 0.6),
                              blurRadius: 8,
                            ),
                          ]
                        : [],
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 8.h),
          // Stroke width slider
          Row(
            children: [
              Icon(LucideIcons.minus, color: Colors.white54, size: 14.sp),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.r),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 16.r),
                    trackHeight: 3,
                    activeTrackColor: colors[selectedIndex],
                    inactiveTrackColor: Colors.white24,
                    thumbColor: Colors.white,
                  ),
                  child: Slider(
                    value: strokeWidth,
                    min: 2,
                    max: 20,
                    onChanged: onStrokeChanged,
                  ),
                ),
              ),
              Icon(LucideIcons.plus, color: Colors.white54, size: 14.sp),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Text Input Dialog ────────────────────────────────────────────────────────

class _TextInputDialog extends StatelessWidget {
  final TextEditingController controller;
  final int selectedColorIndex;
  final List<Color> colors;
  final bool hasBg;
  final void Function(int) onColorChanged;
  final void Function(bool) onHasBgChanged;
  final VoidCallback onDone;
  final VoidCallback onCancel;

  const _TextInputDialog({
    required this.controller,
    required this.selectedColorIndex,
    required this.colors,
    required this.hasBg,
    required this.onColorChanged,
    required this.onHasBgChanged,
    required this.onDone,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 80.h),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.white12),
        ),
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Text',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 16.h),

            // Text field with live color preview
            StatefulBuilder(
              builder: (ctx, setLocal) {
                return Container(
                  decoration: BoxDecoration(
                    color: hasBg
                        ? colors[selectedColorIndex]
                        : Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: TextField(
                    controller: controller,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: hasBg
                          ? (colors[selectedColorIndex].computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white)
                          : colors[selectedColorIndex],
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      shadows: hasBg
                          ? []
                          : [
                              const Shadow(blurRadius: 4, color: Colors.black),
                              const Shadow(blurRadius: 8, color: Colors.black),
                            ],
                    ),
                    maxLines: 4,
                    minLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Type here...',
                      hintStyle: TextStyle(
                        color: Colors.white38,
                        fontSize: 18.sp,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      border: InputBorder.none,
                    ),
                    onChanged: (_) => setLocal(() {}),
                  ),
                );
              },
            ),
            SizedBox(height: 14.h),

            // Color row + bg toggle
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(colors.length, (i) {
                        final sel = i == selectedColorIndex;
                        return GestureDetector(
                          onTap: () => onColorChanged(i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 140),
                            margin: EdgeInsets.only(right: 8.w),
                            width: sel ? 32.w : 26.w,
                            height: sel ? 32.w : 26.w,
                            decoration: BoxDecoration(
                              color: colors[i],
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: sel ? Colors.white : Colors.white38,
                                width: sel ? 2.5 : 1,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () => onHasBgChanged(!hasBg),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: hasBg ? Colors.white : Colors.white12,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.white38),
                    ),
                    child: Text(
                      'BG',
                      style: TextStyle(
                        color: hasBg ? Colors.black : Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.h),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onCancel,
                    child: Container(
                      height: 44.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: GestureDetector(
                    onTap: onDone,
                    child: Container(
                      height: 44.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Bottom section ───────────────────────────────────────────────────────────

class _BottomSection extends StatelessWidget {
  final EditPostController editController;
  final TextEditingController captionController;
  final int currentIndex;
  final PageController pageController;
  final ThemeData theme;
  final VoidCallback onSend;
  final void Function(int) onThumbnailTap;

  const _BottomSection({
    required this.editController,
    required this.captionController,
    required this.currentIndex,
    required this.pageController,
    required this.theme,
    required this.onSend,
    required this.onThumbnailTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black.withValues(alpha: 0.85), Colors.transparent],
          stops: const [0, 1],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Thumbnails strip
            if (editController.selectedMedia.length > 1)
              SizedBox(
                height: 60.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 4.h,
                  ),
                  itemCount: editController.selectedMedia.length,
                  itemBuilder: (_, i) {
                    final item = editController.selectedMedia[i];
                    final sel = i == currentIndex;
                    return GestureDetector(
                      onTap: () => onThumbnailTap(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: EdgeInsets.only(right: 8.w),
                        width: sel ? 56.h : 48.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: sel ? Colors.white : Colors.white38,
                            width: sel ? 2.5 : 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.r),
                          child: Image.file(File(item.path), fit: BoxFit.cover),
                        ),
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 8.h),
            // Caption bar
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(28.r),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: TextField(
                        controller: captionController,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 3,
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Add a caption...',
                          hintStyle: TextStyle(
                            color: Colors.white54,
                            fontSize: 14.sp,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: onSend,
                    child: Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: theme.primaryColor.withValues(alpha: 0.4),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Icon(
                        LucideIcons.send,
                        color: Colors.black,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextAdjustSheet extends StatelessWidget {
  final MediaOverlayUI sticker;
  final List<String> fonts;
  final List<Color> colors;
  final VoidCallback onUpdate;
  final VoidCallback onEditText;

  const _TextAdjustSheet({
    required this.sticker,
    required this.fonts,
    required this.colors,
    required this.onUpdate,
    required this.onEditText,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEmoji = sticker.color == null;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1C1B),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 20),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                isEmoji ? 'Adjust Emoji' : 'Adjust Text',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (!isEmoji)
                IconButton(
                  onPressed: onEditText,
                  icon: const Icon(LucideIcons.type, color: Colors.white),
                ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Size',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          Slider(
            value: sticker.scale,
            min: 0.5,
            max: 5.0,
            activeColor: Theme.of(context).primaryColor,
            onChanged: (v) {
              sticker.scale = v;
              onUpdate();
            },
          ),
          if (!isEmoji) ...[
            const SizedBox(height: 16),
            const Text(
              'Fonts',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: fonts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (ctx, i) {
                  final f = fonts[i];
                  final isSelected =
                      sticker.fontFamily == f ||
                      (sticker.fontFamily == null && f == 'monospace');
                  return GestureDetector(
                    onTap: () {
                      sticker.fontFamily = f;
                      onUpdate();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.white10,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        f,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white,
                          fontFamily: f,
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Colors',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    sticker.hasBackground = !sticker.hasBackground;
                    onUpdate();
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: sticker.hasBackground
                          ? Colors.white
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      LucideIcons.atSign,
                      size: 18,
                      color: sticker.hasBackground
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: colors.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (ctx, i) {
                        final c = colors[i];
                        final isSelected = sticker.color == c;
                        return GestureDetector(
                          onTap: () {
                            sticker.color = c;
                            onUpdate();
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(color: Colors.white, width: 2.5)
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
