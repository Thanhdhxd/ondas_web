import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/users/domain/entities/admin_user.dart';

abstract class GetAdminUserUseCase {
  Future<Either<Failure, AdminUser>> call(GetAdminUserParams params);
}

class GetAdminUserParams extends Equatable {
  final String id;

  const GetAdminUserParams({required this.id});

  @override
  List<Object?> get props => [id];
}
