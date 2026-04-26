import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/artists/domain/entities/artist.dart';
import 'package:ondas_web/features/artists/domain/repositories/artist_repository.dart';
import 'package:ondas_web/features/artists/domain/usecases/get_artists_usecase.dart';

class GetArtistsUseCaseImpl implements GetArtistsUseCase {
  final ArtistRepository _repository;

  const GetArtistsUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, PageResultDto<Artist>>> call(GetArtistsParams params) {
    return _repository.getArtists(
      page: params.page,
      size: params.size,
      query: params.query,
    );
  }
}
