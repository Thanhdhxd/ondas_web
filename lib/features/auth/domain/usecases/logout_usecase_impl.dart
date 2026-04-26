import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/auth/domain/repositories/auth_repository.dart';
import 'package:ondas_web/features/auth/domain/usecases/logout_usecase.dart';

class LogoutUseCaseImpl implements LogoutUseCase {
  final AuthRepository _repository;

  const LogoutUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, void>> call(LogoutParams params) {
    return _repository.logout(refreshToken: params.refreshToken);
  }
}
