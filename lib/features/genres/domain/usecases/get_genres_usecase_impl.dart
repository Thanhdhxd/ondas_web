import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/genres/domain/entities/genre.dart';
import 'package:ondas_web/features/genres/domain/repositories/genre_repository.dart';
import 'package:ondas_web/features/genres/domain/usecases/get_genres_usecase.dart';

class GetGenresUseCaseImpl implements GetGenresUseCase {
  final GenreRepository _repository;

  const GetGenresUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, PageResultDto<Genre>>> call(GetGenresParams params) {
    return _repository.getGenres(
      page: params.page,
      size: params.size,
      query: params.query,
    );
  }
}
