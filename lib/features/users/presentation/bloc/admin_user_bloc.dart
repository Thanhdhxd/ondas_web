import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ondas_web/features/users/domain/usecases/ban_admin_user_usecase.dart';
import 'package:ondas_web/features/users/domain/usecases/get_admin_user_usecase.dart';
import 'package:ondas_web/features/users/domain/usecases/get_admin_users_usecase.dart';
import 'package:ondas_web/features/users/domain/usecases/unban_admin_user_usecase.dart';
import 'package:ondas_web/features/users/presentation/bloc/admin_user_event.dart';
import 'package:ondas_web/features/users/presentation/bloc/admin_user_state.dart';

class AdminUserBloc extends Bloc<AdminUserEvent, AdminUserState> {
  final GetAdminUsersUseCase _getAdminUsersUseCase;
  final GetAdminUserUseCase _getAdminUserUseCase;
  final BanAdminUserUseCase _banAdminUserUseCase;
  final UnbanAdminUserUseCase _unbanAdminUserUseCase;

  AdminUserBloc({
    required GetAdminUsersUseCase getAdminUsersUseCase,
    required GetAdminUserUseCase getAdminUserUseCase,
    required BanAdminUserUseCase banAdminUserUseCase,
    required UnbanAdminUserUseCase unbanAdminUserUseCase,
  }) : _getAdminUsersUseCase = getAdminUsersUseCase,
       _getAdminUserUseCase = getAdminUserUseCase,
       _banAdminUserUseCase = banAdminUserUseCase,
       _unbanAdminUserUseCase = unbanAdminUserUseCase,
       super(const AdminUserInitial()) {
    on<AdminUserLoadListEvent>(_onLoadList);
    on<AdminUserLoadDetailEvent>(_onLoadDetail);
    on<AdminUserBanEvent>(_onBanUser);
    on<AdminUserUnbanEvent>(_onUnbanUser);
  }

  Future<void> _onLoadList(
    AdminUserLoadListEvent event,
    Emitter<AdminUserState> emit,
  ) async {
    emit(const AdminUserListLoading());
    final result = await _getAdminUsersUseCase(
      GetAdminUsersParams(
        page: event.page,
        size: event.size,
        keyword: event.keyword,
        role: event.role,
        active: event.active,
      ),
    );
    result.fold(
      (failure) => emit(AdminUserListError(message: failure.message)),
      (page) => emit(
        AdminUserListLoaded(
          users: page.items,
          page: page.page,
          totalPages: page.totalPages,
          totalElements: page.totalElements,
          keyword: event.keyword,
          role: event.role,
          active: event.active,
        ),
      ),
    );
  }

  Future<void> _onLoadDetail(
    AdminUserLoadDetailEvent event,
    Emitter<AdminUserState> emit,
  ) async {
    emit(const AdminUserDetailLoading());
    final result = await _getAdminUserUseCase(GetAdminUserParams(id: event.id));
    result.fold(
      (failure) => emit(AdminUserOperationError(message: failure.message)),
      (user) => emit(AdminUserDetailLoaded(user: user)),
    );
  }

  Future<void> _onBanUser(
    AdminUserBanEvent event,
    Emitter<AdminUserState> emit,
  ) async {
    emit(const AdminUserOperationInProgress());
    final result = await _banAdminUserUseCase(
      BanAdminUserParams(id: event.id, banReason: event.banReason),
    );
    result.fold(
      (failure) => emit(AdminUserOperationError(message: failure.message)),
      (user) {
        emit(
          const AdminUserOperationSuccess(
            message: 'Tai khoan da bi khoa thanh cong.',
          ),
        );
        emit(AdminUserDetailLoaded(user: user));
      },
    );
  }

  Future<void> _onUnbanUser(
    AdminUserUnbanEvent event,
    Emitter<AdminUserState> emit,
  ) async {
    emit(const AdminUserOperationInProgress());
    final result = await _unbanAdminUserUseCase(
      UnbanAdminUserParams(id: event.id),
    );
    result.fold(
      (failure) => emit(AdminUserOperationError(message: failure.message)),
      (user) {
        emit(
          const AdminUserOperationSuccess(
            message: 'Tai khoan da duoc mo khoa.',
          ),
        );
        emit(AdminUserDetailLoaded(user: user));
      },
    );
  }
}
