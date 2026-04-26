import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/auth/domain/entities/auth_response.dart';
import 'package:ondas_web/features/auth/domain/repositories/auth_repository.dart';
import 'package:ondas_web/features/auth/domain/usecases/login_usecase.dart';

class LoginUseCaseImpl implements LoginUseCase {
  final AuthRepository _repository;

  const LoginUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, AuthResponse>> call(LoginParams params) {
    return _repository.login(email: params.email, password: params.password);
  }
}
