import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/albums/domain/entities/album.dart';

abstract class AlbumRepository {
  Future<Either<Failure, PageResultDto<Album>>> getAlbums({
    required int page,
    required int size,
    String? query,
    String? mode,
  });

  Future<Either<Failure, Album>> getAlbum({required String id});

  Future<Either<Failure, Album>> createAlbum({
    required String title,
    String? slug,
    String? releaseDate,
    String? albumType,
    String? description,
    required List<String> artistIds,
    List<int>? coverBytes,
    String? coverFileName,
  });

  Future<Either<Failure, Album>> updateAlbum({
    required String id,
    String? title,
    String? slug,
    String? releaseDate,
    String? albumType,
    String? description,
    List<String>? artistIds,
    List<int>? coverBytes,
    String? coverFileName,
  });

  Future<Either<Failure, void>> deleteAlbum({required String id});
}
