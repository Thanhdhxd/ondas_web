import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/genres/data/models/genre_model.dart';

abstract class GenreRemoteDataSource {
  Future<PageResultDto<GenreModel>> getGenres({
    required int page,
    required int size,
    String? query,
  });

  Future<GenreModel> getGenre({required int id});

  Future<GenreModel> createGenre({
    required String name,
    String? slug,
    String? description,
    String? coverUrl,
    List<int>? coverBytes,
    String? coverFileName,
  });

  Future<GenreModel> updateGenre({
    required int id,
    String? name,
    String? slug,
    String? description,
    String? coverUrl,
    List<int>? coverBytes,
    String? coverFileName,
  });

  Future<void> deleteGenre({required int id});
}
