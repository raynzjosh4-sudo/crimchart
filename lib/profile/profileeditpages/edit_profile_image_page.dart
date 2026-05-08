import 'dart:io';
import 'dart:ui' as ui;
import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/commentingsheets/widgets/tabs/device_media_tab.dart';
import 'package:crimchart/core/di/injection.dart';
import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/network/cloud_media_service.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/core/widgets/chart_image.dart';
import 'package:crimchart/core/widgets/chart_linear_loader.dart';
import 'package:crimchart/features/auth/application/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:path_provider/path_provider.dart';

class EditProfileImagePage extends ConsumerStatefulWidget {
  const EditProfileImagePage({super.key});

  @override
  ConsumerState<EditProfileImagePage> createState() =>
      _EditProfileImagePageState();
}

class _EditProfileImagePageState extends ConsumerState<EditProfileImagePage> {
  String? _selectedImageUrl;
  String? _localMediaPath; // Path to new selected image from phone
  bool _isSaving = false;
  final GlobalKey _cropKey = GlobalKey();
  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    // Initialize with current profile image
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authControllerProvider).user;
      if (user != null && mounted) {
        setState(() {
          _selectedImageUrl = user.profileImageUrl;
        });
      }
    });
  }

  Future<void> _saveImage() async {
    final user = ref.read(authControllerProvider).user;
    if (user == null) return;

    // If no new image selected, just pop
    if (_localMediaPath == null && _selectedImageUrl == user.profileImageUrl) {
      Navigator.pop(context);
      return;
    }

    setState(() => _isSaving = true);

    try {
      // 1. Capture exact visible frame from user's screen pan/zoom
      final boundary =
          _cropKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) throw Exception("Could not capture image frame.");

      final image = await boundary.toImage(pixelRatio: 2.0); // 2x raw quality
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final cloudService = getIt<CloudMediaService>();
      final appDir = await getTemporaryDirectory();

      final rawCropPath =
          '${appDir.path}/raw_crop_${DateTime.now().millisecondsSinceEpoch}.png';
      await File(rawCropPath).writeAsBytes(pngBytes);

      final compressedPath =
          '${appDir.path}/profile_avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // 2. Native C++ compression
      await FFmpegKit.execute(
        '-y -i "$rawCropPath" -vf "scale=512:-1" -q:v 4 "$compressedPath"',
      );

      // 3. Upload safely locked inside user space
      final finalAvatarUrl = await cloudService.uploadMedia(
        File(compressedPath),
        userId: user.id,
        folderName: 'profile_pictures',
      );

      if (finalAvatarUrl != null && mounted) {
        // Update global auth state & supabase
        await ref.read(authControllerProvider.notifier).updateProfile({
          'profile_image_url': finalAvatarUrl,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.tr('saved', listen: false))),
          );
          Navigator.pop(context);
        }
      } else {
        throw Exception("Upload failed");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final user = ref.watch(authControllerProvider).user;
    final displayUrl =
        _localMediaPath ?? _selectedImageUrl ?? user?.profileImageUrl;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: ChartAppBar(
        title: context.tr('gallery'),
        backgroundColor: isDark ? Colors.black : Colors.white,
        titleStyle: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w900,
          fontSize: 16.sp,
        ),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveImage,
            child: Text(
              context.tr('save'),
              style: TextStyle(
                color: _isSaving
                    ? colorScheme.onSurface.withValues(alpha: 0.3)
                    : colorScheme.primary,
                fontWeight: FontWeight.w900,
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Base background
          Container(color: isDark ? Colors.black : Colors.white),

          // The Cropping Area - Perfectly squared to screen width
          Center(
            child: RepaintBoundary(
              key: _cropKey,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(
                  context,
                ).size.width, // Force 1:1 Aspect Ratio
                color: isDark ? Colors.black : Colors.white,
                child: ClipRect(
                  child: InteractiveViewer(
                    transformationController: _transformationController,
                    minScale: 0.1,
                    maxScale: 6.0,
                    boundaryMargin: const EdgeInsets.all(double.infinity),
                    clipBehavior: Clip.none,
                    child: Center(
                      child: _localMediaPath != null
                          ? Image.file(
                              File(_localMediaPath!),
                              fit: BoxFit
                                  .contain, // Fit fully inside InteractiveViewer initially
                            )
                          : ChartImage(
                              url: displayUrl,
                              fit: BoxFit
                                  .cover, // Keep historical profile pictures filling frame
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Top layer: Circular Overlay Guide
          IgnorePointer(
            child: CustomPaint(
              painter: _CropOverlayPainter(isDark: isDark),
              size: Size.infinite,
            ),
          ),

          // Change Photo Button
          Positioned(
            bottom: 40.h,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () => _showGalleryBottomSheet(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.onSurface.withValues(
                    alpha: isDark ? 0.2 : 0.08,
                  ),
                  foregroundColor: colorScheme.onSurface,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 12.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
                child: Text(
                  context.tr('change_photo'),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14.sp,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ),

          // Facebook-style Top Linear Loader
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ChartLinearLoader(isLoading: _isSaving),
          ),
        ],
      ),
    );
  }

  void _showGalleryBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                SizedBox(height: 12.h),
                Container(
                  width: 40.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2.5.r),
                  ),
                ),
                SizedBox(height: 16.h),
                Expanded(
                  child: DeviceMediaTab(
                    scrollController: scrollController,
                    selectedIndices: const [], // No persistent selection needed for single pick
                    onMediaTap: (index, media) {
                      setState(() {
                        _localMediaPath =
                            media.contentUrl; // Holds local File Path
                        _transformationController.value = Matrix4.identity();
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _CropOverlayPainter extends CustomPainter {
  final bool isDark;
  _CropOverlayPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? Colors.black : Colors.white).withValues(alpha: 0.7);
    final circleRadius = size.width * 0.475;
    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
          ..addOval(Rect.fromCircle(center: center, radius: circleRadius))
          ..close(),
      ),
      paint,
    );

    final borderPaint = Paint()
      ..color = (isDark ? Colors.white24 : Colors.black12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2.w;
    canvas.drawCircle(center, circleRadius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}











