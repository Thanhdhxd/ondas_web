import 'package:equatable/equatable.dart';

abstract class AdminUserEvent extends Equatable {
  const AdminUserEvent();

  @override
  List<Object?> get props => [];
}

class AdminUserLoadListEvent extends AdminUserEvent {
  final int page;
  final int size;
  final String? keyword;
  final String? role;
  final bool? active;

  const AdminUserLoadListEvent({
    required this.page,
    required this.size,
    this.keyword,
    this.role,
    this.active,
  });

  @override
  List<Object?> get props => [page, size, keyword, role, active];
}

class AdminUserLoadDetailEvent extends AdminUserEvent {
  final String id;

  const AdminUserLoadDetailEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class AdminUserBanEvent extends AdminUserEvent {
  final String id;
  final String banReason;

  const AdminUserBanEvent({required this.id, required this.banReason});

  @override
  List<Object?> get props => [id, banReason];
}

class AdminUserUnbanEvent extends AdminUserEvent {
  final String id;

  const AdminUserUnbanEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
