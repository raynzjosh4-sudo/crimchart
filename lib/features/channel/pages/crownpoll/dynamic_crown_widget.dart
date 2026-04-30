import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:crown/core/utils/responsive_size.dart';
import 'crown_option_model.dart';
import 'widgets/crown_poll_card.dart';
import 'widgets/expandable_crown_text.dart';
import 'widgets/mediatype/crown_media_type.dart';
import 'pages/crown_detail_page.dart';

class DynamicCrownWidget extends StatefulWidget {
  final CrownModel pollModel;
  final Color themeColor;
  final bool fullBleed;

  const DynamicCrownWidget({
    super.key,
    required this.pollModel,
    required this.themeColor,
    this.fullBleed = true,
  });

  @override
  State<DynamicCrownWidget> createState() => _DynamicCrownWidgetState();
}

class _DynamicCrownWidgetState extends State<DynamicCrownWidget> {
  late List<CrownOptionModel> _options;
  final TextEditingController _newOptionController = TextEditingController();
  bool _isAddingOption = false;

  @override
  void initState() {
    super.initState();
    _options = List.from(widget.pollModel.options);
  }

  @override
  void dispose() {
    _newOptionController.dispose();
    super.dispose();
  }

  void _handleCrown(String optionId) {
    setState(() {
      for (int i = 0; i < _options.length; i++) {
        if (_options[i].isMe) {
          _options[i] = _options[i].copyWith(
            crowns: _options[i].crowns > 0 ? _options[i].crowns - 1 : 0, 
            isMe: false
          );
        }
      }

      final index = _options.indexWhere((opt) => opt.id == optionId);
      if (index != -1) {
        _options[index] = _options[index].copyWith(
          crowns: _options[index].crowns + 1,
          isMe: true,
        );
      }
    });
  }

  void _submitNewOption() {
    if (_newOptionController.text.trim().isEmpty) return;

    setState(() {
      _options.insert(
        0, 
        CrownOptionModel(
          id: DateTime.now().toString(), 
          description: _newOptionController.text.trim(),
          mediaUrl: null, 
          mediaType: CrownMediaType.none,
          crowns: 1, 
          isMe: true,
        ),
      );
      _newOptionController.clear();
      _isAddingOption = false;
    });
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: widget.fullBleed ? EdgeInsets.symmetric(horizontal: 16.w) : EdgeInsets.zero,
      scrollDirection: Axis.horizontal,
      itemCount: _options.length + 1, // +1 for the "Add" button
      itemBuilder: (context, index) {
        if (index == _options.length) {
          // ADD OPTION CARD / BUTTON AT THE END
          return GestureDetector(
            onTap: () => setState(() => _isAddingOption = true),
            child: Container(
              width: 140.w,
              height: 220.h,
              margin: EdgeInsets.only(right: 12.w, bottom: 20.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: widget.themeColor.withValues(alpha: 0.1),
                border: Border.all(
                  color: widget.themeColor.withValues(alpha: 0.3),
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.plus, size: 28.sp, color: widget.themeColor),
                  SizedBox(height: 8.h),
                  Text(
                    "Add Option",
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: widget.themeColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final option = _options[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 20.h),
          child: CrownPollCard(
            option: option,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CrownDetailPage(
                    pollModel: widget.pollModel,
                    option: option,
                    themeColor: widget.themeColor,
                    onCrown: () => _handleCrown(option.id),
                  ),
                ),
              );
            },
            themeColor: widget.themeColor,
            width: 140, // Match updated width
            height: 220, // Match updated height
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── THE CROWN POLL TITLE ──
        Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: ExpandableCrownText(
            text: widget.pollModel.title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        
        // ── THE HORIZONTAL CARDS ──
        SizedBox(
          height: 260.h,
          child: widget.fullBleed 
            ? OverflowBox(
                maxWidth: MediaQuery.of(context).size.width,
                child: _buildListView(),
              )
            : _buildListView(),
        ),


        // ── ADD OPTION INPUT FIELD ──
        if (_isAddingOption)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    // TODO: Open Image Picker
                  },
                  icon: Icon(LucideIcons.imagePlus, color: colorScheme.onSurface.withValues(alpha: 0.6)),
                ),
                Expanded(
                  child: TextField(
                    controller: _newOptionController,
                    autofocus: true,
                    style: TextStyle(fontSize: 14.sp),
                    decoration: InputDecoration(
                      hintText: "Add your option text...",
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(color: widget.themeColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(color: widget.themeColor, width: 2),
                      ),
                    ),
                    onSubmitted: (_) => _submitNewOption(),
                  ),
                ),
                IconButton(
                  onPressed: _submitNewOption,
                  icon: Icon(LucideIcons.send, color: widget.themeColor),
                ),
                IconButton(
                  onPressed: () => setState(() => _isAddingOption = false),
                  icon: Icon(LucideIcons.x, color: colorScheme.onSurface.withValues(alpha: 0.6)),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

