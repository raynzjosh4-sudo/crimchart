import 'package:flutter/material.dart';

class AudioItem extends StatelessWidget {
  final String contentUrl;
  final String? thumbnailUrl;

  const AudioItem({
    super.key,
    required this.contentUrl,
    this.thumbnailUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Stack(
      fit: StackFit.expand,
      children: [
        if (thumbnailUrl != null)
          Image.network(
            thumbnailUrl!,
            fit: BoxFit.cover,
          ),
        Container(
          color: Colors.black.withOpacity(0.4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => Container(
                    width: 4,
                    height: 15.0 + (index % 3 * 10),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}





























