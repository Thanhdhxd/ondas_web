import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/songs/data/models/song_model.dart';

abstract class SongRemoteDataSource {
  Future<PageResultDto<SongModel>> getSongs({
    required int page,
    required int size,
    String? query,
    String? mode,
  });

  Future<SongModel> getSong({required String id});

  Future<SongModel> createSong({
    required String title,
    String? albumId,
    int? trackNumber,
    String? releaseDate,
    required List<String> artistIds,
    required List<int> genreIds,
    required List<int> audioBytes,
    required String audioFileName,
    List<int>? coverBytes,
    String? coverFileName,
    String? lyrics,
  });

  Future<SongModel> updateSong({
    required String id,
    String? title,
    String? albumId,
    int? trackNumber,
    String? releaseDate,
    List<String>? artistIds,
    List<int>? genreIds,
    bool? active,
    List<int>? audioBytes,
    String? audioFileName,
    List<int>? coverBytes,
    String? coverFileName,
  });

  Future<void> deleteSong({required String id});
}
