// import 'package:flutter/material.dart';
// import 'package:crown/core/utils/responsive_size.dart';
// import 'package:crown/profile/models/charter_model.dart';
// import 'person_card.dart';

// class PeopleYouMayKnowSection extends StatelessWidget {
//   final List<CharterModel> people;
//   final VoidCallback? onSeeAll;

//   const PeopleYouMayKnowSection({
//     super.key,
//     required this.people,
//     this.onSeeAll,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (people.isEmpty) return const SizedBox.shrink();

//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;

//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 16.h),
//       decoration: BoxDecoration(
//         color: theme.scaffoldBackgroundColor == Colors.transparent
//             ? Colors.transparent
//             : theme.scaffoldBackgroundColor,
//         border: Border(
//           bottom: BorderSide(
//             color: colorScheme.onSurface.withValues(alpha: 0.1),
//             width: 8.h, // Thick divider typical of FB feeds
//           ),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             child: Text(
//               'People you may know',
//               style: TextStyle(
//                 color: colorScheme.onSurface.withValues(alpha: 0.5),
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//           SizedBox(height: 12.h),
//           SizedBox(
//             height: 240.h,
//             child: ListView.separated(
//               padding: EdgeInsets.symmetric(horizontal: 16.w),
//               scrollDirection: Axis.horizontal,
//               itemCount: people.length,
//               separatorBuilder: (context, index) => SizedBox(width: 12.w),
//               itemBuilder: (context, index) {
//                 final person = people[index];
//                 return PersonCard(
//                   imageUrl: person.profileImageUrl,
//                   name: person.displayName,
//                   mutualFriendsText: person.chartCount > 0
//                       ? '${person.chartCount} mutual friends'
//                       : '',
//                   onAddFriend: () {
//                     // Logic for add friend
//                   },
//                 );
//               },
//             ),
//           ),
//           SizedBox(height: 20.h),
//           Center(
//             child: GestureDetector(
//               onTap: onSeeAll,
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     'See all',
//                     style: TextStyle(
//                       color: colorScheme.onSurface.withValues(alpha: 0.6),
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   SizedBox(width: 4.w),
//                   Icon(
//                     Icons.chevron_right,
//                     size: 18.sp,
//                     color: colorScheme.onSurface.withValues(alpha: 0.6),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
