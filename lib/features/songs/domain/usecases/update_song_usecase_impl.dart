import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/songs/domain/entities/song.dart';
import 'package:ondas_web/features/songs/domain/repositories/song_repository.dart';
import 'package:ondas_web/features/songs/domain/usecases/update_song_usecase.dart';

class UpdateSongUseCaseImpl implements UpdateSongUseCase {
  final SongRepository _repository;

  const UpdateSongUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, Song>> call(UpdateSongParams params) {
    return _repository.updateSong(
      id: params.id,
      title: params.title,
      albumId: params.albumId,
      trackNumber: params.trackNumber,
      releaseDate: params.releaseDate,
      artistIds: params.artistIds,
      genreIds: params.genreIds,
      active: params.active,
      audioBytes: params.audioBytes,
      audioFileName: params.audioFileName,
      coverBytes: params.coverBytes,
      coverFileName: params.coverFileName,
    );
  }
}
