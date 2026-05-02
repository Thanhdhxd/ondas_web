import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/users/domain/entities/admin_user.dart';
import 'package:ondas_web/features/users/domain/repositories/admin_user_repository.dart';
import 'package:ondas_web/features/users/domain/usecases/get_admin_user_usecase.dart';

class GetAdminUserUseCaseImpl implements GetAdminUserUseCase {
  final AdminUserRepository _repository;

  const GetAdminUserUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, AdminUser>> call(GetAdminUserParams params) {
    return _repository.getUser(id: params.id);
  }
}
