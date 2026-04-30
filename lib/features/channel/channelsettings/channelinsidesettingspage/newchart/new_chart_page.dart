import 'package:crown/features/newinsidechartstartpage/models/member.dart';
import 'package:crown/features/widgets/chartcard/models/media_data.dart';
import 'package:crown/features/widgets/memberimage/starter_image.dart';
import 'package:flutter/material.dart';
import 'package:crown/chartappbar/chart_app_bar.dart';

import 'package:crown/core/utils/responsive_size.dart';

class NewChartPage extends StatefulWidget {
  final Member member;
  final MediaData mediaData;

  const NewChartPage({
    super.key,
    required this.member,
    required this.mediaData,
  });

  @override
  State<NewChartPage> createState() => _NewChartPageState();
}

class _NewChartPageState extends State<NewChartPage> {
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: ChartAppBar(
        title: 'NEW Chart',
        centerTitle: false,
        showBack: true,
        titleStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 22.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.8,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Media & Profile Overlay
              Center(
                child: SizedBox(
                  width: 200.w,
                  height: 250.h,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Media Image
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: colorScheme.surfaceContainerHighest,
                          image: DecorationImage(
                            image: NetworkImage(
                              widget.mediaData.thumbnailUrl ??
                                  widget.mediaData.contentUrl,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // User Profile overlapping bottom-right
                      Positioned(
                        bottom: -16.h,
                        right: -16.w,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorScheme.surface,
                            border: Border.all(
                              color: colorScheme.surface,
                              width: 3,
                            ),
                          ),
                          child: MemberImage(
                            size: 48.h,
                            imageUrl: widget.member.avatarUrl,
                            showActiveDot: false,
                            showStatusRing: false,
                            borderWidth: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 60.h),

              // Title Field
              Text(
                'Chart TITLE',
                style: TextStyle(
                  color: colorScheme.primary.withOpacity(0.8),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: _titleController,
                maxLength: 60,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter a creative title...',
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.3),
                    fontSize: 18.sp,
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest.withOpacity(
                    0.3,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              // Confirm Button
              ElevatedButton(
                onPressed: () {
                  // Finish Chart action
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'CONFIRM Chart',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}











