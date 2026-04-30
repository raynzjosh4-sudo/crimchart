import 'package:flutter/material.dart';

class ChannelName extends StatefulWidget {
  final String text;
  final double firstPartFontSize;
  final double secondPartFontSize;
  final EdgeInsetsGeometry padding;
  final Color? color;

  const ChannelName({
    super.key,
    this.text = 'Channel name of the contestors and the',
    this.firstPartFontSize = 24.0,
    this.secondPartFontSize = 16.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    this.color,
  });

  @override
  State<ChannelName> createState() => _ChannelNameState();
}

class _ChannelNameState extends State<ChannelName> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final effectiveColor1 = widget.color ?? onSurface;
    final effectiveColor2 = widget.color ?? onSurface.withValues(alpha: 0.7);

    // Split the text into two halves roughly based on words
    final words = widget.text.split(' ');
    final middle = (words.length / 2).ceil();
    final firstPart = words.sublist(0, middle).join(' ');
    final secondPart = words.sublist(middle).join(' ');

    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Padding(
        padding: widget.padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              firstPart,
              style: TextStyle(
                fontSize: widget.firstPartFontSize,
                fontWeight: FontWeight.bold,
                color: effectiveColor1,
              ),
              textAlign: TextAlign.center,
              maxLines: _isExpanded ? null : 1,
              overflow: _isExpanded ? null : TextOverflow.ellipsis,
            ),
            if (secondPart.isNotEmpty)
              Text(
                secondPart,
                style: TextStyle(
                  fontSize: widget.secondPartFontSize,
                  fontWeight: FontWeight.w600,
                  color: effectiveColor2,
                ),
                textAlign: TextAlign.center,
                maxLines: _isExpanded ? null : 1,
                overflow: _isExpanded ? null : TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}





























