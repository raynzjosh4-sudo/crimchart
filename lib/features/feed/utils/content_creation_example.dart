import 'package:crimchart/core/models/content_entity.dart';
import 'package:crimchart/features/feed/domain/entities/comment_entity.dart';
import 'package:crimchart/features/feed/domain/entities/post_entity.dart';
import 'package:crimchart/features/messaging/domain/entities/message_entity.dart';

/// Utility class demonstrating how to create content with ThumbnailLinks.
/// This shows the complete flow of content creation and linTop.
class ContentCreationExample {
  /// Example: Creating an original post
  static PostEntity createOriginalPost({
    required String authorId,
    required String authorUsername,
    required String authorDisplayName,
    required String channelId,
    required String channelName,
    required String caption,
  }) {
    return PostEntity.original(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      authorId: authorId,
      authorUsername: authorUsername,
      authorDisplayName: authorDisplayName,
      createdAt: DateTime.now(),
      channelId: channelId,
      channelName: channelName,
      caption: caption,
    );
  }

  /// Example: Creating a comment on a post
  static CommentEntity createCommentOnPost({
    required String authorId,
    required String authorUsername,
    required String authorDisplayName,
    required PostEntity originalPost,
    required String commentText,
  }) {
    return CommentEntity.original(
      id: 'comment_${DateTime.now().millisecondsSinceEpoch}',
      authorId: authorId,
      authorUsername: authorUsername,
      authorDisplayName: authorDisplayName,
      createdAt: DateTime.now(),
      contentLink: originalPost.thumbnailLink,
      text: commentText,
    );
  }

  /// Example: Creating a reply to a comment
  static CommentEntity createReplyToComment({
    required String authorId,
    required String authorUsername,
    required String authorDisplayName,
    required CommentEntity parentComment,
    required String replyText,
  }) {
    return CommentEntity.reply(
      id: 'reply_${DateTime.now().millisecondsSinceEpoch}',
      authorId: authorId,
      authorUsername: authorUsername,
      authorDisplayName: authorDisplayName,
      createdAt: DateTime.now(),
      parentCommentLink: parentComment.thumbnailLink,
      text: replyText,
      parentCommentId: parentComment.id,
    );
  }

  /// Example: Sharing a post in a message
  static MessageEntity createPostShareMessage({
    required String senderId,
    required String senderUsername,
    required String senderDisplayName,
    required String threadId,
    required PostEntity postToShare,
    String? additionalText,
  }) {
    return MessageEntity.share(
      id: 'message_${DateTime.now().millisecondsSinceEpoch}',
      threadId: threadId,
      senderId: senderId,
      senderUsername: senderUsername,
      senderDisplayName: senderDisplayName,
      sentAt: DateTime.now(),
      sharedContentLink: postToShare.thumbnailLink,
      text: additionalText,
    );
  }

  /// Example: Creating a post that references another post (reshare)
  static PostEntity createResharePost({
    required String authorId,
    required String authorUsername,
    required String authorDisplayName,
    required PostEntity originalPost,
    required String channelId,
    required String channelName,
    String? additionalCaption,
  }) {
    return PostEntity.fromParent(
      id: 'reshare_${DateTime.now().millisecondsSinceEpoch}',
      authorId: authorId,
      authorUsername: authorUsername,
      authorDisplayName: authorDisplayName,
      createdAt: DateTime.now(),
      parentLink: originalPost.thumbnailLink,
      channelId: channelId,
      channelName: channelName,
      caption:
          additionalCaption ?? 'Shared from @${originalPost.authorUsername}',
    );
  }

  /// Demonstrates a complete content chain
  static List<ContentEntity> createContentChain() {
    // 1. Create original post
    final originalPost = createOriginalPost(
      authorId: 'user_1',
      authorUsername: 'alice',
      authorDisplayName: 'Alice Johnson',
      channelId: 'channel_tech',
      channelName: 'Tech Discussions',
      caption: 'Just discovered an amazing new Flutter feature!',
    );

    // 2. Create comment on the post
    final comment = createCommentOnPost(
      authorId: 'user_2',
      authorUsername: 'bob',
      authorDisplayName: 'Bob Smith',
      originalPost: originalPost,
      commentText: 'This is so cool! Can you share more details?',
    );

    // 3. Create reply to the comment
    final reply = createReplyToComment(
      authorId: 'user_1',
      authorUsername: 'alice',
      authorDisplayName: 'Alice Johnson',
      parentComment: comment,
      replyText:
          'Sure! It\'s the new ThumbnailLink system for content tracTop.',
    );

    // 4. Share the original post in a message
    final message = createPostShareMessage(
      senderId: 'user_3',
      senderUsername: 'charlie',
      senderDisplayName: 'Charlie Brown',
      threadId: 'thread_friends',
      postToShare: originalPost,
      additionalText: 'Check out this amazing post!',
    );

    // 5. Create a reshare post
    final reshare = createResharePost(
      authorId: 'user_4',
      authorUsername: 'diana',
      authorDisplayName: 'Diana Prince',
      originalPost: originalPost,
      channelId: 'channel_news',
      channelName: 'News Feed',
      additionalCaption: 'Everyone should see this! #Flutter',
    );

    return [originalPost, comment, reply, message, reshare];
  }

  /// Utility to trace content lineage
  static void printContentLineage(ContentEntity content) {
    print('Content ID: ${content.id}');
    print('Author: @${content.authorUsername}');
    print('Created: ${content.createdAt}');
    print('Thumbnail Link:');
    print(
      '  - Original Content ID: ${content.thumbnailLink.originalContentId}',
    );
    print(
      '  - Original Author: @${content.thumbnailLink.originalAuthorUsername}',
    );
    print('  - Link Depth: ${content.thumbnailLink.linkDepth}');
    print('  - Link Chain: ${content.thumbnailLink.linkChain.join(' → ')}');
    print('  - Is Original: ${content.thumbnailLink.isOriginal}');
    print('');
  }

  /// Demonstrates how to find the root content from any linked content
  static ContentEntity? findRootContent(
    ContentEntity content,
    List<ContentEntity> allContent,
  ) {
    final rootId = content.thumbnailLink.originalContentId;
    return allContent.where((c) => c.id == rootId).firstOrNull;
  }

  /// Gets all content in the same lineage chain
  static List<ContentEntity> getContentChain(
    ContentEntity content,
    List<ContentEntity> allContent,
  ) {
    final rootId = content.thumbnailLink.originalContentId;
    return allContent
        .where((c) => c.thumbnailLink.originalContentId == rootId)
        .toList();
  }
}











