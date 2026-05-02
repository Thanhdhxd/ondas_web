import 'package:ondas_web/features/users/domain/entities/admin_user.dart';

class AdminUserModel extends AdminUser {
  const AdminUserModel({
    required super.id,
    required super.email,
    required super.displayName,
    super.avatarUrl,
    super.role,
    required super.active,
    super.banReason,
    super.bannedAt,
    super.lastLoginAt,
    super.createdAt,
    super.updatedAt,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      role: _parseRole(json['role']),
      active: json['active'] as bool? ?? json['isActive'] as bool? ?? false,
      banReason: json['banReason'] as String?,
      bannedAt: json['bannedAt'] as String?,
      lastLoginAt: json['lastLoginAt'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  static String? _parseRole(dynamic value) {
    if (value is String) return value;
    if (value is Map<String, dynamic>) {
      return value['name'] as String? ?? value['role'] as String?;
    }
    return null;
  }
}
