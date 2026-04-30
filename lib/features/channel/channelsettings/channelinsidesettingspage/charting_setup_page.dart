import 'package:crown/features/channel/channelsettings/channelinsidesettingspage/select_charter_page.dart';
import 'package:flutter/material.dart';

import 'package:crown/core/utils/responsive_size.dart';

class ChartingSetupPage extends StatefulWidget {
  const ChartingSetupPage({super.key});

  @override
  State<ChartingSetupPage> createState() => _ChartingSetupPageState();
}

class _ChartingSetupPageState extends State<ChartingSetupPage> {
  final _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryGold = const Color(0xFFFFD700);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'REWARD TITLE',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 16.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Section Title: What they are being Charted for? ──
            _buildSectionHeader('WHAT IS THE REWARD FOR?'),
            SizedBox(height: 12.h),
            Text(
              'Enter the title of the reward that members will give points for.',
              style: TextStyle(
                fontSize: 13.sp,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            SizedBox(height: 24.h),
            TextField(
              controller: _titleController,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'e.g. Best Chart Contributor',
                hintStyle: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHigh.withValues(
                  alpha: 0.5,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.all(24.w),
              ),
            ),

            const Spacer(),

            // ── Next Action ──
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  if (_titleController.text.trim().isNotEmpty) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SelectCharterPage(
                          rewardTitle: _titleController.text.trim(),
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  width: 140.w,
                  height: 52.h,
                  decoration: BoxDecoration(
                    color: primaryGold,
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: primaryGold.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'NEXT STEP',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.5,
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
      ),
    );
  }
}

// Temporary placeholder until I finish linTop to the actual Invite Page
class InvitationPlaceholder extends StatelessWidget {
  const InvitationPlaceholder({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text("Invite Friends Page")));
}











