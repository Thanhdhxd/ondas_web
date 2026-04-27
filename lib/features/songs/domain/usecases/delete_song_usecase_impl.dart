import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/songs/domain/repositories/song_repository.dart';
import 'package:ondas_web/features/songs/domain/usecases/delete_song_usecase.dart';

class DeleteSongUseCaseImpl implements DeleteSongUseCase {
  final SongRepository _repository;

  const DeleteSongUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, void>> call(DeleteSongParams params) {
    return _repository.deleteSong(id: params.id);
  }
}
