import 'package:crown/posting/application/music_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/media_item.dart';
import '../../../../core/utils/responsive_size.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MusicSearchTab extends StatefulWidget {
  final String searchQuery;
  final Function(MediaItem) onSelect;

  const MusicSearchTab({
    super.key,
    required this.onSelect,
    this.searchQuery = '',
  });

  @override
  State<MusicSearchTab> createState() => _MusicSearchTabState();
}

class _MusicSearchTabState extends State<MusicSearchTab> {
  final MusicService _musicService = MusicService();
  final AudioPlayer _player = AudioPlayer();
  bool _isLoading = false;
  List<dynamic> _results = [];
  String? _playingUrl;

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  @override
  void didUpdateWidget(MusicSearchTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery) {
      _loadResults();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _loadResults() async {
    setState(() => _isLoading = true);
    try {
      List<dynamic> response;
      if (widget.searchQuery.isEmpty) {
        response = await _musicService.getTrendingMusic();
      } else {
        response = await _musicService.searchMusic(widget.searchQuery);
      }

      setState(() {
        _results = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _togglePlayback(dynamic track) async {
    String? previewUrl = track['previewUrl'];

    // If it's an RSS result, we need to fetch the preview URL via a lookup
    if (previewUrl == null || previewUrl.isEmpty) {
      setState(() => _isLoading = true);
      final searchRes = await _musicService.getSongPreviewUrl('${track['trackName']} ${track['artistName']}');
      previewUrl = searchRes;
      track['previewUrl'] = searchRes; // Cache it
      setState(() => _isLoading = false);
    }

    if (previewUrl == null || previewUrl.isEmpty) return;

    if (_playingUrl == previewUrl) {
      if (_player.playing) {
        await _player.pause();
      } else {
        await _player.play();
      }
    } else {
      await _player.setUrl(previewUrl);
      _playingUrl = previewUrl;
      await _player.play();
    }
    setState(() {});
  }

  void _confirmSelection(dynamic track) {
    _player.stop();
    widget.onSelect(
      MediaItem(
        path: track['previewUrl'] ?? '',
        type: MediaType.audio,
        title: track['trackName'],
        artist: track['artistName'],
        thumbnailUrl: track['artworkUrl100'],
        source: MediaSource.gallery,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white24),
      );
    }

    if (_results.isEmpty) {
      return Center(
        child: Text(
          'No songs found',
          style: TextStyle(color: Colors.white38, fontSize: 13.sp),
        ),
      );
    }

    return ListView.builder(
      itemCount: _results.length,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemBuilder: (context, index) {
        final track = _results[index];
        final isPlaying = _playingUrl == track['previewUrl'];

        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          leading: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  image: track['artworkUrl60'] != null
                      ? DecorationImage(
                          image: NetworkImage(track['artworkUrl60']),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: Colors.white10,
                ),
                child: track['artworkUrl60'] == null
                    ? const Icon(LucideIcons.music, color: Colors.white38)
                    : null,
              ),
              if (isPlaying)
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Icon(
                    _player.playing ? LucideIcons.pause : LucideIcons.play,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
            ],
          ),
          title: Text(
            track['trackName'] ?? 'Unknown',
            style: TextStyle(
              color: isPlaying ? Theme.of(context).colorScheme.primary : Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Text(
              '${track['artistName'] ?? 'Unknown'} · 00:30',
              style: TextStyle(color: Colors.white38, fontSize: 13.sp),
            ),
          ),
          trailing: isPlaying
              ? ElevatedButton(
                  onPressed: () => _confirmSelection(track),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    minimumSize: Size(60.w, 32.h),
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.r)),
                  ),
                  child: Text('Use', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w900)),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.scissors, color: Colors.white38, size: 20.sp),
                    SizedBox(width: 16.w),
                    Icon(LucideIcons.bookmark, color: Colors.white38, size: 20.sp),
                  ],
                ),
          onTap: () => _togglePlayback(track),
        );
      },
    );
  }
}
