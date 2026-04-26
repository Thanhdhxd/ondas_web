import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/artists/domain/entities/artist.dart';
import 'package:ondas_web/features/artists/domain/repositories/artist_repository.dart';
import 'package:ondas_web/features/artists/domain/usecases/update_artist_usecase.dart';

class UpdateArtistUseCaseImpl implements UpdateArtistUseCase {
  final ArtistRepository _repository;

  const UpdateArtistUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, Artist>> call(UpdateArtistParams params) {
    return _repository.updateArtist(
      id: params.id,
      name: params.name,
      slug: params.slug,
      bio: params.bio,
      country: params.country,
      avatarBytes: params.avatarBytes,
      avatarFileName: params.avatarFileName,
    );
  }
}
