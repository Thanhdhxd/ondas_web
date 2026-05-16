import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ondas_web/features/songs/domain/usecases/create_song_usecase.dart';
import 'package:ondas_web/features/songs/domain/usecases/delete_song_usecase.dart';
import 'package:ondas_web/features/songs/domain/usecases/get_song_usecase.dart';
import 'package:ondas_web/features/songs/domain/usecases/get_songs_usecase.dart';
import 'package:ondas_web/features/songs/domain/usecases/replace_song_tags_usecase.dart';
import 'package:ondas_web/features/songs/domain/usecases/update_song_usecase.dart';
import 'package:ondas_web/features/songs/presentation/bloc/song_event.dart';
import 'package:ondas_web/features/songs/presentation/bloc/song_state.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  final GetSongsUseCase _getSongsUseCase;
  final GetSongUseCase _getSongUseCase;
  final CreateSongUseCase _createSongUseCase;
  final UpdateSongUseCase _updateSongUseCase;
  final DeleteSongUseCase _deleteSongUseCase;
  final ReplaceSongTagsUseCase _replaceSongTagsUseCase;

  SongBloc({
    required GetSongsUseCase getSongsUseCase,
    required GetSongUseCase getSongUseCase,
    required CreateSongUseCase createSongUseCase,
    required UpdateSongUseCase updateSongUseCase,
    required DeleteSongUseCase deleteSongUseCase,
    required ReplaceSongTagsUseCase replaceSongTagsUseCase,
  }) : _getSongsUseCase = getSongsUseCase,
       _getSongUseCase = getSongUseCase,
       _createSongUseCase = createSongUseCase,
       _updateSongUseCase = updateSongUseCase,
       _deleteSongUseCase = deleteSongUseCase,
       _replaceSongTagsUseCase = replaceSongTagsUseCase,
       super(const SongInitial()) {
    on<SongLoadListEvent>(_onLoadList);
    on<SongLoadDetailEvent>(_onLoadDetail);
    on<SongCreateEvent>(_onCreate);
    on<SongUpdateEvent>(_onUpdate);
    on<SongDeleteEvent>(_onDelete);
  }

  Future<void> _onLoadList(
    SongLoadListEvent event,
    Emitter<SongState> emit,
  ) async {
    emit(const SongListLoading());
    final result = await _getSongsUseCase(
      GetSongsParams(page: event.page, size: event.size, query: event.query),
    );
    result.fold(
      (failure) => emit(SongListError(message: failure.message)),
      (page) => emit(
        SongListLoaded(
          songs: page.items,
          page: page.page,
          totalPages: page.totalPages,
          totalElements: page.totalElements,
          query: event.query,
        ),
      ),
    );
  }

  Future<void> _onLoadDetail(
    SongLoadDetailEvent event,
    Emitter<SongState> emit,
  ) async {
    emit(const SongDetailLoading());
    final result = await _getSongUseCase(GetSongParams(id: event.id));
    result.fold(
      (failure) => emit(SongOperationError(message: failure.message)),
      (song) => emit(SongDetailLoaded(song: song)),
    );
  }

  Future<void> _onCreate(
    SongCreateEvent event,
    Emitter<SongState> emit,
  ) async {
    emit(const SongOperationInProgress());
    final result = await _createSongUseCase(
      CreateSongParams(
        title: event.title,
        albumId: event.albumId,
        trackNumber: event.trackNumber,
        releaseDate: event.releaseDate,
        artistIds: event.artistIds,
        genreIds: event.genreIds,
        audioBytes: event.audioBytes,
        audioFileName: event.audioFileName,
        coverBytes: event.coverBytes,
        coverFileName: event.coverFileName,
        lyrics: event.lyrics,
      ),
    );
    await result.fold(
      (failure) async => emit(SongOperationError(message: failure.message)),
      (song) async {
        final tagMessage = await _saveSongTags(
          songId: song.id,
          tagIds: event.tagIds,
        );
        emit(
          SongOperationSuccess(
            message: tagMessage == null
                ? 'Bài hát đã được tạo thành công.'
                : 'Bài hát đã được tạo thành công. $tagMessage',
            song: song,
          ),
        );
      },
    );
  }

  Future<void> _onUpdate(
    SongUpdateEvent event,
    Emitter<SongState> emit,
  ) async {
    emit(const SongOperationInProgress());
    final result = await _updateSongUseCase(
      UpdateSongParams(
        id: event.id,
        title: event.title,
        albumId: event.albumId,
        trackNumber: event.trackNumber,
        releaseDate: event.releaseDate,
        artistIds: event.artistIds,
        genreIds: event.genreIds,
        active: event.active,
        audioBytes: event.audioBytes,
        audioFileName: event.audioFileName,
        coverBytes: event.coverBytes,
        coverFileName: event.coverFileName,
      ),
    );
    await result.fold(
      (failure) async => emit(SongOperationError(message: failure.message)),
      (_) async {
        final tagIds = event.tagIds;
        String? tagMessage;
        if (tagIds != null) {
          tagMessage = await _saveSongTags(songId: event.id, tagIds: tagIds);
        }
        emit(
          SongOperationSuccess(
            message: tagMessage == null
                ? 'Bài hát đã được cập nhật thành công.'
                : 'Bài hát đã được cập nhật thành công. $tagMessage',
          ),
        );
      },
    );
  }

  Future<String?> _saveSongTags({
    required String songId,
    required List<int> tagIds,
  }) async {
    final result = await _replaceSongTagsUseCase(
      ReplaceSongTagsParams(songId: songId, tagIds: tagIds),
    );
    return result.fold(
      (failure) => 'Nhưng gắn tag thất bại: ${failure.message}',
      (_) => null,
    );
  }

  Future<void> _onDelete(
    SongDeleteEvent event,
    Emitter<SongState> emit,
  ) async {
    emit(const SongOperationInProgress());
    final result = await _deleteSongUseCase(DeleteSongParams(id: event.id));
    result.fold(
      (failure) => emit(SongOperationError(message: failure.message)),
      (_) => emit(
        const SongOperationSuccess(
          message: 'Bai hat da duoc xoa thanh cong.',
        ),
      ),
    );
  }
}
