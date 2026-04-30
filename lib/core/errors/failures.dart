// Core error types used across all layers.
// All failures extend [Failure] — the domain layer never throws exceptions.

abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

// Network failures
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Request timed out']);
}

// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed']);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Session expired. Please log in again.']);
}

// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

// Cache/local storage failures
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local storage error']);
}

// Media failures
class MediaFailure extends Failure {
  const MediaFailure([super.message = 'Media processing failed']);
}

// Unexpected failures
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred']);
}





























