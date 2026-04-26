import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/artists/domain/entities/artist.dart';

abstract class ArtistRepository {
  Future<Either<Failure, PageResultDto<Artist>>> getArtists({
    required int page,
    required int size,
    String? query,
  });

  Future<Either<Failure, Artist>> getArtist({required String id});

  Future<Either<Failure, Artist>> createArtist({
    required String name,
    String? slug,
    String? bio,
    String? country,
    List<int>? avatarBytes,
    String? avatarFileName,
  });

  Future<Either<Failure, Artist>> updateArtist({
    required String id,
    String? name,
    String? slug,
    String? bio,
    String? country,
    List<int>? avatarBytes,
    String? avatarFileName,
  });

  Future<Either<Failure, void>> deleteArtist({required String id});
}
