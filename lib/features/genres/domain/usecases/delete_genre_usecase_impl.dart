import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/genres/domain/repositories/genre_repository.dart';
import 'package:ondas_web/features/genres/domain/usecases/delete_genre_usecase.dart';

class DeleteGenreUseCaseImpl implements DeleteGenreUseCase {
  final GenreRepository _repository;

  const DeleteGenreUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, void>> call(DeleteGenreParams params) {
    return _repository.deleteGenre(id: params.id);
  }
}
