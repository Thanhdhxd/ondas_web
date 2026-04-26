import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/artists/data/models/artist_model.dart';

abstract class ArtistRemoteDataSource {
  Future<PageResultDto<ArtistModel>> getArtists({
    required int page,
    required int size,
    String? query,
  });

  Future<ArtistModel> getArtist({required String id});

  Future<ArtistModel> createArtist({
    required String name,
    String? slug,
    String? bio,
    String? country,
    List<int>? avatarBytes,
    String? avatarFileName,
  });

  Future<ArtistModel> updateArtist({
    required String id,
    String? name,
    String? slug,
    String? bio,
    String? country,
    List<int>? avatarBytes,
    String? avatarFileName,
  });

  Future<void> deleteArtist({required String id});
}
