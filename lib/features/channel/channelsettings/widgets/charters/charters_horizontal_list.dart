import 'package:crimchart/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import '../../../../newinsidechartstartpage/models/member.dart';

class ChartersHorizontalList extends StatelessWidget {
  final List<Member> members;
  final String title;
  final VoidCallback? onSeeAll;
  final String? seeAllLabel;

  const ChartersHorizontalList({
    super.key,
    required this.members,
    this.title = 'ChartERS',
    this.onSeeAll,
    this.seeAllLabel = 'SEE ALL',
  });

  @override
  Widget build(BuildContext context) {
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
        SizedBox(height: 12.h),

        // Members List Row
        SizedBox(
          height: 160.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            itemCount: members.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Container(
                    width: 105.w,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Stack(
                      children: [
                        // Top Left Avatar with Plus Badge
                        Positioned(
                          top: 8.h,
                          left: 8.w,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 36.w,
                                height: 36.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorScheme.surfaceContainerHighest
                                      .withValues(alpha: 0.8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18.w),
                                  child: Icon(
                                    Icons.person,
                                    color: colorScheme.onSurfaceVariant,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                              // Plus icon badge
                              Positioned(
                                bottom: -2.w,
                                right: -2.w,
                                child: Container(
                                  width: 14.w,
                                  height: 14.w,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF00C853,
                                    ), // Green plus background
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: colorScheme.surface,
                                      width: 1.5.w,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 10.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Add status text
                        Positioned(
                          bottom: 12.h,
                          left: 10.w,
                          right: 10.w,
                          child: Text(
                            'Add status',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final member = members[index - 1];

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Container(
                  width: 105.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.3,
                    ),
                    image:
                        member.avatarUrl != null && member.avatarUrl!.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(member.avatarUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: Stack(
                    children: [
                      // Gradient overlay for better text readability
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.2),
                              Colors.black.withValues(alpha: 0.8),
                            ],
                          ),
                        ),
                      ),
                      // Top Left Avatar with Status Ring
                      Positioned(
                        top: 8.h,
                        left: 8.w,
                        child: Container(
                          width: 36.w,
                          height: 36.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(
                                0xFF00C853,
                              ), // Green status ring
                              width: 2.w,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(
                              2.w,
                            ), // space between ring and image
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.network(
                                member.avatarUrl ?? '',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      color: Colors.grey.shade800,
                                      child: Icon(
                                        Icons.person,
                                        size: 16.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Name at bottom
                      Positioned(
                        bottom: 12.h,
                        left: 10.w,
                        right: 10.w,
                        child: Text(
                          member.name.split(' ').first,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Bottom Action (See All)
        if (onSeeAll != null) ...[
          SizedBox(height: 8.h),
          Center(
            child: GestureDetector(
              onTap: onSeeAll,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                child: Text(
                  seeAllLabel ?? 'SEE ALL',
                  style: TextStyle(
                    fontSize: 10.sp,
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











