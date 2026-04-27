import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/albums/domain/entities/album.dart';

abstract class UpdateAlbumUseCase {
  Future<Either<Failure, Album>> call(UpdateAlbumParams params);
}

class UpdateAlbumParams extends Equatable {
  final String id;
  final String? title;
  final String? slug;
  final String? releaseDate;
  final String? albumType;
  final String? description;
  final List<String>? artistIds;
  final List<int>? coverBytes;
  final String? coverFileName;

  const UpdateAlbumParams({
    required this.id,
    this.title,
    this.slug,
    this.releaseDate,
    this.albumType,
    this.description,
    this.artistIds,
    this.coverBytes,
    this.coverFileName,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        slug,
        releaseDate,
        albumType,
        description,
        artistIds,
        coverFileName,
      ];
}
