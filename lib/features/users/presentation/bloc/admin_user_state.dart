import 'package:equatable/equatable.dart';
import 'package:ondas_web/features/users/domain/entities/admin_user.dart';

abstract class AdminUserState extends Equatable {
  const AdminUserState();

  @override
  List<Object?> get props => [];
}

class AdminUserInitial extends AdminUserState {
  const AdminUserInitial();
}

class AdminUserListLoading extends AdminUserState {
  const AdminUserListLoading();
}

class AdminUserListLoaded extends AdminUserState {
  final List<AdminUser> users;
  final int page;
  final int totalPages;
  final int totalElements;
  final String? keyword;
  final String? role;
  final bool? active;

  const AdminUserListLoaded({
    required this.users,
    required this.page,
    required this.totalPages,
    required this.totalElements,
    this.keyword,
    this.role,
    this.active,
  });

  @override
  List<Object?> get props => [
    users,
    page,
    totalPages,
    totalElements,
    keyword,
    role,
    active,
  ];
}

class AdminUserListError extends AdminUserState {
  final String message;

  const AdminUserListError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AdminUserDetailLoading extends AdminUserState {
  const AdminUserDetailLoading();
}

class AdminUserDetailLoaded extends AdminUserState {
  final AdminUser user;

  const AdminUserDetailLoaded({required this.user});

  @override
  List<Object?> get props => [user];
}

class AdminUserOperationInProgress extends AdminUserState {
  const AdminUserOperationInProgress();
}

class AdminUserOperationSuccess extends AdminUserState {
  final String message;

  const AdminUserOperationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class AdminUserOperationError extends AdminUserState {
  final String message;

  const AdminUserOperationError({required this.message});

  @override
  List<Object?> get props => [message];
}
