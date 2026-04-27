import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/genres/domain/entities/genre.dart';
import 'package:ondas_web/features/genres/domain/repositories/genre_repository.dart';
import 'package:ondas_web/features/genres/domain/usecases/create_genre_usecase.dart';

class CreateGenreUseCaseImpl implements CreateGenreUseCase {
  final GenreRepository _repository;

  const CreateGenreUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, Genre>> call(CreateGenreParams params) {
    return _repository.createGenre(
      name: params.name,
      slug: params.slug,
      description: params.description,
      coverUrl: params.coverUrl,
      coverBytes: params.coverBytes,
      coverFileName: params.coverFileName,
    );
  }
}
