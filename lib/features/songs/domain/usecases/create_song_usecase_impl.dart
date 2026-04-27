import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/songs/domain/entities/song.dart';
import 'package:ondas_web/features/songs/domain/repositories/song_repository.dart';
import 'package:ondas_web/features/songs/domain/usecases/create_song_usecase.dart';

class CreateSongUseCaseImpl implements CreateSongUseCase {
  final SongRepository _repository;

  const CreateSongUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, Song>> call(CreateSongParams params) {
    return _repository.createSong(
      title: params.title,
      albumId: params.albumId,
      trackNumber: params.trackNumber,
      releaseDate: params.releaseDate,
      artistIds: params.artistIds,
      genreIds: params.genreIds,
      audioBytes: params.audioBytes,
      audioFileName: params.audioFileName,
      coverBytes: params.coverBytes,
      coverFileName: params.coverFileName,
    );
  }
}
