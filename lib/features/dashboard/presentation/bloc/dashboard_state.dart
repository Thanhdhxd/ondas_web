import 'package:equatable/equatable.dart';
import 'package:ondas_web/features/statistics/domain/entities/admin_stats.dart';
import 'package:ondas_web/features/songs/domain/entities/song.dart';
import 'package:ondas_web/features/activity_log/domain/entities/activity_log.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final String displayName;
  final String email;
  final String role;
  final int totalSongs;
  final int totalArtists;
  final int totalAlbums;
  final int totalUsers;
  final int activeUsers;
  final List<DailyPlayCount> playsDaily;
  final List<Song> recentSongs;
  final List<ActivityLog> recentActivities;

  const DashboardLoaded({
    required this.displayName,
    required this.email,
    required this.role,
    required this.totalSongs,
    required this.totalArtists,
    required this.totalAlbums,
    required this.totalUsers,
    required this.activeUsers,
    required this.playsDaily,
    required this.recentSongs,
    required this.recentActivities,
  });

  @override
  List<Object?> get props => [
        displayName,
        email,
        role,
        totalSongs,
        totalArtists,
        totalAlbums,
        totalUsers,
        activeUsers,
        playsDaily,
        recentSongs,
        recentActivities,
      ];
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

