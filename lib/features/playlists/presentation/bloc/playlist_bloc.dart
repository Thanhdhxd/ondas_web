import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ondas_web/features/playlists/domain/repositories/playlist_repository.dart';
import 'package:ondas_web/features/playlists/presentation/bloc/playlist_event.dart';
import 'package:ondas_web/features/playlists/presentation/bloc/playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  final PlaylistRepository _repository;

  PlaylistBloc({required PlaylistRepository repository})
    : _repository = repository,
      super(const PlaylistInitial()) {
    on<PlaylistLoadListEvent>(_onLoadList);
    on<PlaylistLoadDetailEvent>(_onLoadDetail);
    on<PlaylistCreateEvent>(_onCreate);
    on<PlaylistUpdateEvent>(_onUpdate);
    on<PlaylistDeleteEvent>(_onDelete);
    on<PlaylistAddSongEvent>(_onAddSong);
    on<PlaylistRemoveSongEvent>(_onRemoveSong);
    on<PlaylistReorderSongsEvent>(_onReorderSongs);
  }

  Future<void> _onLoadList(
    PlaylistLoadListEvent event,
    Emitter<PlaylistState> emit,
  ) async {
    emit(const PlaylistListLoading());
    final result = await _repository.getPlaylists(
      page: event.page,
      size: event.size,
      query: event.query,
      owner: event.owner,
      isPublic: event.isPublic,
    );
    result.fold(
      (failure) => emit(PlaylistListError(message: failure.message)),
      (page) => emit(
        PlaylistListLoaded(
          playlists: page.items,
          page: page.page,
          totalPages: page.totalPages,
          totalElements: page.totalElements,
        ),
      ),
    );
  }

  Future<void> _onLoadDetail(
    PlaylistLoadDetailEvent event,
    Emitter<PlaylistState> emit,
  ) async {
    emit(const PlaylistDetailLoading());
    final result = await _repository.getPlaylist(id: event.id);
    result.fold(
      (failure) => emit(PlaylistOperationError(message: failure.message)),
      (playlist) => emit(PlaylistDetailLoaded(playlist: playlist)),
    );
  }

  Future<void> _onCreate(
    PlaylistCreateEvent event,
    Emitter<PlaylistState> emit,
  ) async {
    emit(const PlaylistOperationInProgress());
    final result = await _repository.createPlaylist(
      name: event.name,
      description: event.description,
      isPublic: event.isPublic,
      coverBytes: event.coverBytes,
      coverFileName: event.coverFileName,
    );
    result.fold(
      (failure) => emit(PlaylistOperationError(message: failure.message)),
      (playlist) => emit(
        PlaylistOperationSuccess(
          message: 'Playlist đã được tạo. Thêm bài hát bên dưới.',
          createdPlaylistId: playlist.id,
        ),
      ),
    );
  }

  Future<void> _onUpdate(
    PlaylistUpdateEvent event,
    Emitter<PlaylistState> emit,
  ) async {
    emit(const PlaylistOperationInProgress());
    final result = await _repository.updatePlaylist(
      id: event.id,
      name: event.name,
      description: event.description,
      isPublic: event.isPublic,
      coverBytes: event.coverBytes,
      coverFileName: event.coverFileName,
    );
    result.fold(
      (failure) => emit(PlaylistOperationError(message: failure.message)),
      (_) => emit(
        const PlaylistOperationSuccess(message: 'Playlist đã được cập nhật.'),
      ),
    );
  }

  Future<void> _onDelete(
    PlaylistDeleteEvent event,
    Emitter<PlaylistState> emit,
  ) async {
    emit(const PlaylistOperationInProgress());
    final result = await _repository.deletePlaylist(id: event.id);
    result.fold(
      (failure) => emit(PlaylistOperationError(message: failure.message)),
      (_) => emit(
        const PlaylistOperationSuccess(message: 'Playlist đã được xóa.'),
      ),
    );
  }

  Future<void> _onAddSong(
    PlaylistAddSongEvent event,
    Emitter<PlaylistState> emit,
  ) async {
    final current = state;
    if (current is! PlaylistDetailLoaded) return;

    emit(current.copyWith(isSongsMutating: true, clearSnackbar: true));
    final result = await _repository.addSongToPlaylist(
      playlistId: event.playlistId,
      songId: event.songId,
    );
    result.fold(
      (failure) => emit(
        current.copyWith(
          isSongsMutating: false,
          snackbarMessage: failure.message,
        ),
      ),
      (playlist) => emit(
        PlaylistDetailLoaded(playlist: playlist, isSongsMutating: false),
      ),
    );
  }

  Future<void> _onRemoveSong(
    PlaylistRemoveSongEvent event,
    Emitter<PlaylistState> emit,
  ) async {
    final current = state;
    if (current is! PlaylistDetailLoaded) return;

    emit(current.copyWith(isSongsMutating: true, clearSnackbar: true));
    final result = await _repository.removeSongFromPlaylist(
      playlistId: event.playlistId,
      songId: event.songId,
    );
    result.fold(
      (failure) => emit(
        current.copyWith(
          isSongsMutating: false,
          snackbarMessage: failure.message,
        ),
      ),
      (playlist) => emit(
        PlaylistDetailLoaded(playlist: playlist, isSongsMutating: false),
      ),
    );
  }

  Future<void> _onReorderSongs(
    PlaylistReorderSongsEvent event,
    Emitter<PlaylistState> emit,
  ) async {
    final current = state;
    if (current is! PlaylistDetailLoaded) return;

    emit(current.copyWith(isSongsMutating: true, clearSnackbar: true));
    final result = await _repository.reorderPlaylistSongs(
      playlistId: event.playlistId,
      songIds: event.songIds,
    );
    result.fold(
      (failure) => emit(
        current.copyWith(
          isSongsMutating: false,
          snackbarMessage: failure.message,
        ),
      ),
      (playlist) => emit(
        PlaylistDetailLoaded(playlist: playlist, isSongsMutating: false),
      ),
    );
  }
}
