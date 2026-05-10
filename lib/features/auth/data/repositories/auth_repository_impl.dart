import 'package:flutter/foundation.dart';
import 'package:crimchart/core/errors/exceptions.dart';
import 'package:crimchart/core/errors/failures.dart';
import 'package:crimchart/features/auth/domain/entities/auth_params.dart';
import 'package:crimchart/features/auth/domain/entities/user_entity.dart';
import 'package:crimchart/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;

import '../sources/auth_remote_source.dart';
import '../sources/auth_local_source.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteSource _remote;
  final AuthLocalSource _local;

  AuthRepositoryImpl(this._remote, this._local);

  @override
  Future<Either<Failure, UserEntity>> signUp(SignUpParams params) async {
    try {
      final result = await _remote.signUp(params);
      // Persist entire session securely in Native C++ DB
      await _local.saveUser(
        result.user,
        accessToken: result.tokens.accessToken,
        refreshToken: result.tokens.refreshToken,
      );
      return Right(result.user);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login(LoginParams params) async {
    try {
      final result = await _remote.login(params);
      await _local.saveUser(
        result.user,
        accessToken: result.tokens.accessToken,
        refreshToken: result.tokens.refreshToken,
      );
      return Right(result.user);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithGoogle() async {
    try {
      const googleToken = 'GOOGLE_OAUTH_TOKEN';
      final result = await _remote.loginWithGoogle(googleToken);
      await _local.saveUser(
        result.user,
        accessToken: result.tokens.accessToken,
        refreshToken: result.tokens.refreshToken,
      );
      return Right(result.user);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      // 👑 We use SignOutScope.local to clear Supabase's local cache
      // WITHOUT hitting the remote endpoint. If we hit the remote endpoint,
      // Supabase revokes the refresh token, breaking our "Switch Accounts" functionality!
      try {
        await Supabase.instance.client.auth.signOut(scope: SignOutScope.local);
      } catch (_) {
        // Fallback or ignore if local scope fails
      }
      await _local.clearAll();
      return const Right(null);
    } catch (_) {
      await _local.clearAll();
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> refreshToken() async {
    try {
      final stored = await _local.getTokens();
      if (stored == null || stored['refresh'] == null) {
        return const Left(UnauthorizedFailure());
      }

      final newTokens = await _remote.refreshToken(stored['refresh']!);
      final user = await _local.getUser();
      if (user != null) {
        await _local.saveUser(
          user,
          accessToken: newTokens.accessToken,
          refreshToken: newTokens.refreshToken,
        );
      }
      return Right(newTokens);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnauthorizedFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> checkUsernameAvailable(String username) async {
    try {
      final available = await _remote.checkUsernameAvailable(username);
      return Right(available);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      // 1. Get user from Native C++ DB
      final user = await _local.getUser();
      if (user == null) return const Right(null);

      // 2. 👑 SESSION SYNC: If Supabase has no session, restore it from Native tokens
      final supabase = Supabase.instance.client;
      if (supabase.auth.currentSession == null) {
        final tokens = await _local.getTokens();
        if (tokens != null && tokens['refresh'] != null) {
          debugPrint(
            '🔄 [AuthRepo] Restoring Supabase session from Native C++ DB (using Refresh Token)...',
          );
          try {
            await supabase.auth.setSession(tokens['refresh']!);
            debugPrint('✅ [AuthRepo] Supabase session restored via refresh token!');
          } catch (e) {
            debugPrint('⚠️ [AuthRepo] Session restoration failed: $e');
            await _local.clearAll();
            return const Right(null);
          }
        } else if (tokens != null && tokens['access'] != null) {
          debugPrint('🔄 [AuthRepo] Attempting session restore via Access Token...');
          try {
            await supabase.auth.setSession(tokens['access']!);
            debugPrint('✅ [AuthRepo] Supabase session restored via access token!');
          } catch (e) {
            debugPrint('⚠️ [AuthRepo] Access token restoration failed: $e');
            await _local.clearAll();
            return const Right(null);
          }
        }
      }

      return Right(user);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> persistSession(AuthTokens tokens) async {
    // Tokens are now persisted atomically during signUp/login in the Native DB
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> clearSession() async {
    await _local.clearAll();
    return const Right(null);
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile(
    Map<String, dynamic> updates,
  ) async {
    try {
      final updatedUser = await _remote.updateProfile(updates);
      // Update local cache
      await _local.saveUser(updatedUser);
      return Right(updatedUser);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
