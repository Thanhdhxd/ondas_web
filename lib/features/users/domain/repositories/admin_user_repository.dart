import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/users/domain/entities/admin_user.dart';

abstract class AdminUserRepository {
  Future<Either<Failure, PageResultDto<AdminUser>>> getUsers({
    required int page,
    required int size,
    String? keyword,
    String? role,
    bool? active,
  });

  Future<Either<Failure, AdminUser>> getUser({required String id});

  Future<Either<Failure, AdminUser>> banUser({
    required String id,
    required String banReason,
  });

  Future<Either<Failure, AdminUser>> unbanUser({required String id});
}
