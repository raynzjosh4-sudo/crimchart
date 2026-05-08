import 'package:crimchart/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../entities/auth_params.dart';
import '../repositories/auth_repository.dart';

class Login {
  final AuthRepository _repository;
  const Login(this._repository);

  Future<Either<Failure, UserEntity>> call(LoginParams params) =>
      _repository.login(params);
}











