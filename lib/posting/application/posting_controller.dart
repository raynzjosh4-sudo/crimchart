import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crimchart/core/di/injection.dart';

import 'controller/posting_state.dart';
import 'controller/posting_controller.dart';
import 'posting_service.dart';

export 'controller/posting_status.dart';
export 'controller/posting_state.dart';
export 'controller/posting_controller.dart';

final postingControllerProvider =
    StateNotifierProvider<PostingController, PostingState>((ref) {
      final service = getIt<PostingService>();
      return PostingController(ref, service);
    });
