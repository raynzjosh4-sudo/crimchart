import 'package:flutter/material.dart';
import '../../models/media_item.dart';
import '../finalpostpage/finalize_post_page.dart';

// ─── Editing tools are commented out (pending re-implementation) ──────────────
// When ready to re-enable, restore the implementation from git history and
// uncomment these imports:
//
// import 'dart:io';
// import 'package:crown/core/localization/localization_provider.dart';
// import 'package:crown/core/utils/responsive_size.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:crown/core/native/chart_native_ffi.dart';
// import 'functioning/edit_post_controller.dart';
// import 'widgets/edit_top_bar.dart';
// import 'widgets/edit_right_toolbar.dart';
// import 'widgets/edit_bottom_bar.dart';
// import 'widgets/edit_bottom_sheet.dart';
// import 'widgets/edit_media_preview.dart';
// import 'widgets/story_progress_bar.dart';
// import 'widgets/edit_tab_views.dart';
// import 'widgets/media_selection_sheet.dart';
// import 'widgets/music_selection_sheet.dart';
// ─────────────────────────────────────────────────────────────────────────────

/// Stub — immediately forwards to [FinalizePostPage] without showing any UI.
/// Editing tools (right toolbar, trim, stickers, music, FFI encoding) are
/// commented out until that feature is ready.
class EditPostPage extends StatefulWidget {
  final List<MediaItem> selectedMedia;

  const EditPostPage({super.key, required this.selectedMedia});

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
              FinalizePostPage(selectedMedia: widget.selectedMedia),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
