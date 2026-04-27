import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/genres/domain/entities/genre.dart';
import 'package:ondas_web/features/genres/domain/repositories/genre_repository.dart';
import 'package:ondas_web/features/genres/domain/usecases/get_genre_usecase.dart';

class GetGenreUseCaseImpl implements GetGenreUseCase {
  final GenreRepository _repository;

  const GetGenreUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, Genre>> call(GetGenreParams params) {
    return _repository.getGenre(id: params.id);
  }
}
