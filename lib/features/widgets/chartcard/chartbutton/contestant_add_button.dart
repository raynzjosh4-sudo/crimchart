import 'package:crimchart/core/theme/theme_provider.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'bubble_overlay.dart';

class ContestantAddButton extends StatefulWidget {
  final Color cardColor;
  final int? buttonIndex;
  final ValueNotifier<int?>? selectedIndexNotifier;
  final IconData icon;
  final IconData? selectedIcon;
  final bool showBubble;
  final VoidCallback? onTap;

  const ContestantAddButton({
    super.key,
    required this.cardColor,
    this.buttonIndex,
    this.selectedIndexNotifier,
    this.icon = LucideIcons.plus,
    this.selectedIcon = LucideIcons.check,
    this.showBubble = true,
    this.onTap,
  });

  @override
  State<ContestantAddButton> createState() => ContestantAddButtonState();
}

class ContestantAddButtonState extends State<ContestantAddButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  final GlobalKey _buttonKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.8,
      upperBound: 1.0,
    )..value = 1.0;
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void handleTap() {
    if (widget.onTap != null) {
      widget.onTap!();
      _scaleController.reverse().then((_) => _scaleController.forward());
      return;
    }

    if (widget.selectedIndexNotifier == null || widget.buttonIndex == null) {
      // Fallback if not using single selection
      _scaleController.reverse().then((_) => _scaleController.forward());
      context.read<ThemeProvider>().updateColor(widget.cardColor);
      if (widget.showBubble) _showBubbleOverlay();
      return;
    }

    final isSelected =
        widget.selectedIndexNotifier!.value == widget.buttonIndex;

    // Button shrink animation
    _scaleController.reverse().then((_) {
      _scaleController.forward();

      if (isSelected) {
        // Deselect
        widget.selectedIndexNotifier!.value = null;
      } else {
        // Select this one (and only this one)
        widget.selectedIndexNotifier!.value = widget.buttonIndex;

        // Update global theme color only on selection
        context.read<ThemeProvider>().updateColor(widget.cardColor);
        // Trigger expanding bubble overlay
        if (widget.showBubble) _showBubbleOverlay();
      }
    });
  }

  void _showBubbleOverlay() {
    final RenderBox renderBox =
        _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final Offset buttonPosition = renderBox.localToGlobal(Offset.zero);
    final Size buttonSize = renderBox.size;
    final Offset centerPosition = Offset(
      buttonPosition.dx + buttonSize.width / 2,
      buttonPosition.dy + buttonSize.height / 2,
    );

    _overlayEntry = OverlayEntry(
      builder: (context) => BubbleOverlay(
        position: centerPosition,
        color: widget.cardColor,
        onCompleted: () {
          _overlayEntry?.remove();
          _overlayEntry = null;
        },
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedIndexNotifier == null || widget.buttonIndex == null) {
      return _buildStaticButton(false);
    }

    return ValueListenableBuilder<int?>(
      valueListenable: widget.selectedIndexNotifier!,
      builder: (context, selectedIndex, _) {
        final isSelected = selectedIndex == widget.buttonIndex;
        return _buildStaticButton(isSelected);
      },
    );
  }

  Widget _buildStaticButton(bool isSelected) {
    return AnimatedBuilder(
      animation: _scaleController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleController.value,
          child: Container(
            key: _buttonKey,
            decoration: BoxDecoration(
              color: isSelected
                  ? widget.cardColor
                  : Theme.of(context).colorScheme.surface,
              shape: BoxShape.circle,
              // User previously said they hate borders, so I'll omit it here for a cleaner look
            ),
            padding: EdgeInsets.all(4.w),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: handleTap,
                customBorder: const CircleBorder(),
                child: Padding(
                  padding: EdgeInsets.all(4.0.w),
                  child: Icon(
                    isSelected && widget.selectedIcon != null
                        ? widget.selectedIcon
                        : widget.icon,
                    size: 18.sp,
                    color: isSelected
                        ? Theme.of(context).colorScheme.surface
                        : widget.cardColor,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}











