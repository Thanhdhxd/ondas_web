import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/albums/data/models/album_model.dart';

abstract class AlbumRemoteDataSource {
  Future<PageResultDto<AlbumModel>> getAlbums({
    required int page,
    required int size,
    String? query,
    String? mode,
  });

  Future<AlbumModel> getAlbum({required String id});

  Future<AlbumModel> createAlbum({
    required String title,
    String? slug,
    String? releaseDate,
    String? albumType,
    String? description,
    required List<String> artistIds,
    List<int>? coverBytes,
    String? coverFileName,
  });

  Future<AlbumModel> updateAlbum({
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

  Future<void> deleteAlbum({required String id});
}
