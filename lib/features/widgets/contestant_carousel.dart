import 'package:crown/profile/models/charter_model.dart';
import 'package:crown/features/widgets/memberimage/starter_image.dart'; // ✅ IMPORT MEMBER IMAGE
import 'package:crown/features/channel/pages/channel_page.dart'; // ✅ MISSING IMPORT
import 'package:flutter/material.dart';
import '../../core/utils/responsive_size.dart';

class ContestantCarousel extends StatefulWidget {
  final List<CharterModel> contestants;
  final ValueNotifier<GlobalKey?>? activeKeyNotifier;
  final ValueNotifier<CharterModel?>? activeContestantNotifier;
  final ValueNotifier<int?>? selectedIndexNotifier;

  const ContestantCarousel({
    super.key,
    this.contestants = const [],
    this.activeKeyNotifier,
    this.activeContestantNotifier,
    this.selectedIndexNotifier,
  });

  @override
  State<ContestantCarousel> createState() => _ContestantCarouselState();
}

class _ContestantCarouselState extends State<ContestantCarousel> {
  // 📏 CONSTANT DIMENSIONS (NO ANIMATION)
  static const double _slotWidth = 150.0; 
  static const double _cardWidth = 136.0;
  static const double _listPaddingH = 16.0;

  bool _hasCrowned = false; // ✅ ONE-TIME GLOBAL RULE
  int? _clickedIndex; // ✅ TRACKS WHICH MEMBER WAS CROWNED
  late List<CharterModel> _localContestants;

  @override
  void initState() {
    super.initState();
    _localContestants = widget.contestants.isEmpty 
        ? _getMockContestants() 
        : List.from(widget.contestants);
  }

  @override
  Widget build(BuildContext context) {
    final int totalItems = _localContestants.length + 1; // "Add button" + contestants

    return SizedBox(
      height: 420.h, // ✅ BIGGER: Now 420h for the taller images + details
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: _listPaddingH.w),
        itemCount: totalItems,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildAddButton(context);
          }

          final contestant = _localContestants[index - 1];
          return _buildContestantItem(
            context,
            contestant,
            index - 1,
          );
        },
      ),
    );
  }

  Widget _buildContestantItem(
    BuildContext context,
    CharterModel contestant,
    int dataIndex,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isWinner = _clickedIndex == dataIndex;
    final bool isOther = _hasCrowned && !isWinner;

    // ── BUBBLE DRIFT PHYSICS ──
    final double driftX = isOther ? (_clickedIndex! - dataIndex) * 60.w : 0.0;
    final double driftY = isOther ? -100.h : 0.0;

    return Container(
      width: _slotWidth.w,
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── 0. THE TALLER IMAGE ──
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChannelPage(
                  focusedContestant: contestant,
                ),
              ),
            ),
            child: Container(
              width: _cardWidth.w,
              height: 240.h, // ✅ TALLER IMAGE: Now 240h
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                image: contestant.profileImageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(contestant.profileImageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  // Top Left MemberImage with Status Ring
                  Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: MemberImage(
                      size: 42.w,
                      imageUrl: contestant.profileImageUrl,
                      showStatusRing: true,
                      ringColor: colorScheme.primary, // ✅ USE THEME PRIMARY COLOR
                      showActiveDot: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.h),
          // ── 1. THE NAME ──
          Text(
            contestant.displayName,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          // ── 2. THE POINTS ──
          Text(
            '${(contestant.chartCount / 1000).toStringAsFixed(1)}k',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFFFD700), // Gold
            ),
          ),
          SizedBox(height: 12.h),
          // ── 3. 🫧 THE CROWN BUBBLE (Converges to winner) ──
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            curve: Curves.fastLinearToSlowEaseIn,
            transform: Matrix4.identity()
              ..translate(driftX, driftY)
              ..scale(isOther ? 0.4 : (isWinner && _hasCrowned ? 1.2 : 1.0)),
            transformAlignment: Alignment.center,
            child: AnimatedOpacity(
              opacity: _hasCrowned ? (isWinner ? 0.0 : 0.1) : 1.0,
              duration: const Duration(milliseconds: 800),
              child: GestureDetector(
                onTap: () {
                  if (_hasCrowned) return;
                  setState(() {
                    _hasCrowned = true;
                    _clickedIndex = dataIndex; // ✅ START THE BUBBLE DRIFT
                    _localContestants[dataIndex] = contestant.copyWith(
                      chartCount: contestant.chartCount + 1000,
                    );
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.all(isOther ? 15.w : 0),
                  width: isOther ? 30.w : 100.w,
                  height: isOther ? 30.h : 36.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700),
                    borderRadius: BorderRadius.circular(isOther ? 30.r : 20.r), // ✅ Rect to Circle
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFD700).withValues(alpha: 0.4),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: isOther ? const SizedBox.shrink() : Text(
                    'CROWN',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: _slotWidth.w,
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: _cardWidth.w,
            height: 200.h,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: colorScheme.onSurface.withValues(alpha: 0.1),
                width: 1.w,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.add,
                color: colorScheme.onSurface.withValues(alpha: 0.8),
                size: 44.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<CharterModel> _getMockContestants() {
    return [
      const CharterModel(
        id: 'm1',
        username: 'alex.v',
        displayName: 'Alex',
        profileImageUrl: 'https://i.pravatar.cc/150?img=1',
        chartCount: 4500,
        title: 'Top',
        category: 'Art',
      ),
      const CharterModel(
        id: 'm2',
        username: 'sarah.k',
        displayName: 'Sarah',
        profileImageUrl: 'https://i.pravatar.cc/150?img=2',
        chartCount: 3200,
        title: 'Star',
        category: 'Tech',
      ),
      const CharterModel(
        id: 'm3',
        username: 'mike.j',
        displayName: 'Mike',
        profileImageUrl: 'https://i.pravatar.cc/150?img=3',
        chartCount: 2800,
        title: 'Elite',
        category: 'Sports',
      ),
    ];
  }
}
