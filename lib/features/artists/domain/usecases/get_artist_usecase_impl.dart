import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/artists/domain/entities/artist.dart';
import 'package:ondas_web/features/artists/domain/repositories/artist_repository.dart';
import 'package:ondas_web/features/artists/domain/usecases/get_artist_usecase.dart';

class GetArtistUseCaseImpl implements GetArtistUseCase {
  final ArtistRepository _repository;

  const GetArtistUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, Artist>> call(GetArtistParams params) {
    return _repository.getArtist(id: params.id);
  }
}
