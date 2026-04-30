// Exception types thrown in the DATA layer only.
// These get caught and converted to Failure objects before reaching the domain layer.

class ServerException implements Exception {
  final String message;
  final int? statusCode;
  const ServerException(this.message, {this.statusCode});

  @override
  String toString() => 'ServerException: $message';
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'No internet connection']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Local storage error']);
}

class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'Authentication error']);
}

class MediaException implements Exception {
  final String message;
  const MediaException([this.message = 'Media processing error']);
}





























