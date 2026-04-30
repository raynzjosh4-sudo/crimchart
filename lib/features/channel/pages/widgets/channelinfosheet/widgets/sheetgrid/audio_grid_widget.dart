import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:crown/core/localization/localization_provider.dart';
import 'package:crown/core/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:crown/features/feed/domain/entities/post_entity.dart';
import '../audioplayer/audio_player_page.dart';
import '../dummy_data.dart';

class AudioGridWidget extends StatefulWidget {
  final List<PostEntity> audioPosts;

  const AudioGridWidget({
    super.key,
    this.audioPosts = const [],
  });

  @override
  State<AudioGridWidget> createState() => _AudioGridWidgetState();
}

class _AudioGridWidgetState extends State<AudioGridWidget> {
  static const int _pageSize = 8;
  int _loadedCount = _pageSize;
  
  List<Map<String, dynamic>> get _realItems => widget.audioPosts
      .map((p) => {
            "title": p.caption.isNotEmpty ? p.caption : "Audio",
            "artist": p.authorUsername,
            "duration": "",
            "likes": p.likes,
            "coverUrl": p.thumbnailUrls.isNotEmpty ? p.thumbnailUrls.first : null,
            "audioUrl": p.audioUrl ?? "",
          })
      .toList();

  List<Map<String, dynamic>> get _source =>
      widget.audioPosts.isNotEmpty ? _realItems : SheetDummyData.audio;

  void _openAudio(BuildContext context, Map<String, dynamic> item) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, _) => AudioPlayerPage(
          audioUrl: item["audioUrl"] as String,
          title: item["title"] as String,
          artist: item["artist"] as String,
          coverUrl: item["coverUrl"] as String?,
          likes: (item["likes"] as int?) ?? 0,
        ),
        transitionsBuilder: (context, animation, _, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeOutQuart));
          return SlideTransition(position: animation.drive(tween), child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final activeColor = context.read<ThemeProvider>().currentColor;
    final visibleItems = _source.take(_loadedCount).toList();
    final hasMore = _loadedCount < _source.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              ...visibleItems.map((item) => _buildAudioTile(
                    context,
                    item: item,
                    colorScheme: colorScheme,
                    activeColor: activeColor,
                  )),
              if (hasMore) ...[
                SizedBox(height: 8.h),
                Center(
                  child: GestureDetector(
                    onTap: () => setState(() => _loadedCount += _pageSize),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: colorScheme.onSurface.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LucideIcons.chevronDown,
                              size: 16.sp,
                              color: colorScheme.onSurface.withValues(alpha: 0.5)),
                          SizedBox(width: 6.w),
                          Text(
                            context.tr("load_more"),
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: colorScheme.onSurface.withValues(alpha: 0.5),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAudioTile(
    BuildContext context, {
    required Map<String, dynamic> item,
    required ColorScheme colorScheme,
    required Color activeColor,
  }) {
    return GestureDetector(
      onTap: () => _openAudio(context, item),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: colorScheme.onSurface.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            // Cover art
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: item["coverUrl"] != null
                  ? CachedNetworkImage(
                      imageUrl: item["coverUrl"] as String,
                      width: 52.w,
                      height: 52.w,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => _buildMusicPlaceholder(activeColor),
                    )
                  : _buildMusicPlaceholder(activeColor),
            ),
            SizedBox(width: 14.w),

            // Title + Artist
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["title"] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    item["artist"] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 12.w),

            // Duration + play
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if ((item["duration"] as String).isNotEmpty)
                  Text(
                    item["duration"] as String,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                SizedBox(height: 6.h),
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: activeColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(LucideIcons.play, size: 14.sp, color: activeColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMusicPlaceholder(Color activeColor) {
    return Container(
      width: 52.w,
      height: 52.w,
      decoration: BoxDecoration(
        color: activeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Icon(LucideIcons.music, size: 22.sp, color: activeColor),
    );
  }
}
