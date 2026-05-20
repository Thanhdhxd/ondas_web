import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ondas_web/features/playlists/domain/repositories/system_playlist_repository.dart';
import 'package:ondas_web/features/playlists/presentation/bloc/system_playlist_event.dart';
import 'package:ondas_web/features/playlists/presentation/bloc/system_playlist_state.dart';

class SystemPlaylistBloc extends Bloc<SystemPlaylistEvent, SystemPlaylistState> {
  final SystemPlaylistRepository _repository;

  SystemPlaylistBloc({required SystemPlaylistRepository repository})
    : _repository = repository,
      super(const SystemPlaylistInitial()) {
    on<SystemPlaylistLoadListEvent>(_onLoadList);
    on<SystemPlaylistLoadDetailEvent>(_onLoadDetail);
    on<SystemPlaylistCreateEvent>(_onCreate);
    on<SystemPlaylistUpdateEvent>(_onUpdate);
    on<SystemPlaylistDeleteEvent>(_onDelete);
    on<SystemPlaylistAddSongEvent>(_onAddSong);
    on<SystemPlaylistRemoveSongEvent>(_onRemoveSong);
    on<SystemPlaylistReorderSongsEvent>(_onReorderSongs);
  }

  Future<void> _onLoadList(
    SystemPlaylistLoadListEvent event,
    Emitter<SystemPlaylistState> emit,
  ) async {
    emit(const SystemPlaylistListLoading());
    final result = await _repository.getPlaylists(
      page: event.page,
      size: event.size,
      query: event.query,
      isActive: event.isActive,
    );
    result.fold(
      (failure) => emit(SystemPlaylistListError(message: failure.message)),
      (page) => emit(
        SystemPlaylistListLoaded(
          playlists: page.items,
          page: page.page,
          totalPages: page.totalPages,
          totalElements: page.totalElements,
        ),
      ),
    );
  }

  Future<void> _onLoadDetail(
    SystemPlaylistLoadDetailEvent event,
    Emitter<SystemPlaylistState> emit,
  ) async {
    emit(const SystemPlaylistDetailLoading());
    final result = await _repository.getPlaylist(id: event.id);
    result.fold(
      (failure) => emit(SystemPlaylistOperationError(message: failure.message)),
      (playlist) => emit(SystemPlaylistDetailLoaded(playlist: playlist)),
    );
  }

  Future<void> _onCreate(
    SystemPlaylistCreateEvent event,
    Emitter<SystemPlaylistState> emit,
  ) async {
    emit(const SystemPlaylistOperationInProgress());
    final result = await _repository.createPlaylist(
      name: event.name,
      description: event.description,
      isActive: event.isActive,
      coverBytes: event.coverBytes,
      coverFileName: event.coverFileName,
    );
    result.fold(
      (failure) => emit(SystemPlaylistOperationError(message: failure.message)),
      (playlist) => emit(
        SystemPlaylistOperationSuccess(
          message: 'System playlist đã được tạo.',
        ),
      ),
    );
  }

  Future<void> _onUpdate(
    SystemPlaylistUpdateEvent event,
    Emitter<SystemPlaylistState> emit,
  ) async {
    emit(const SystemPlaylistOperationInProgress());
    final result = await _repository.updatePlaylist(
      id: event.id,
      name: event.name,
      description: event.description,
      isActive: event.isActive,
      coverBytes: event.coverBytes,
      coverFileName: event.coverFileName,
    );
    result.fold(
      (failure) => emit(SystemPlaylistOperationError(message: failure.message)),
      (_) => emit(
        const SystemPlaylistOperationSuccess(
          message: 'System playlist đã được cập nhật.',
        ),
      ),
    );
  }

  Future<void> _onDelete(
    SystemPlaylistDeleteEvent event,
    Emitter<SystemPlaylistState> emit,
  ) async {
    emit(const SystemPlaylistOperationInProgress());
    final result = await _repository.deletePlaylist(id: event.id);
    result.fold(
      (failure) => emit(SystemPlaylistOperationError(message: failure.message)),
      (_) => emit(
        const SystemPlaylistOperationSuccess(
          message: 'System playlist đã được xóa.',
        ),
      ),
    );
  }

  Future<void> _onAddSong(
    SystemPlaylistAddSongEvent event,
    Emitter<SystemPlaylistState> emit,
  ) async {
    final current = state;
    if (current is! SystemPlaylistDetailLoaded) return;

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
        SystemPlaylistDetailLoaded(playlist: playlist, isSongsMutating: false),
      ),
    );
  }

  Future<void> _onRemoveSong(
    SystemPlaylistRemoveSongEvent event,
    Emitter<SystemPlaylistState> emit,
  ) async {
    final current = state;
    if (current is! SystemPlaylistDetailLoaded) return;

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
        SystemPlaylistDetailLoaded(playlist: playlist, isSongsMutating: false),
      ),
    );
  }

  Future<void> _onReorderSongs(
    SystemPlaylistReorderSongsEvent event,
    Emitter<SystemPlaylistState> emit,
  ) async {
    final current = state;
    if (current is! SystemPlaylistDetailLoaded) return;

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
        SystemPlaylistDetailLoaded(playlist: playlist, isSongsMutating: false),
      ),
    );
  }
}
