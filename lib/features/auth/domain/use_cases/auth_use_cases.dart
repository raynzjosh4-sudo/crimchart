import 'package:crown/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginWithGoogle {
  final AuthRepository _repository;
  const LoginWithGoogle(this._repository);

  Future<Either<Failure, UserEntity>> call() => _repository.loginWithGoogle();
}

class SignOut {
  final AuthRepository _repository;
  const SignOut(this._repository);

  Future<Either<Failure, void>> call() => _repository.signOut();
}

class GetCurrentUser {
  final AuthRepository _repository;
  const GetCurrentUser(this._repository);

  Future<Either<Failure, UserEntity?>> call() => _repository.getCurrentUser();
}

class CheckUsernameAvailable {
  final AuthRepository _repository;
  const CheckUsernameAvailable(this._repository);

  Future<Either<Failure, bool>> call(String username) =>
      _repository.checkUsernameAvailable(username);
}











