import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/albums/domain/entities/album.dart';
import 'package:ondas_web/features/albums/domain/repositories/album_repository.dart';
import 'package:ondas_web/features/albums/domain/usecases/get_albums_usecase.dart';

class GetAlbumsUseCaseImpl implements GetAlbumsUseCase {
  final AlbumRepository _repository;

  const GetAlbumsUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, PageResultDto<Album>>> call(GetAlbumsParams params) {
    return _repository.getAlbums(
      page: params.page,
      size: params.size,
      query: params.query,
    );
  }
}
