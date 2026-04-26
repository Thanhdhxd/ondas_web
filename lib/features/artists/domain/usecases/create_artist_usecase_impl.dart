import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/artists/domain/entities/artist.dart';
import 'package:ondas_web/features/artists/domain/repositories/artist_repository.dart';
import 'package:ondas_web/features/artists/domain/usecases/create_artist_usecase.dart';

class CreateArtistUseCaseImpl implements CreateArtistUseCase {
  final ArtistRepository _repository;

  const CreateArtistUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, Artist>> call(CreateArtistParams params) {
    return _repository.createArtist(
      name: params.name,
      slug: params.slug,
      bio: params.bio,
      country: params.country,
      avatarBytes: params.avatarBytes,
      avatarFileName: params.avatarFileName,
    );
  }
}
