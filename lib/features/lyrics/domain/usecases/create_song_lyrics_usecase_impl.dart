import 'package:dartz/dartz.dart';

import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/lyrics/domain/entities/lyrics.dart';
import 'package:ondas_web/features/lyrics/domain/repositories/lyrics_repository.dart';
import 'package:ondas_web/features/lyrics/domain/usecases/create_song_lyrics_usecase.dart';

class CreateSongLyricsUseCaseImpl implements CreateSongLyricsUseCase {
  final LyricsRepository _repository;

  const CreateSongLyricsUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, Lyrics>> call(CreateSongLyricsParams params) async {
    return _repository.createLyrics(
      songId: params.songId,
      language: params.language,
      plainText: params.plainText,
      syncedLines: params.syncedLines,
    );
  }
}
