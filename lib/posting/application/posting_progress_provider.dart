import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostingProgress {
  final double progress;
  final String uploadedSize;
  final String totalSize;
  final bool isOffline;

  const PostingProgress({
    this.progress = 0.0,
    this.uploadedSize = '0.0 MB',
    this.totalSize = '0.0 MB',
    this.isOffline = false,
  });

  PostingProgress copyWith({
    double? progress,
    String? uploadedSize,
    String? totalSize,
    bool? isOffline,
  }) {
    return PostingProgress(
      progress: progress ?? this.progress,
      uploadedSize: uploadedSize ?? this.uploadedSize,
      totalSize: totalSize ?? this.totalSize,
      isOffline: isOffline ?? this.isOffline,
    );
  }
}

/// 👑 REALT-TIME UPLOAD TRACKER
/// Keyed by postId to allow multiple concurrent uploads with unique progress bars.
final postingProgressProvider = StateProvider.family<PostingProgress, String>((ref, postId) {
  return const PostingProgress();
});
