import 'package:dartz/dartz.dart';

import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/lyrics/domain/entities/lyrics.dart';
import 'package:ondas_web/features/lyrics/domain/repositories/lyrics_repository.dart';
import 'package:ondas_web/features/lyrics/domain/usecases/get_song_lyrics_usecase.dart';

class GetSongLyricsUseCaseImpl implements GetSongLyricsUseCase {
  final LyricsRepository _repository;

  const GetSongLyricsUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, Lyrics>> call(GetSongLyricsParams params) async {
    return _repository.getLyrics(songId: params.songId);
  }
}
