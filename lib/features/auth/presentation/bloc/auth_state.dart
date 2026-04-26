import 'package:equatable/equatable.dart';
import 'package:ondas_web/features/auth/domain/entities/auth_response.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final AuthResponse authResponse;

  const AuthSuccess({required this.authResponse});

  @override
  List<Object?> get props => [authResponse];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
