import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/albums/domain/repositories/album_repository.dart';
import 'package:ondas_web/features/albums/domain/usecases/delete_album_usecase.dart';

class DeleteAlbumUseCaseImpl implements DeleteAlbumUseCase {
  final AlbumRepository _repository;

  const DeleteAlbumUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, void>> call(DeleteAlbumParams params) {
    return _repository.deleteAlbum(id: params.id);
  }
}
