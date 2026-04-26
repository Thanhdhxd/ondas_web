import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/artists/domain/entities/artist.dart';

abstract class UpdateArtistUseCase {
  Future<Either<Failure, Artist>> call(UpdateArtistParams params);
}

class UpdateArtistParams extends Equatable {
  final String id;
  final String? name;
  final String? slug;
  final String? bio;
  final String? country;
  final List<int>? avatarBytes;
  final String? avatarFileName;

  const UpdateArtistParams({
    required this.id,
    this.name,
    this.slug,
    this.bio,
    this.country,
    this.avatarBytes,
    this.avatarFileName,
  });

  @override
  List<Object?> get props => [id, name, slug, bio, country, avatarFileName];
}
