import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ondas_web/features/auth/domain/usecases/login_usecase.dart';
import 'package:ondas_web/features/auth/presentation/bloc/auth_event.dart';
import 'package:ondas_web/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;

  AuthBloc({required LoginUseCase loginUseCase})
      : _loginUseCase = loginUseCase,
        super(const AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (authResponse) => emit(AuthSuccess(authResponse: authResponse)),
    );
  }
}
