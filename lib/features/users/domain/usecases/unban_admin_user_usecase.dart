import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/users/domain/entities/admin_user.dart';

abstract class UnbanAdminUserUseCase {
  Future<Either<Failure, AdminUser>> call(UnbanAdminUserParams params);
}

class UnbanAdminUserParams extends Equatable {
  final String id;

  const UnbanAdminUserParams({required this.id});

  @override
  List<Object?> get props => [id];
}
