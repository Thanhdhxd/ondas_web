import 'package:equatable/equatable.dart';
import 'package:ondas_web/features/playlists/domain/entities/playlist.dart';

abstract class PlaylistState extends Equatable {
  const PlaylistState();

  @override
  List<Object?> get props => [];
}

class PlaylistInitial extends PlaylistState {
  const PlaylistInitial();
}

class PlaylistListLoading extends PlaylistState {
  const PlaylistListLoading();
}

class PlaylistListLoaded extends PlaylistState {
  final List<Playlist> playlists;
  final int page;
  final int totalPages;
  final int totalElements;

  const PlaylistListLoaded({
    required this.playlists,
    required this.page,
    required this.totalPages,
    required this.totalElements,
  });

  @override
  List<Object?> get props => [playlists, page, totalPages, totalElements];
}

class PlaylistListError extends PlaylistState {
  final String message;

  const PlaylistListError({required this.message});

  @override
  List<Object?> get props => [message];
}

class PlaylistDetailLoading extends PlaylistState {
  const PlaylistDetailLoading();
}

class PlaylistDetailLoaded extends PlaylistState {
  final Playlist playlist;
  final bool isSongsMutating;
  final String? snackbarMessage;

  const PlaylistDetailLoaded({
    required this.playlist,
    this.isSongsMutating = false,
    this.snackbarMessage,
  });

  PlaylistDetailLoaded copyWith({
    Playlist? playlist,
    bool? isSongsMutating,
    String? snackbarMessage,
    bool clearSnackbar = false,
  }) {
    return PlaylistDetailLoaded(
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

class PlaylistOperationInProgress extends PlaylistState {
  const PlaylistOperationInProgress();
}

class PlaylistOperationSuccess extends PlaylistState {
  final String message;
  final String? createdPlaylistId;

  const PlaylistOperationSuccess({
    required this.message,
    this.createdPlaylistId,
  });

  @override
  List<Object?> get props => [message, createdPlaylistId];
}

class PlaylistOperationError extends PlaylistState {
  final String message;

  const PlaylistOperationError({required this.message});

  @override
  List<Object?> get props => [message];
}
