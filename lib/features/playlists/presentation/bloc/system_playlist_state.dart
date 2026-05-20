import 'package:equatable/equatable.dart';
import 'package:ondas_web/features/playlists/domain/entities/system_playlist.dart';

abstract class SystemPlaylistState extends Equatable {
  const SystemPlaylistState();

  @override
  List<Object?> get props => [];
}

class SystemPlaylistInitial extends SystemPlaylistState {
  const SystemPlaylistInitial();
}

class SystemPlaylistListLoading extends SystemPlaylistState {
  const SystemPlaylistListLoading();
}

class SystemPlaylistListLoaded extends SystemPlaylistState {
  final List<SystemPlaylist> playlists;
  final int page;
  final int totalPages;
  final int totalElements;

  const SystemPlaylistListLoaded({
    required this.playlists,
    required this.page,
    required this.totalPages,
    required this.totalElements,
  });

  @override
  List<Object?> get props => [playlists, page, totalPages, totalElements];
}

class SystemPlaylistListError extends SystemPlaylistState {
  final String message;

  const SystemPlaylistListError({required this.message});

  @override
  List<Object?> get props => [message];
}

class SystemPlaylistDetailLoading extends SystemPlaylistState {
  const SystemPlaylistDetailLoading();
}

class SystemPlaylistDetailLoaded extends SystemPlaylistState {
  final SystemPlaylist playlist;
  final bool isSongsMutating;
  final String? snackbarMessage;

  const SystemPlaylistDetailLoaded({
    required this.playlist,
    this.isSongsMutating = false,
    this.snackbarMessage,
  });

  SystemPlaylistDetailLoaded copyWith({
    SystemPlaylist? playlist,
    bool? isSongsMutating,
    String? snackbarMessage,
    bool clearSnackbar = false,
  }) {
    return SystemPlaylistDetailLoaded(
      playlist: playlist ?? this.playlist,
      isSongsMutating: isSongsMutating ?? this.isSongsMutating,
      snackbarMessage: clearSnackbar
          ? null
          : snackbarMessage ?? this.snackbarMessage,
    );
  }

  @override
  List<Object?> get props => [playlist, isSongsMutating, snackbarMessage];
}

class SystemPlaylistOperationInProgress extends SystemPlaylistState {
  const SystemPlaylistOperationInProgress();
}

class SystemPlaylistOperationSuccess extends SystemPlaylistState {
  final String message;
  final String? createdPlaylistId;

  const SystemPlaylistOperationSuccess({
    required this.message,
    this.createdPlaylistId,
  });

  @override
  List<Object?> get props => [message, createdPlaylistId];
}

class SystemPlaylistOperationError extends SystemPlaylistState {
  final String message;

  const SystemPlaylistOperationError({required this.message});

  @override
  List<Object?> get props => [message];
}
