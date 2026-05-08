import 'package:crimchart/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../entities/auth_params.dart';
import '../repositories/auth_repository.dart';

class SignUp {
  final AuthRepository _repository;
  const SignUp(this._repository);

  Future<Either<Failure, UserEntity>> call(SignUpParams params) =>
      _repository.signUp(params);
}











