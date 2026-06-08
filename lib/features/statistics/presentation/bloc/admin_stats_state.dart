import 'package:equatable/equatable.dart';
import 'package:ondas_web/features/statistics/domain/entities/admin_stats.dart';

abstract class AdminStatsState extends Equatable {
  const AdminStatsState();

  @override
  List<Object?> get props => [];
}

class AdminStatsInitial extends AdminStatsState {
  const AdminStatsInitial();
}

class AdminStatsLoading extends AdminStatsState {
  const AdminStatsLoading();
}

class AdminStatsLoaded extends AdminStatsState {
  final List<TopSong> topSongs;
  final List<TopArtist> topArtists;
  final List<DailyPlayCount> playsDaily;
  final DauMauStats? dauMau;

  const AdminStatsLoaded({
    required this.topSongs,
    required this.topArtists,
    required this.playsDaily,
    this.dauMau,
  });

  @override
  List<Object?> get props => [topSongs, topArtists, playsDaily, dauMau];
}

class AdminStatsError extends AdminStatsState {
  final String message;

  const AdminStatsError({required this.message});

  @override
  List<Object?> get props => [message];
}
