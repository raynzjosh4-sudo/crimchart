import 'package:crimchart/backicon/custom_back_button.dart';
import 'package:crimchart/core/widgets/chart_linear_loader.dart';
import 'package:flutter/material.dart';

/// A reusable premium Instagram-style AppBar for the Chart app.
/// - Zero elevation, blends into the scaffold background
/// - Subtle 0.8px bottom border
/// - Centered title with CustomBackButton on the left
class ChartAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  /// Optional list of widgets to show on the right (actions).
  final List<Widget>? actions;

  /// Whether to show the back button. Defaults to true.
  final bool showBack;

  /// Optional background color. Defaults to Scaffold background color.
  final Color? backgroundColor;

  /// Optional title text style.
  final TextStyle? titleStyle;

  /// Optional custom title widget. If provided, [title] is ignored.
  final Widget? titleWidget;

  /// Whether the title should be centered. Defaults to true.
  final bool centerTitle;

  /// Whether to show the bottom border/divider. Defaults to true.
  final bool showBorder;

  /// Optional widget to display at the bottom of the app bar (e.g., TabBar).
  final PreferredSizeWidget? bottom;

  /// Whether to show a linear loading indicator at the bottom.
  final bool isLoading;

  /// Progress of the loading indicator (0.0 to 1.0).
  final double? loadingProgress;

  /// Optional on tap title callback
  final VoidCallback? onTapTitle;

  /// Optional custom back button callback. Defaults to Navigator.pop(context).
  final VoidCallback? onBack;

  const ChartAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack = true,
    this.backgroundColor,
    this.titleStyle,
    this.centerTitle = true,
    this.showBorder = true,
    this.bottom,
    this.isLoading = false,
    this.loadingProgress,
    this.onTapTitle,
    this.onBack,
    this.titleWidget,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
            border: showBorder && !isLoading
                ? Border(
                    bottom: BorderSide(
                      color: colorScheme.onSurface.withValues(alpha: 0.08),
                      width: 0.8,
                    ),
                  )
                : null,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  // Back button or placeholder (only if centerTitle or showBack)
                  if (showBack)
                    CustomBackButton(
                      onPressed: onBack ?? () => Navigator.pop(context),
                      color: colorScheme.onSurface,
                      size: 30,
                    )
                  else if (centerTitle)
                    const SizedBox(width: 48),

                  // Title
                  if (centerTitle)
                    Expanded(
                      child: GestureDetector(
                        onTap: onTapTitle,
                        child: titleWidget ?? Text(
                          title,
                          textAlign: TextAlign.center,
                          style:
                              titleStyle ??
                              TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                                letterSpacing: 0.2,
                                color: colorScheme.onSurface,
                              ),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: titleWidget ?? Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style:
                              titleStyle ??
                              TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                                letterSpacing: 0.2,
                                color: colorScheme.onSurface,
                              ),
                        ),
                      ),
                    ),

                  if (!centerTitle) const Spacer(),

                  // Right-side actions or balancing spacer
                  if (actions != null && actions!.isNotEmpty)
                    Row(mainAxisSize: MainAxisSize.min, children: actions!)
                  else if (centerTitle)
                    const SizedBox(width: 48),
                ],
              ),
            ),
          ),
        ),
        ?bottom,
        if (isLoading)
          ChartLinearLoader(
            isLoading: true,
            height: 2.0,
            value: loadingProgress,
          ),
      ],
    );
  }
}

/// A Sliver variant of the ChartAppBar.
class SliverChartAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBack;
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final bool floating;
  final bool pinned;
  final bool snap;
  final bool centerTitle;
  final bool showBorder;
  final PreferredSizeWidget? bottom;
  final bool isLoading;
  final double? loadingProgress;
  final VoidCallback? onBack;

  const SliverChartAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack = true,
    this.backgroundColor,
    this.titleStyle,
    this.floating = true,
    this.pinned = false,
    this.snap = true,
    this.centerTitle = true,
    this.showBorder = true,
    this.bottom,
    this.isLoading = false,
    this.loadingProgress,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: floating,
      pinned: pinned,
      snap: snap,
      backgroundColor:
          backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: ChartAppBar(
        title: title,
        actions: actions,
        showBack: showBack,
        backgroundColor:
            Colors.transparent, // Let SliverAppBar handle background
        titleStyle: titleStyle,
        centerTitle: centerTitle,
        showBorder: showBorder,
        bottom: bottom,
        isLoading: isLoading,
        loadingProgress: loadingProgress,
        onBack: onBack,
      ),
    );
  }
}











