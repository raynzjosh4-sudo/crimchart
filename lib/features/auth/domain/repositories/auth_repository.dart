import 'package:crimchart/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../entities/auth_params.dart';

/// Contract for the Auth data layer.
abstract class AuthRepository {
  /// Register a new account. Returns the created user on success.
  Future<Either<Failure, UserEntity>> signUp(SignUpParams params);

  /// Login with phone/username + password.
  Future<Either<Failure, UserEntity>> login(LoginParams params);

  /// Login with Google OAuth.
  Future<Either<Failure, UserEntity>> loginWithGoogle();

  /// Sign out — clears tokens and session.
  Future<Either<Failure, void>> signOut();

  /// Refresh the access token if expired.
  Future<Either<Failure, AuthTokens>> refreshToken();

  /// Check if a username is available (for real-time validation).
  Future<Either<Failure, bool>> checkUsernameAvailable(String username);

  /// Returns the currently authenticated user, or null if not logged in.
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  /// Persists a session so the user stays logged in on restart.
  Future<Either<Failure, void>> persistSession(AuthTokens tokens);

  /// Clears the persisted session.
  Future<Either<Failure, void>> clearSession();

  /// Update an existing user's profile data.
  Future<Either<Failure, UserEntity>> updateProfile(
    Map<String, dynamic> updates,
  );
}











