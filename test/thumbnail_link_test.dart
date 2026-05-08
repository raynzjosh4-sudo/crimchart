import 'package:flutter_test/flutter_test.dart';
import 'package:crimchart/core/models/content_entity.dart';
import 'package:crimchart/features/feed/domain/entities/post_entity.dart';
import 'package:crimchart/features/feed/domain/entities/comment_entity.dart';
import 'package:crimchart/features/feed/utils/content_creation_example.dart';

void main() {
  group('ThumbnailLink System Tests', () {
    test('Original ThumbnailLink creation', () {
      final link = ThumbnailLink.original(
        contentId: 'post_123',
        authorId: 'user_1',
        authorUsername: 'alice',
        contentType: 'post',
      );

      expect(link.originalContentId, 'post_123');
      expect(link.originalAuthorId, 'user_1');
      expect(link.originalAuthorUsername, 'alice');
      expect(link.linkDepth, 0);
      expect(link.linkChain, ['post_123']);
      expect(link.isOriginal, true);
    });

    test('ThumbnailLink from parent', () {
      final originalLink = ThumbnailLink.original(
        contentId: 'post_123',
        authorId: 'user_1',
        authorUsername: 'alice',
      );

      final childLink = ThumbnailLink.fromParent(
        newContentId: 'comment_456',
        parentLink: originalLink,
      );

      expect(childLink.originalContentId, 'post_123');
      expect(childLink.linkDepth, 1);
      expect(childLink.linkChain, ['post_123', 'comment_456']);
      expect(childLink.isOriginal, false);
    });

    test('PostEntity with ThumbnailLink', () {
      final post = PostEntity.original(
        id: 'post_123',
        authorId: 'user_1',
        authorUsername: 'alice',
        authorDisplayName: 'Alice Johnson',
        createdAt: DateTime.now(),
        channelId: 'channel_tech',
        channelName: 'Tech Discussions',
        caption: 'Hello world!',
      );

      expect(post.id, 'post_123');
      expect(post.thumbnailLink.isOriginal, true);
      expect(post.thumbnailLink.linkDepth, 0);
    });

    test('CommentEntity with ThumbnailLink', () {
      final post = PostEntity.original(
        id: 'post_123',
        authorId: 'user_1',
        authorUsername: 'alice',
        authorDisplayName: 'Alice Johnson',
        createdAt: DateTime.now(),
        channelId: 'channel_tech',
        channelName: 'Tech Discussions',
        caption: 'Hello world!',
      );

      final comment = CommentEntity.original(
        id: 'comment_456',
        authorId: 'user_2',
        authorUsername: 'bob',
        authorDisplayName: 'Bob Smith',
        createdAt: DateTime.now(),
        contentLink: post.thumbnailLink,
        text: 'Great post!',
      );

      expect(comment.thumbnailLink.isOriginal, false);
      expect(comment.thumbnailLink.linkDepth, 1);
      expect(comment.thumbnailLink.originalContentId, 'post_123');
    });

    test('Content chain creation', () {
      final chain = ContentCreationExample.createContentChain();

      expect(chain.length, 5); // post, comment, reply, message, reshare

      // Check that all content in chain shares the same root
      final rootId = chain.first.thumbnailLink.originalContentId;
      for (final content in chain) {
        expect(content.thumbnailLink.originalContentId, rootId);
      }

      // Check link depths
      expect(chain[0].thumbnailLink.linkDepth, 0); // original post
      expect(chain[1].thumbnailLink.linkDepth, 1); // comment
      expect(chain[2].thumbnailLink.linkDepth, 2); // reply
      expect(chain[3].thumbnailLink.linkDepth, 1); // message share
      expect(chain[4].thumbnailLink.linkDepth, 1); // reshare
    });
  });
}



