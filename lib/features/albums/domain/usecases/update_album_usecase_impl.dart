import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/albums/domain/entities/album.dart';
import 'package:ondas_web/features/albums/domain/repositories/album_repository.dart';
import 'package:ondas_web/features/albums/domain/usecases/update_album_usecase.dart';

class UpdateAlbumUseCaseImpl implements UpdateAlbumUseCase {
  final AlbumRepository _repository;

  const UpdateAlbumUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, Album>> call(UpdateAlbumParams params) {
    return _repository.updateAlbum(
      id: params.id,
      title: params.title,
      slug: params.slug,
      releaseDate: params.releaseDate,
      albumType: params.albumType,
      description: params.description,
      artistIds: params.artistIds,
      coverBytes: params.coverBytes,
      coverFileName: params.coverFileName,
    );
  }
}
