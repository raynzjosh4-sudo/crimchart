import 'package:flutter/material.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:crown/commentingsheets/widgets/commenting_sheet.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CommentActionWidget extends StatefulWidget {
  final int initialComments;
  final Color themeColor;
  final bool initialHasCommented;
  final Color? inactiveColor;
  final double iconSize;
  final bool showIcon;
  final bool showLabel;
  final TextStyle? textStyle;
  final VoidCallback? onTap;

  // ── Related Post Metadata (DNA) ──────────────────────────────────────────
  final String? linkedPostId;
  final String? linkedAuthorUsername;
  final String? linkedCaption;
  final String? linkedChannelId;
  final String? linkedThumbnailUrl;

  // ── Active Context (Destination) ─────────────────────────────────────────
  final String? channelId;
  final String? channelName;

  const CommentActionWidget({
    super.key,
    required this.initialComments,
    required this.themeColor,
    this.initialHasCommented = false,
    this.inactiveColor,
    this.iconSize = 16.0,
    this.showIcon = true,
    this.showLabel = false,
    this.textStyle,
    this.onTap,
    this.linkedPostId,
    this.linkedAuthorUsername,
    this.linkedCaption,
    this.linkedChannelId,
    this.linkedThumbnailUrl,
    this.channelId,
    this.channelName,
  });

  @override
  State<CommentActionWidget> createState() => _CommentActionWidgetState();
}

class _CommentActionWidgetState extends State<CommentActionWidget> {
  late int _comments;
  bool _hasCommented = false;

  @override
  void initState() {
    super.initState();
    _comments = widget.initialComments;
    _hasCommented = widget.initialHasCommented;
  }

  void _openCommentSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => CommentingSheet(
        channelId: widget.channelId,
        channelName: widget.channelName,
        linkedPostId: widget.linkedPostId,
        linkedAuthorUsername: widget.linkedAuthorUsername,
        linkedCaption: widget.linkedCaption,
        linkedChannelId: widget.linkedChannelId,
        linkedThumbnailUrl: widget.linkedThumbnailUrl,
        onCommentPosted: () {
          setState(() {
            if (!_hasCommented) {
              _comments++;
              _hasCommented = true;
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = _hasCommented ? widget.themeColor : (widget.inactiveColor ?? Colors.grey);
    
    return GestureDetector(
      onTap: widget.onTap ?? _openCommentSheet,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showIcon) ...[
            Icon(
              LucideIcons.messageSquare,
              size: widget.iconSize,
              color: color.withValues(alpha: 0.8),
            ),
            const SizedBox(width: 6),
          ],
          Text(
             _comments == 0 && widget.showLabel ? 'Comment' : _comments.toString(),
            style: widget.textStyle?.copyWith(color: color) ?? 
                   TextStyle(fontSize: 12.sp, color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
