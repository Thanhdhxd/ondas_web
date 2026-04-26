import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ondas_web/core/storage/secure_storage.dart';
import 'package:ondas_web/features/auth/domain/usecases/logout_usecase.dart';
import 'package:ondas_web/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:ondas_web/features/dashboard/presentation/bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final LogoutUseCase _logoutUseCase;
  final SecureStorage _secureStorage;

  DashboardBloc({
    required LogoutUseCase logoutUseCase,
    required SecureStorage secureStorage,
  })  : _logoutUseCase = logoutUseCase,
        _secureStorage = secureStorage,
        super(const DashboardInitial()) {
    on<DashboardStarted>(_onStarted);
    on<DashboardLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onStarted(
    DashboardStarted event,
    Emitter<DashboardState> emit,
  ) async {
    final displayName = await _secureStorage.getUserDisplayName() ?? 'Admin';
    final email = await _secureStorage.getUserEmail() ?? '';
    final role = await _secureStorage.getUserRole() ?? '';
    emit(DashboardLoaded(displayName: displayName, email: email, role: role));
  }

  Future<void> _onLogoutRequested(
    DashboardLogoutRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoggingOut());
    final refreshToken = await _secureStorage.getRefreshToken() ?? '';
    final result = await _logoutUseCase(
      LogoutParams(refreshToken: refreshToken),
    );
    result.fold(
      // Even on server error we've already cleared storage in the repo impl
      (_) => emit(const DashboardLogoutSuccess()),
      (_) => emit(const DashboardLogoutSuccess()),
    );
  }
}
