import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({required super.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure()
      : super(message: 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.');
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure()
      : super(message: 'Bạn không có quyền thực hiện thao tác này.');
}

class InsufficientRoleFailure extends Failure {
  const InsufficientRoleFailure()
      : super(
          message:
              'Tài khoản của bạn không có quyền truy cập hệ thống quản trị.',
        );
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}
