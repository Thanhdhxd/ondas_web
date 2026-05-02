import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/users/domain/entities/admin_user.dart';
import 'package:ondas_web/features/users/domain/repositories/admin_user_repository.dart';
import 'package:ondas_web/features/users/domain/usecases/ban_admin_user_usecase.dart';

class BanAdminUserUseCaseImpl implements BanAdminUserUseCase {
  final AdminUserRepository _repository;

  const BanAdminUserUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, AdminUser>> call(BanAdminUserParams params) {
    return _repository.banUser(id: params.id, banReason: params.banReason);
  }
}
