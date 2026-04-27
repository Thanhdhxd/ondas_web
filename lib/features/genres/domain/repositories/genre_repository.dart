import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/genres/domain/entities/genre.dart';

abstract class GenreRepository {
  Future<Either<Failure, PageResultDto<Genre>>> getGenres({
    required int page,
    required int size,
    String? query,
  });

  Future<Either<Failure, Genre>> getGenre({required int id});

  Future<Either<Failure, Genre>> createGenre({
    required String name,
    String? slug,
    String? description,
    String? coverUrl,
    List<int>? coverBytes,
    String? coverFileName,
  });

  Future<Either<Failure, Genre>> updateGenre({
    required int id,
    String? name,
    String? slug,
    String? description,
    String? coverUrl,
    List<int>? coverBytes,
    String? coverFileName,
  });

  Future<Either<Failure, void>> deleteGenre({required int id});
}
