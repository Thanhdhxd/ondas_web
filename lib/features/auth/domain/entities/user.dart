import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final String role;

  const User({
    required this.id,
    required this.email,
    required this.displayName,
    required this.role,
  });

  @override
  List<Object?> get props => [id, email, displayName, role];
}
