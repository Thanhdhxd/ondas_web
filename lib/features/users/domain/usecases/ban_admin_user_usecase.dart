import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/users/domain/entities/admin_user.dart';

abstract class BanAdminUserUseCase {
  Future<Either<Failure, AdminUser>> call(BanAdminUserParams params);
}

class BanAdminUserParams extends Equatable {
  final String id;
  final String banReason;

  const BanAdminUserParams({required this.id, required this.banReason});

  @override
  List<Object?> get props => [id, banReason];
}
