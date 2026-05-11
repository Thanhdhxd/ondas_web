import 'package:dartz/dartz.dart';

import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/lyrics/domain/repositories/lyrics_repository.dart';
import 'package:ondas_web/features/lyrics/domain/usecases/delete_song_lyrics_usecase.dart';

class DeleteSongLyricsUseCaseImpl implements DeleteSongLyricsUseCase {
  final LyricsRepository _repository;

  const DeleteSongLyricsUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, void>> call(DeleteSongLyricsParams params) async {
    return _repository.deleteLyrics(songId: params.songId);
  }
}
