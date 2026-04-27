import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/genres/domain/entities/genre.dart';
import 'package:ondas_web/features/genres/domain/repositories/genre_repository.dart';
import 'package:ondas_web/features/genres/domain/usecases/update_genre_usecase.dart';

class UpdateGenreUseCaseImpl implements UpdateGenreUseCase {
  final GenreRepository _repository;

  const UpdateGenreUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, Genre>> call(UpdateGenreParams params) {
    return _repository.updateGenre(
      id: params.id,
      name: params.name,
      slug: params.slug,
      description: params.description,
      coverUrl: params.coverUrl,
      coverBytes: params.coverBytes,
      coverFileName: params.coverFileName,
    );
  }
}
