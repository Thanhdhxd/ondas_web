import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/lyrics/domain/entities/lyrics.dart';
import 'package:ondas_web/features/lyrics/domain/usecases/create_song_lyrics_usecase.dart';
import 'package:ondas_web/features/lyrics/domain/usecases/delete_song_lyrics_usecase.dart';
import 'package:ondas_web/features/lyrics/domain/usecases/get_song_lyrics_usecase.dart';
import 'package:ondas_web/features/lyrics/domain/usecases/update_song_lyrics_usecase.dart';
import 'package:ondas_web/features/lyrics/presentation/bloc/lyrics_event.dart';
import 'package:ondas_web/features/lyrics/presentation/bloc/lyrics_state.dart';

class LyricsBloc extends Bloc<LyricsEvent, LyricsState> {
  final GetSongLyricsUseCase _getSongLyricsUseCase;
  final CreateSongLyricsUseCase _createSongLyricsUseCase;
  final UpdateSongLyricsUseCase _updateSongLyricsUseCase;
  final DeleteSongLyricsUseCase _deleteSongLyricsUseCase;

  LyricsBloc({
    required GetSongLyricsUseCase getSongLyricsUseCase,
    required CreateSongLyricsUseCase createSongLyricsUseCase,
    required UpdateSongLyricsUseCase updateSongLyricsUseCase,
    required DeleteSongLyricsUseCase deleteSongLyricsUseCase,
  })  : _getSongLyricsUseCase = getSongLyricsUseCase,
        _createSongLyricsUseCase = createSongLyricsUseCase,
        _updateSongLyricsUseCase = updateSongLyricsUseCase,
        _deleteSongLyricsUseCase = deleteSongLyricsUseCase,
        super(const LyricsInitial()) {
    on<LyricsLoadEvent>(_onLoad);
    on<LyricsCreateEvent>(_onCreate);
    on<LyricsUpdateEvent>(_onUpdate);
    on<LyricsDeleteEvent>(_onDelete);
    on<LyricsResetEvent>(_onReset);
  }

  Future<void> _onLoad(
    LyricsLoadEvent event,
    Emitter<LyricsState> emit,
  ) async {
    emit(const LyricsLoading());
    final result = await _getSongLyricsUseCase(
      GetSongLyricsParams(songId: event.songId),
    );
    await result.fold(
      (failure) async {
        if (failure is ServerFailure && failure.statusCode == 404) {
          emit(LyricsNotFound(songId: event.songId));
        } else {
          emit(LyricsError(message: failure.message));
        }
      },
      (lyrics) async => emit(LyricsLoaded(lyrics: lyrics)),
    );
  }

  Future<void> _onCreate(
    LyricsCreateEvent event,
    Emitter<LyricsState> emit,
  ) async {
    emit(const LyricsSaving());
    final result = await _createSongLyricsUseCase(
      CreateSongLyricsParams(
        songId: event.songId,
        language: event.language,
        plainText: event.plainText,
        syncedLines: _parseSyncedLines(event.syncedLines),
      ),
    );
    await result.fold(
      (failure) async => emit(LyricsError(message: failure.message)),
      (lyrics) async => emit(LyricsSaved(lyrics: lyrics)),
    );
  }

  Future<void> _onUpdate(
    LyricsUpdateEvent event,
    Emitter<LyricsState> emit,
  ) async {
    emit(const LyricsSaving());
    final result = await _updateSongLyricsUseCase(
      UpdateSongLyricsParams(
        songId: event.songId,
        language: event.language,
        plainText: event.plainText,
        syncedLines: _parseSyncedLines(event.syncedLines),
      ),
    );
    await result.fold(
      (failure) async => emit(LyricsError(message: failure.message)),
      (lyrics) async => emit(LyricsSaved(lyrics: lyrics)),
    );
  }

  Future<void> _onDelete(
    LyricsDeleteEvent event,
    Emitter<LyricsState> emit,
  ) async {
    emit(const LyricsSaving());
    final result = await _deleteSongLyricsUseCase(
      DeleteSongLyricsParams(songId: event.songId),
    );
    await result.fold(
      (failure) async => emit(LyricsError(message: failure.message)),
      (_) async => emit(LyricsDeleted(songId: event.songId)),
    );
  }

  void _onReset(LyricsResetEvent event, Emitter<LyricsState> emit) {
    emit(const LyricsInitial());
  }

  List<SyncedLyricsLine>? _parseSyncedLines(
    List<Map<String, dynamic>>? lines,
  ) {
    if (lines == null) return null;
    return lines
        .map(
          (e) => SyncedLyricsLine(
            startMs: e['startMs'] as int,
            endMs: e['endMs'] as int?,
            lineText: e['lineText'] as String,
            lineIndex: e['lineIndex'] as int,
          ),
        )
        .toList();
  }
}
