import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/users/domain/entities/admin_user.dart';

abstract class GetAdminUsersUseCase {
  Future<Either<Failure, PageResultDto<AdminUser>>> call(
    GetAdminUsersParams params,
  );
}

class GetAdminUsersParams extends Equatable {
  final int page;
  final int size;
  final String? keyword;
  final String? role;
  final bool? active;

  const GetAdminUsersParams({
    required this.page,
    required this.size,
    this.keyword,
    this.role,
    this.active,
  });

  @override
  List<Object?> get props => [page, size, keyword, role, active];
}
