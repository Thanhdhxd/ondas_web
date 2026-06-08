import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/core/storage/secure_storage.dart';
import 'package:ondas_web/features/auth/domain/usecases/logout_usecase.dart';
import 'package:ondas_web/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:ondas_web/features/dashboard/presentation/bloc/dashboard_state.dart';

import 'package:ondas_web/features/songs/domain/usecases/get_songs_usecase.dart';
import 'package:ondas_web/features/artists/domain/usecases/get_artists_usecase.dart';
import 'package:ondas_web/features/albums/domain/usecases/get_albums_usecase.dart';
import 'package:ondas_web/features/users/domain/usecases/get_admin_users_usecase.dart';
import 'package:ondas_web/features/activity_log/domain/usecases/get_activity_logs_usecase.dart';
import 'package:ondas_web/features/statistics/domain/repositories/admin_stats_repository.dart';

import 'package:ondas_web/features/songs/domain/entities/song.dart';
import 'package:ondas_web/features/artists/domain/entities/artist.dart';
import 'package:ondas_web/features/albums/domain/entities/album.dart';
import 'package:ondas_web/features/users/domain/entities/admin_user.dart';
import 'package:ondas_web/features/activity_log/domain/entities/activity_log.dart';
import 'package:ondas_web/features/statistics/domain/entities/admin_stats.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final LogoutUseCase _logoutUseCase;
  final SecureStorage _secureStorage;
  final GetSongsUseCase _getSongsUseCase;
  final GetArtistsUseCase _getArtistsUseCase;
  final GetAlbumsUseCase _getAlbumsUseCase;
  final GetAdminUsersUseCase _getAdminUsersUseCase;
  final GetActivityLogsUseCase _getActivityLogsUseCase;
  final AdminStatsRepository _adminStatsRepository;

  DashboardBloc({
    required LogoutUseCase logoutUseCase,
    required SecureStorage secureStorage,
    required GetSongsUseCase getSongsUseCase,
    required GetArtistsUseCase getArtistsUseCase,
    required GetAlbumsUseCase getAlbumsUseCase,
    required GetAdminUsersUseCase getAdminUsersUseCase,
    required GetActivityLogsUseCase getActivityLogsUseCase,
    required AdminStatsRepository adminStatsRepository,
  })  : _logoutUseCase = logoutUseCase,
        _secureStorage = secureStorage,
        _getSongsUseCase = getSongsUseCase,
        _getArtistsUseCase = getArtistsUseCase,
        _getAlbumsUseCase = getAlbumsUseCase,
        _getAdminUsersUseCase = getAdminUsersUseCase,
        _getActivityLogsUseCase = getActivityLogsUseCase,
        _adminStatsRepository = adminStatsRepository,
        super(const DashboardInitial()) {
    on<DashboardStarted>(_onStarted);
    on<DashboardLogoutRequested>(_onLogoutRequested);
  }

  String _fmtDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  Future<void> _onStarted(
    DashboardStarted event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());

    final today = DateTime.now();
    final start = today.subtract(const Duration(days: 6));

    final todayStr = _fmtDate(today);
    final startStr = _fmtDate(start);

    final results = await Future.wait([
      _secureStorage.getUserDisplayName(),
      _secureStorage.getUserEmail(),
      _secureStorage.getUserRole(),
      _getSongsUseCase(const GetSongsParams(page: 0, size: 5)),
      _getArtistsUseCase(const GetArtistsParams(page: 0, size: 1)),
      _getAlbumsUseCase(const GetAlbumsParams(page: 0, size: 1)),
      _getAdminUsersUseCase(const GetAdminUsersParams(page: 0, size: 1)),
      _adminStatsRepository.getPlaysDaily(from: startStr, to: todayStr),
      _adminStatsRepository.getDauMau(date: todayStr),
      _getActivityLogsUseCase(const GetActivityLogsParams(page: 0, size: 5)),
    ]);

    final displayName = (results[0] as String?) ?? 'Admin';
    final email = (results[1] as String?) ?? '';
    final role = (results[2] as String?) ?? '';

    final songsResult = results[3] as Either<Failure, PageResultDto<Song>>;
    final artistsResult = results[4] as Either<Failure, PageResultDto<Artist>>;
    final albumsResult = results[5] as Either<Failure, PageResultDto<Album>>;
    final usersResult = results[6] as Either<Failure, PageResultDto<AdminUser>>;
    final playsResult = results[7] as Either<Failure, List<DailyPlayCount>>;
    final dauMauResult = results[8] as Either<Failure, DauMauStats>;
    final logsResult = results[9] as Either<Failure, PageResultDto<ActivityLog>>;

    int totalSongs = 0;
    List<Song> recentSongs = [];
    songsResult.fold(
      (_) {},
      (r) {
        totalSongs = r.totalElements;
        recentSongs = r.items;
      },
    );

    final totalArtists = artistsResult.fold((_) => 0, (r) => r.totalElements);
    final totalAlbums = albumsResult.fold((_) => 0, (r) => r.totalElements);
    final totalUsers = usersResult.fold((_) => 0, (r) => r.totalElements);
    final playsDaily = playsResult.fold((_) => <DailyPlayCount>[], (r) => r);
    final activeUsers = dauMauResult.fold((_) => 0, (r) => r.dau);
    final recentActivities = logsResult.fold((_) => <ActivityLog>[], (r) => r.items);

    emit(DashboardLoaded(
      displayName: displayName,
      email: email,
      role: role,
      totalSongs: totalSongs,
      totalArtists: totalArtists,
      totalAlbums: totalAlbums,
      totalUsers: totalUsers,
      activeUsers: activeUsers,
      playsDaily: playsDaily,
      recentSongs: recentSongs,
      recentActivities: recentActivities,
    ));
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


