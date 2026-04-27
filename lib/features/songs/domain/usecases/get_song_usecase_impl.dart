import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/songs/domain/entities/song.dart';
import 'package:ondas_web/features/songs/domain/repositories/song_repository.dart';
import 'package:ondas_web/features/songs/domain/usecases/get_song_usecase.dart';

class GetSongUseCaseImpl implements GetSongUseCase {
  final SongRepository _repository;

  const GetSongUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, Song>> call(GetSongParams params) {
    return _repository.getSong(id: params.id);
  }
}
