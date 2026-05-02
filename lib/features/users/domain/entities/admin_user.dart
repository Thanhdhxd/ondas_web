import 'package:equatable/equatable.dart';

class AdminUser extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final String? avatarUrl;
  final String? role;
  final bool active;
  final String? banReason;
  final String? bannedAt;
  final String? lastLoginAt;
  final String? createdAt;
  final String? updatedAt;

  const AdminUser({
    required this.id,
    required this.email,
    required this.displayName,
    this.avatarUrl,
    this.role,
    required this.active,
    this.banReason,
    this.bannedAt,
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    displayName,
    avatarUrl,
    role,
    active,
    banReason,
    bannedAt,
    lastLoginAt,
    createdAt,
    updatedAt,
  ];
}
