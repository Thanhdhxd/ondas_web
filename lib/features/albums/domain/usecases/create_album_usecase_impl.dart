import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/albums/domain/entities/album.dart';
import 'package:ondas_web/features/albums/domain/repositories/album_repository.dart';
import 'package:ondas_web/features/albums/domain/usecases/create_album_usecase.dart';

class CreateAlbumUseCaseImpl implements CreateAlbumUseCase {
  final AlbumRepository _repository;

  const CreateAlbumUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, Album>> call(CreateAlbumParams params) {
    return _repository.createAlbum(
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
