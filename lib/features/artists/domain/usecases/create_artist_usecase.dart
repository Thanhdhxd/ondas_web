import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/artists/domain/entities/artist.dart';

abstract class CreateArtistUseCase {
  Future<Either<Failure, Artist>> call(CreateArtistParams params);
}

class CreateArtistParams extends Equatable {
  final String name;
  final String? slug;
  final String? bio;
  final String? country;
  final List<int>? avatarBytes;
  final String? avatarFileName;

  const CreateArtistParams({
    required this.name,
    this.slug,
    this.bio,
    this.country,
    this.avatarBytes,
    this.avatarFileName,
  });

  @override
  List<Object?> get props => [name, slug, bio, country, avatarFileName];
}
