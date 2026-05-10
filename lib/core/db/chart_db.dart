import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart' hide Table;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:injectable/injectable.dart';

import 'tables/users.dart';
import 'tables/posts.dart';
import 'tables/manifestos.dart';
import 'tables/manifesto_comments.dart';
import 'tables/channel/channel.dart';
import 'tables/channel/channel_metadata.dart';
import 'tables/channel/channel_branding.dart';
import 'tables/channel/channel_members.dart';
import 'tables/channel/channel_statuses.dart';
import 'tables/channel/channel_presence.dart';
import 'tables/channel/channel_creator.dart';
import 'tables/channel/channel_posts.dart';
import 'tables/channel/channel_post_tags.dart';
import 'tables/channel/channel_content_tags.dart';
import 'tables/channel/channel_post_comments.dart';
import 'tables/channel/channel_messages.dart';
import 'tables/channel/common_channels.dart';
import 'tables/channel/channel_moments.dart';

import 'tables/channel/channel_invitations.dart';
import 'tables/channel/channel_polls.dart';
import 'tables/channel/channel_poll_options.dart';
import 'tables/channel/channel_gifts.dart';

part 'chart_db.g.dart';

@DriftDatabase(
  tables: [
    Users,
    Posts,
    Manifestos,
    ManifestoComments,
    Channels,
    ChannelMetadata,
    ChannelBranding,
    ChannelMembers,
    ChannelStatuses,
    ChannelPresence,
    ChannelCreator,
    ChannelPosts,
    ChannelPostTags,
    ChannelContentTags,
    ChannelPostComments,
    ChannelMessages,
    CommonChannels,
    ChannelMoments,
    ChannelInvitations,
    ChannelPolls,
    ChannelPollOptions,
    ChannelGifts,
  ],
)
@lazySingleton
class ChartDatabase extends _$ChartDatabase {
  ChartDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 21;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        debugPrint('🛠️ [Drift] Migrating from $from to $to...');

        if (from < 21) {
          debugPrint('👑 [Drift] Adding unread_moments_count to channel_members (Version 21)...');
          // Add column to channel_members
          await customStatement('ALTER TABLE channel_members ADD COLUMN unread_moments_count INTEGER DEFAULT 0');
        }

        if (from < 20) {
          debugPrint('👑 [Drift] Adding Tagging Metadata columns (Version 20)...');
          await customStatement('ALTER TABLE manifestos ADD COLUMN tagger_name TEXT');
          await customStatement('ALTER TABLE manifestos ADD COLUMN tagger_avatar TEXT');
          await customStatement('ALTER TABLE manifestos ADD COLUMN source_channel_name TEXT');
          await customStatement('ALTER TABLE manifestos ADD COLUMN source_channel_avatar TEXT');
          await customStatement('ALTER TABLE manifestos ADD COLUMN tags_count INTEGER DEFAULT 0');
          await customStatement('ALTER TABLE manifestos ADD COLUMN metadata TEXT');

          await customStatement('ALTER TABLE posts ADD COLUMN tagger_name TEXT');
          await customStatement('ALTER TABLE posts ADD COLUMN tagger_avatar TEXT');
          await customStatement('ALTER TABLE posts ADD COLUMN source_channel_name TEXT');
          await customStatement('ALTER TABLE posts ADD COLUMN source_channel_avatar TEXT');
          await customStatement('ALTER TABLE posts ADD COLUMN tags_count INTEGER DEFAULT 0');
          await customStatement('ALTER TABLE posts ADD COLUMN metadata TEXT');

          await customStatement('ALTER TABLE channel_posts ADD COLUMN tagger_name TEXT');
          await customStatement('ALTER TABLE channel_posts ADD COLUMN tagger_avatar TEXT');
          await customStatement('ALTER TABLE channel_posts ADD COLUMN source_channel_name TEXT');
          await customStatement('ALTER TABLE channel_posts ADD COLUMN source_channel_avatar TEXT');
          await customStatement('ALTER TABLE channel_posts ADD COLUMN tags_count INTEGER DEFAULT 0');
        }

        if (from < 19) {
          debugPrint('👑 [Drift] Adding ChannelContentTags table (Version 19)...');
          await m.createTable(channelContentTags);
        }

        if (from < 18) {
          debugPrint('👑 [Drift] Adding thumbnail_url to channel_messages (Version 18)...');
          await customStatement('ALTER TABLE channel_messages ADD COLUMN thumbnail_url TEXT');
        }

        if (from < 17) {
          debugPrint('👑 [Drift] Adding thumbnail_url to channel_statuses (Version 17)...');
          await customStatement('ALTER TABLE channel_statuses ADD COLUMN thumbnail_url TEXT');
        }

        if (from < 16) {
          debugPrint('👑 [Drift] Adding likes_count to channels (Version 16)...');
          await customStatement('ALTER TABLE channels ADD COLUMN likes_count INTEGER DEFAULT 0');
        }

        if (from < 15) {
          debugPrint('👑 [Drift] Adding tags_count to channels (Version 15)...');
          await customStatement('ALTER TABLE channels ADD COLUMN tags_count INTEGER DEFAULT 0');
        }

        if (from < 14) {
          debugPrint('👑 [Drift] Adding new discovery columns to channels (Version 14)...');
          await customStatement('ALTER TABLE channels ADD COLUMN is_discoverable INTEGER DEFAULT 1');
          await customStatement('ALTER TABLE channels ADD COLUMN members_count INTEGER DEFAULT 1');
          await customStatement('ALTER TABLE channels ADD COLUMN followers_count INTEGER DEFAULT 0');
        }

        if (from < 13) {
          debugPrint('👑 [Drift] Recreating channel_moments table (Version 13)...');
          await m.drop(channelMoments).catchError((_) {});
          await m.createTable(channelMoments);
        }

        if (from < 10) {
          await customStatement('ALTER TABLE channels ADD COLUMN allow_invitations_by TEXT DEFAULT "all"');
        }

        if (from < 9) {
          await m.createTable(channelGifts);
        }

        if (from < 8) {
          await customStatement('ALTER TABLE channel_messages ADD COLUMN message_type TEXT DEFAULT "text"');
          await customStatement('ALTER TABLE channel_messages ADD COLUMN metadata TEXT');
          await m.createTable(channelPolls);
          await m.createTable(channelPollOptions);
        }

        if (from < 7) {
          await customStatement('ALTER TABLE channel_posts ADD COLUMN post_type TEXT DEFAULT "post"');
          await customStatement('ALTER TABLE channel_posts ADD COLUMN metadata TEXT');
        }

        if (from < 6) {
          for (final table in allTables) {
            await m.drop(table).catchError((_) {});
          }
          await m.createAll();
        }
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'chart_drift.db'));
      return NativeDatabase(file);
    });
  }
}
