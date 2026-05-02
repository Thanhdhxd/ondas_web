import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/users/domain/entities/admin_user.dart';
import 'package:ondas_web/features/users/domain/repositories/admin_user_repository.dart';
import 'package:ondas_web/features/users/domain/usecases/get_admin_users_usecase.dart';

class GetAdminUsersUseCaseImpl implements GetAdminUsersUseCase {
  final AdminUserRepository _repository;

  const GetAdminUsersUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, PageResultDto<AdminUser>>> call(
    GetAdminUsersParams params,
  ) {
    return _repository.getUsers(
      page: params.page,
      size: params.size,
      keyword: params.keyword,
      role: params.role,
      active: params.active,
    );
  }
}
