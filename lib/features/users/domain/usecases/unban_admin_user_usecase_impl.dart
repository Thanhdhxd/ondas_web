import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/users/domain/entities/admin_user.dart';
import 'package:ondas_web/features/users/domain/repositories/admin_user_repository.dart';
import 'package:ondas_web/features/users/domain/usecases/unban_admin_user_usecase.dart';

class UnbanAdminUserUseCaseImpl implements UnbanAdminUserUseCase {
  final AdminUserRepository _repository;

  const UnbanAdminUserUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, AdminUser>> call(UnbanAdminUserParams params) {
    return _repository.unbanUser(id: params.id);
  }
}
