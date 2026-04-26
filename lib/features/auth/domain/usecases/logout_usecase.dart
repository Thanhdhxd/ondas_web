import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ondas_web/core/error/failures.dart';

abstract class LogoutUseCase {
  Future<Either<Failure, void>> call(LogoutParams params);
}

class LogoutParams extends Equatable {
  final String refreshToken;

  const LogoutParams({required this.refreshToken});

  @override
  List<Object?> get props => [refreshToken];
}
