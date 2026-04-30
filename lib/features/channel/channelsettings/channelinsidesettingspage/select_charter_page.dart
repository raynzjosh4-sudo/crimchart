import 'package:crown/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../newinsidechartstartpage/models/member.dart';
import '../../../newinsidechartstartpage/dummydata/dummy_data.dart';
import '../../../widgets/memberimage/starter_image.dart';
import '../../../../channelcreatepage/channel_invite_page.dart';

class SelectCharterPage extends StatefulWidget {
  final String rewardTitle;
  const SelectCharterPage({super.key, required this.rewardTitle});

  @override
  State<SelectCharterPage> createState() => _SelectCharterPageState();
}

class _SelectCharterPageState extends State<SelectCharterPage> {
  Member? _selectedMember;
  bool _isMe = false;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryGold = const Color(0xFFFFD700);

    final filteredMembers = dummyMembers.where((m) {
      final query = _searchQuery.toLowerCase();
      return m.name.toLowerCase().contains(query);
    }).toList();

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
          'SELECT ChartER',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 16.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── Search Bar ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: 'Search members...',
                hintStyle: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                prefixIcon: Icon(
                  LucideIcons.search,
                  size: 18.sp,
                  color: primaryGold.withValues(alpha: 0.6),
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHigh.withValues(
                  alpha: 0.5,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 14.h),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              children: [
                SizedBox(height: 10.h),
                _buildSectionLabel('ELIGIBLE CANDIDATES'),
                SizedBox(height: 12.h),

                // Me Option
                _buildSelectableTile(
                  isSelected: _isMe,
                  onTap: () => setState(() {
                    _isMe = true;
                    _selectedMember = null;
                  }),
                  title: 'Charting Myself',
                  subtitle: '@you',
                  icon: LucideIcons.user,
                ),

                SizedBox(height: 20.h),
                _buildSectionLabel('SUGGESTED FROM DATA'),
                SizedBox(height: 12.h),

                // Members List
                ...filteredMembers.map(
                  (member) => Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: _buildSelectableTile(
                      isSelected: _selectedMember?.id == member.id,
                      onTap: () => setState(() {
                        _selectedMember = member;
                        _isMe = false;
                      }),
                      title: member.name,
                      subtitle: member.title ?? 'Member',
                      avatarUrl: member.avatarUrl,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Bottom Action ──
          Container(
            padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 40.h),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FOR REWARD:',
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        widget.rewardTitle.toUpperCase(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: primaryGold,
                          fontWeight: FontWeight.w900,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                GestureDetector(
                  onTap: (_isMe || _selectedMember != null)
                      ? () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ChannelInvitePage(),
                            ),
                          );
                        }
                      : null,
                  child: Opacity(
                    opacity: (_isMe || _selectedMember != null) ? 1.0 : 0.5,
                    child: Container(
                      width: 130.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: primaryGold,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Center(
                        child: Text(
                          'CONTINUE',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w800,
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSelectableTile({
    required bool isSelected,
    required VoidCallback onTap,
    required String title,
    required String subtitle,
    IconData? icon,
    String? avatarUrl,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryGold = const Color(0xFFFFD700);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryGold.withValues(alpha: 0.08)
              : colorScheme.surfaceContainerHigh.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? primaryGold : Colors.transparent,
            width: 1.5.w,
          ),
        ),
        child: Row(
          children: [
            if (avatarUrl != null)
              MemberImage(size: 40.w, imageUrl: avatarUrl)
            else
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: isSelected
                      ? primaryGold
                      : colorScheme.onSurface.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon ?? LucideIcons.user,
                  color: isSelected
                      ? Colors.black
                      : colorScheme.onSurface.withValues(alpha: 0.5),
                  size: 18.sp,
                ),
              ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? primaryGold : colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: primaryGold, size: 20.sp),
          ],
        ),
      ),
    );
  }
}











