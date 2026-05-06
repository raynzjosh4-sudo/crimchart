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
  int get schemaVersion => 16;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        debugPrint('🛠️ [Drift] Migrating from $from to $to...');
        if (from < 6) {
          // 👑 FAIL-SAFE: Re-create all tables to ensure the new Invitations table is present
          for (final table in allTables) {
            await m.drop(table).catchError((_) {});
          }
          await m.createAll();
        } else if (from < 7) {
          // 👑 CROSS-CHANNEL INVITATIONS: Add new columns via Raw SQL to avoid type errors with non-generated code
          await customStatement(
            'ALTER TABLE channel_posts ADD COLUMN post_type TEXT DEFAULT "post"',
          );
          await customStatement(
            'ALTER TABLE channel_posts ADD COLUMN metadata TEXT',
          );
        }

        if (from < 8) {
          // 👑 COMMUNITY POLLS: Add columns to messages and create new tables
          await customStatement(
            'ALTER TABLE channel_messages ADD COLUMN message_type TEXT DEFAULT "text"',
          );
          await customStatement(
            'ALTER TABLE channel_messages ADD COLUMN metadata TEXT',
          );

          await m.createTable(channelPolls);
          await m.createTable(channelPollOptions);
        }

        if (from < 9) {
          // 👑 CHANNEL GIFTS: Create the table and link to messages
          await m.createTable(channelGifts);
        }

        if (from < 10) {
          await customStatement(
            'ALTER TABLE channels ADD COLUMN allow_invitations_by TEXT DEFAULT "all"',
          );
        }

        if (from < 13) {
          debugPrint(
            '👑 [Drift] Recreating channel_moments table for Version 13 (Author Info)...',
          );
          // 👑 Migration: Aggressively recreate channel_moments to ensure author info columns are added
          await m.drop(channelMoments).catchError((e) {
            debugPrint('⚠️ [Drift] Drop failed (probably non-existent): $e');
          });
          await m.createTable(channelMoments);
          debugPrint('✅ [Drift] channel_moments recreated successfully!');
        }

        if (from < 14) {
          debugPrint('👑 [Drift] Adding new discovery columns to channels (Version 14)...');
          await customStatement('ALTER TABLE channels ADD COLUMN is_discoverable INTEGER DEFAULT 1');
          await customStatement('ALTER TABLE channels ADD COLUMN members_count INTEGER DEFAULT 1');
          await customStatement('ALTER TABLE channels ADD COLUMN followers_count INTEGER DEFAULT 0');
        }

        if (from < 15) {
          debugPrint('👑 [Drift] Adding tags_count to channels (Version 15)...');
          await customStatement('ALTER TABLE channels ADD COLUMN tags_count INTEGER DEFAULT 0');
        }

        if (from < 16) {
          debugPrint('👑 [Drift] Adding likes_count to channels (Version 16)...');
          await customStatement('ALTER TABLE channels ADD COLUMN likes_count INTEGER DEFAULT 0');
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
