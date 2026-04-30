import 'package:dio/dio.dart';
import '../errors/exceptions.dart';

/// Converts [DioException] into typed [Exception]s for the data layer.
class NetworkExceptionMapper {
  static Exception fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const NetworkException('Request timed out');

      case DioExceptionType.connectionError:
        return const NetworkException('No internet connection');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = _extractMessage(e.response?.data) ?? 
                        e.message ?? 
                        'Server error';
        if (statusCode == 401) {
          return const AuthException('Session expired. Please log in again.');
        }
        return ServerException(message, statusCode: statusCode);

      case DioExceptionType.cancel:
        return const NetworkException('Request was cancelled');

      default:
        return const NetworkException('Unexpected network error');
    }
  }

  static String? _extractMessage(dynamic data) {
    if (data == null) return null;
    if (data is Map) {
      return data['message']?.toString() ??
             data['error']?.toString() ??
             data['detail']?.toString();
    }
    return data.toString();
  }
}





























