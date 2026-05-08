import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import '../../../../newinsidechartstartpage/models/member.dart';

class MembersHorizontalList extends StatelessWidget {
  final List<Member> members;
  final String title;
  final VoidCallback? onSeeAll;
  final bool showChannels;
  final String? seeAllLabel;

  const MembersHorizontalList({
    super.key,
    required this.members,
    this.title = 'MEMBERS',
    this.onSeeAll,
    this.showChannels = true,
    this.seeAllLabel = 'SEE ALL',
  });

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row (Title & Count)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              Text(
                '${members.length}',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),

        // Only show the list if there are members
        if (members.isNotEmpty) ...[
          SizedBox(height: 8.h),
          SizedBox(
            height: showChannels ? 110.h : 90.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Column(
                    children: [
                      Container(
                        width: 48.w,
                        height: 48.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: showChannels
                                ? const Color(0xFFFFD700)
                                : colorScheme.onSurface.withValues(alpha: 0.1),
                            width: 1.2.w,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            member.avatarUrl ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: colorScheme.surfaceContainerHighest,
                                  child: Icon(
                                    Icons.person,
                                    size: 20.sp,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      SizedBox(
                        width: 56.w,
                        child: Text(
                          member.name.split(' ').first,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface.withValues(alpha: 0.9),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (showChannels) ...[
                        SizedBox(height: 2.h),
                        Text(
                          '${member.channelsCount} ch',
                          style: TextStyle(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface.withValues(alpha: 0.45),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],

        // Bottom Action (See All)
        if (onSeeAll != null) ...[
          SizedBox(height: 4.h), // Shrunk from 8.h
          Center(
            child: GestureDetector(
              onTap: onSeeAll,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w), // Shrunk from 8.h
                child: Text(
                  seeAllLabel ?? 'SEE ALL',
                  style: TextStyle(
                    fontSize: 9.sp, // Shrunk from 10.sp
                    fontWeight: FontWeight.w800,
                    color: Colors.amber,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
