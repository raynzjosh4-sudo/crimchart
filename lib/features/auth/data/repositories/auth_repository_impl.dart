import 'package:crown/core/errors/exceptions.dart';
import 'package:crown/core/errors/failures.dart';
import 'package:crown/features/auth/domain/entities/auth_params.dart';
import 'package:crown/features/auth/domain/entities/user_entity.dart';
import 'package:crown/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

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
      final tokens = await _local.getTokens();
      if (tokens != null && tokens['access'] != null) {
        await _remote.signOut(tokens['access']!);
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
      // Return cached user — no network call needed for this
      final user = await _local.getUser();
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











