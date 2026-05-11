import 'package:dartz/dartz.dart';

import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/lyrics/domain/entities/lyrics.dart';
import 'package:ondas_web/features/lyrics/domain/repositories/lyrics_repository.dart';
import 'package:ondas_web/features/lyrics/domain/usecases/update_song_lyrics_usecase.dart';

class UpdateSongLyricsUseCaseImpl implements UpdateSongLyricsUseCase {
  final LyricsRepository _repository;

  const UpdateSongLyricsUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, Lyrics>> call(UpdateSongLyricsParams params) async {
    return _repository.updateLyrics(
      songId: params.songId,
      language: params.language,
      plainText: params.plainText,
      syncedLines: params.syncedLines,
    );
  }
}
