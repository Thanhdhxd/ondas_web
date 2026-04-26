import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoaded extends DashboardState {
  final String displayName;
  final String email;
  final String role;

  const DashboardLoaded({
    required this.displayName,
    required this.email,
    required this.role,
  });

  @override
  List<Object?> get props => [displayName, email, role];
}

class DashboardLoggingOut extends DashboardState {
  const DashboardLoggingOut();
}

class DashboardLogoutSuccess extends DashboardState {
  const DashboardLogoutSuccess();
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object?> get props => [message];
}
