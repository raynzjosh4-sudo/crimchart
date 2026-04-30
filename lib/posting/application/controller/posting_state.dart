import 'posting_status.dart';

class PostingState {
  final PostingStatus status;
  final double progress;
  final String? error;

  PostingState({
    required this.status,
    this.progress = 0.0,
    this.error,
  });

  PostingState copyWith({
    PostingStatus? status,
    double? progress,
    String? error,
  }) {
    return PostingState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      error: error ?? this.error,
    );
  }
}
