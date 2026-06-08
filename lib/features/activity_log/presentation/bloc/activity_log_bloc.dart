import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ondas_web/features/activity_log/domain/usecases/get_activity_logs_usecase.dart';
import 'package:ondas_web/features/activity_log/presentation/bloc/activity_log_event.dart';
import 'package:ondas_web/features/activity_log/presentation/bloc/activity_log_state.dart';

class ActivityLogBloc extends Bloc<ActivityLogEvent, ActivityLogState> {
  final GetActivityLogsUseCase _getActivityLogsUseCase;

  ActivityLogBloc({required GetActivityLogsUseCase getActivityLogsUseCase})
    : _getActivityLogsUseCase = getActivityLogsUseCase,
      super(const ActivityLogInitial()) {
    on<ActivityLogLoadEvent>(_onLoad);
  }

  Future<void> _onLoad(
    ActivityLogLoadEvent event,
    Emitter<ActivityLogState> emit,
  ) async {
    emit(const ActivityLogLoading());
    final result = await _getActivityLogsUseCase(
      GetActivityLogsParams(
        actorId: event.actorId,
        searchUser: event.searchUser,
        action: event.action,
        from: event.from,
        to: event.to,
        page: event.page,
        size: event.size,
      ),
    );
    result.fold(
      (failure) => emit(ActivityLogError(message: failure.message)),
      (page) => emit(
        ActivityLogLoaded(
          logs: page.items,
          page: page.page,
          totalPages: page.totalPages,
          totalElements: page.totalElements,
        ),
      ),
    );
  }
}
