import 'package:crimchart/chartappbar/chart_app_bar.dart';
import 'package:crimchart/core/localization/localization_provider.dart';
import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:crimchart/features/newinsidechartstartpage/dummydata/dummy_data.dart';
import 'package:crimchart/features/widgets/memberimage/starter_image.dart';
import 'package:flutter/material.dart';

class ChannelInvitePage extends StatefulWidget {
  const ChannelInvitePage({super.key});

  @override
  State<ChannelInvitePage> createState() => _ChannelInvitePageState();
}

class _ChannelInvitePageState extends State<ChannelInvitePage> {
  final Set<String> _invitedIds = {};

  void _finishCreation() {
    // Skip / Finish action: For now we pop entirely back to where they started,
    // which effectively "opens the channel page" (mock flow).
    // The user requested to "open that channel in the channel page".
    // You can replace this route later when the real Channel Entity ID is returned.
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final fallbackMembers = dummyMembers.take(15).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChartAppBar(
        title: context.tr('invite_members_title'),
        showBack: true,
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _finishCreation,
            child: Text(
              context.tr('skip'),
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
              ),
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Text(
              'Invite members you are following to kickstart your new channel!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: 14.sp,
                height: 1.5,
              ),
            ),
          ),
          Divider(color: colorScheme.onSurface.withValues(alpha: 0.05)),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              itemCount: fallbackMembers.length,
              itemBuilder: (context, index) {
                final member = fallbackMembers[index];
                final isInvited = _invitedIds.contains(member.id);

                return ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8.h,
                    horizontal: 8.w,
                  ),
                  leading: MemberImage(
                    imageUrl: member.avatarUrl,
                    size: 48.h,
                    showActiveDot: false,
                    showStatusRing: false,
                    borderWidth: 0,
                  ),
                  title: Text(
                    member.name,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '@${member.name.toLowerCase().replaceAll(' ', '')}',
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: 13.sp,
                    ),
                  ),
                  trailing: ElevatedButton(
                    onPressed: isInvited
                        ? null
                        : () {
                            setState(() {
                              _invitedIds.add(member.id);
                            });
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isInvited
                          ? colorScheme.surfaceContainerHighest
                          : colorScheme.primary,
                      foregroundColor: isInvited
                          ? colorScheme.onSurface.withValues(alpha: 0.5)
                          : colorScheme.onPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 0,
                      ),
                    ),
                    child: Text(
                      isInvited ? 'INVITED' : 'INVITE',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: ElevatedButton(
                onPressed: _finishCreation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  minimumSize: Size(double.infinity, 56.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  context.tr('done'),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
