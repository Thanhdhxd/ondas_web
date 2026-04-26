import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/artists/domain/repositories/artist_repository.dart';
import 'package:ondas_web/features/artists/domain/usecases/delete_artist_usecase.dart';

class DeleteArtistUseCaseImpl implements DeleteArtistUseCase {
  final ArtistRepository _repository;

  const DeleteArtistUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, void>> call(DeleteArtistParams params) {
    return _repository.deleteArtist(id: params.id);
  }
}
