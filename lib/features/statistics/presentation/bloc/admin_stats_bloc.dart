import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ondas_web/features/statistics/domain/entities/admin_stats.dart';
import 'package:ondas_web/features/statistics/domain/repositories/admin_stats_repository.dart';
import 'package:ondas_web/features/statistics/presentation/bloc/admin_stats_event.dart';
import 'package:ondas_web/features/statistics/presentation/bloc/admin_stats_state.dart';

class AdminStatsBloc extends Bloc<AdminStatsEvent, AdminStatsState> {
  final AdminStatsRepository _repository;

  AdminStatsBloc({required AdminStatsRepository repository})
    : _repository = repository,
      super(const AdminStatsInitial()) {
    on<AdminStatsLoadEvent>(_onLoad);
  }

  Future<void> _onLoad(
    AdminStatsLoadEvent event,
    Emitter<AdminStatsState> emit,
  ) async {
    emit(const AdminStatsLoading());

    final topSongsResult = await _repository.getTopSongs(
      from: event.from,
      to: event.to,
      limit: event.topLimit,
    );
    final topArtistsResult = await _repository.getTopArtists(
      from: event.from,
      to: event.to,
      limit: event.topLimit,
    );
    final playsDailyResult = await _repository.getPlaysDaily(
      from: event.from,
      to: event.to,
    );
    final dauMauResult = await _repository.getDauMau(date: event.dauMauDate);

    if (topSongsResult.isLeft()) {
      final failure = topSongsResult.fold((l) => l, (_) => null)!;
      emit(AdminStatsError(message: failure.message));
      return;
    }
    if (topArtistsResult.isLeft()) {
      final failure = topArtistsResult.fold((l) => l, (_) => null)!;
      emit(AdminStatsError(message: failure.message));
      return;
    }

    final topSongs = topSongsResult.fold<List<TopSong>>(
      (_) => [],
      (r) => r,
    );
    final topArtists = topArtistsResult.fold<List<TopArtist>>(
      (_) => [],
      (r) => r,
    );
    final playsDaily = playsDailyResult.fold<List<DailyPlayCount>>(
      (_) => [],
      (r) => r,
    );
    final dauMau = dauMauResult.fold<DauMauStats?>(
      (_) => null,
      (r) => r,
    );

    emit(
      AdminStatsLoaded(
        topSongs: topSongs,
        topArtists: topArtists,
        playsDaily: playsDaily,
        dauMau: dauMau,
      ),
    );
  }
}
