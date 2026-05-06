import 'package:drift/drift.dart';
import '../chart_db.dart';

/// Utility to seed the modular channel tables with dummy data.
class ChannelDatabaseSeeder {
  static Future<void> seed(ChartDatabase db) async {
    const channelId = 'dubai-jobs-channel';
    const creatorId = 'lion-wifi-id';

    // 1. Seed Main Channel
    await db
        .into(db.channels)
        .insertOnConflictUpdate(
          const ChannelsCompanion(
            id: Value(channelId),
            name: Value('Dubai Jobs'),
            title: Value('lion wifi'),
            subtitle: Value('Senior Flutter Developers wanted'),
            imageUrl: Value('https://placeholder.com/lion.png'),
          ),
        );

    // 2. Seed Metadata & Badges
    await db
        .into(db.channelMetadata)
        .insertOnConflictUpdate(
          const ChannelMetadataCompanion(
            channelId: Value(channelId),
            memberCount: Value(3200),
            postsBadgeCount: Value(15),
            membersBadgeCount: Value(6),
            messagesBadgeCount: Value(3),
          ),
        );

    // 3. Seed Creator Info
    await db
        .into(db.channelCreator)
        .insertOnConflictUpdate(
          const ChannelCreatorCompanion(
            channelId: Value(channelId),
            creatorId: Value(creatorId),
            name: Value('lion wifi'),
            isVerified: Value(1),
            isFollowing: Value(0),
            roleTitle: Value('Channel Creator'),
          ),
        );

    // 4. Seed a Sponsored Post
    await db
        .into(db.channelPosts)
        .insertOnConflictUpdate(
          const ChannelPostsCompanion(
            id: Value('post-honor-200'),
            channelId: Value(channelId),
            authorId: Value('honor-mobile-id'),
            caption: Value('Experience the new Honor 200 PRO 5G. Shop now!'),
            isSponsored: Value(1),
            likes: Value(3400),
            comments: Value(156),
            imageUrls: Value('["https://placeholder.com/honor.png"]'),
          ),
        );

    // 5. Seed a Chat Message
    await db
        .into(db.channelMessages)
        .insertOnConflictUpdate(
          const ChannelMessagesCompanion(
            id: Value('msg-1'),
            channelId: Value(channelId),
            senderId: Value('member-camilla'),
            textContent: Value(
              'Hey everyone! Welcome to the Dubai job channel.',
            ),
            createdAt: Value('10:30 AM'),
          ),
        );
  }
}
