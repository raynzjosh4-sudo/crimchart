import 'package:flutter/material.dart';
import '../../../../../features/widgets/memberimage/starter_image.dart';
import '../models/story_model.dart';
import 'status_page.dart';

class StoryListWidget extends StatelessWidget {
  final List<StoryModel> stories;

  const StoryListWidget({super.key, required this.stories});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 135,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          final themeColor = Theme.of(context).primaryColor;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () {
                final String heroTag = 'story_hero_${story.username}_$index';
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 600),
                    reverseTransitionDuration: const Duration(milliseconds: 400),
                    pageBuilder: (context, animation, secondaryAnimation) => StatusPage(
                      username: story.username,
                      userProfileImageUrl: story.userProfileImageUrl,
                      statusImageUrl: story.userProfileImageUrl, 
                      isChartable: story.isChartable,
                      isPublic: story.isPublic,
                      heroTag: heroTag,
                    ),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                          child: child,
                        ),
                      );
                    },
                  ),
                );
              },
              child: Column(
                children: [
                  Stack(
                    children: [
                      Hero(
                        tag: 'story_hero_${story.username}_$index',
                        child: MemberImage(
                          size: 90,
                          imageUrl: story.userProfileImageUrl,
                          showStatusRing: story.hasUnviewedStatus,
                          showActiveDot: true,
                          useHexagon: false,
                        ),
                      ),
                      if (index == 0) // "Your story" add button badge
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: themeColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                width: 2.5,
                              ),
                            ),
                            child: Icon(
                              Icons.add_rounded,
                              size: 26,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        ),
                      if (story.isLive)
                        Positioned(
                          bottom: -4,
                          left: 0,
                          right: 0,
                          child: Container(
                            alignment: Alignment.center,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.pinkAccent,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).scaffoldBackgroundColor,
                                  width: 2,
                                ),
                              ),
                              child: const Text(
                                'LIVE',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 90,
                    child: Text(
                      story.username,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: story.hasUnviewedStatus
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}





























