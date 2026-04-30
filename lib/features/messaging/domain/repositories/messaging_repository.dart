import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/message_entity.dart';

/// Contract for the Messaging data layer.
abstract class MessagingRepository {
  /// Get all conversation threads for the current user.
  Future<Either<Failure, List<ThreadEntity>>> getThreads();

  /// Get messages in a thread with pagination.
  Future<Either<Failure, List<MessageEntity>>> getMessages(
    String threadId, {
    int page = 1,
  });

  /// Send a message in a thread. Returns the sent message.
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String threadId,
    required String text,
    MessageType type = MessageType.text,
    String? mediaUrl,
  });

  /// Mark all messages in a thread as read.
  Future<Either<Failure, void>> markThreadRead(String threadId);

  /// Start a new thread with a user.
  Future<Either<Failure, ThreadEntity>> startThread(String recipientId);

  /// Stream of real-time incoming messages (WebSocket).
  Stream<MessageEntity> get incomingMessages;
}





























