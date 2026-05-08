import 'package:crimchart/features/widgets/chartcard/models/media_data.dart';
import 'package:crimchart/features/widgets/memberimage/starter_image.dart';
import 'package:flutter/material.dart';
import '../models/member.dart';

class SelectedMemberItem extends StatelessWidget {
  final Member member;
  final VoidCallback onRemove;

  const SelectedMemberItem({
    super.key,
    required this.member,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedMedia = member.selectedMedia;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // ── Media thumbnail peeTop behind the avatar ──
            if (selectedMedia != null)
              Positioned(
                bottom: -6,
                left: -10,
                child: _MediaThumb(media: selectedMedia),
              ),

            // ── Avatar ──
            MemberImage(size: 52, imageUrl: member.avatarUrl),

            // ── Remove button ──
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.surface, width: 2),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 12,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 60,
          child: Text(
            member.name.split(' ').first,
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.7),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// Small rounded thumbnail that peeks behind the avatar.
class _MediaThumb extends StatelessWidget {
  final MediaData media;

  const _MediaThumb({required this.media});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 32,
        height: 40,
        color: colorScheme.surfaceContainerHighest,
        child: _content(colorScheme),
      ),
    );
  }

  Widget _content(ColorScheme colorScheme) {
    switch (media.type) {
      case MediaType.image:
        return Image.network(
          media.contentUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              Icon(Icons.image, size: 16, color: colorScheme.onSurfaceVariant),
        );
      case MediaType.video:
        // Show thumbnail if available, otherwise a play icon
        if (media.thumbnailUrl != null) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                media.thumbnailUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
              Center(
                child: Icon(
                  Icons.play_arrow,
                  size: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          );
        }
        return Center(
          child: Icon(
            Icons.videocam,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
        );
      case MediaType.audio:
        if (media.thumbnailUrl != null) {
          return Stack(
            fit: StackFit.expand,
            children: [
              ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Colors.black38,
                  BlendMode.darken,
                ),
                child: Image.network(
                  media.thumbnailUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox(),
                ),
              ),
              Center(
                child: Icon(
                  Icons.graphic_eq,
                  size: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          );
        }
        return Center(
          child: Icon(
            Icons.graphic_eq,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
        );
    }
  }
}











