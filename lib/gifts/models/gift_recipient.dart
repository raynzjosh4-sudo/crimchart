import 'package:flutter/material.dart';

/// Represents the target recipient of a gift.
/// Contains the data needed for the animation (avatar key) and other metadata.
class GiftRecipient {
  final String id;
  final String name;
  final String avatarUrl;
  final GlobalKey avatarKey; // Used to find the target position for the animation

  const GiftRecipient({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.avatarKey,
  });
}





























