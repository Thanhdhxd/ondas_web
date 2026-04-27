import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/albums/domain/entities/album.dart';
import 'package:ondas_web/features/albums/domain/repositories/album_repository.dart';
import 'package:ondas_web/features/albums/domain/usecases/get_album_usecase.dart';

class GetAlbumUseCaseImpl implements GetAlbumUseCase {
  final AlbumRepository _repository;

  const GetAlbumUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, Album>> call(GetAlbumParams params) {
    return _repository.getAlbum(id: params.id);
  }
}
