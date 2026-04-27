import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/genres/domain/entities/genre.dart';

abstract class UpdateGenreUseCase {
  Future<Either<Failure, Genre>> call(UpdateGenreParams params);
}

class UpdateGenreParams extends Equatable {
  final int id;
  final String? name;
  final String? slug;
  final String? description;
  final String? coverUrl;
  final List<int>? coverBytes;
  final String? coverFileName;

  const UpdateGenreParams({
    required this.id,
    this.name,
    this.slug,
    this.description,
    this.coverUrl,
    this.coverBytes,
    this.coverFileName,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    description,
    coverUrl,
    coverFileName,
  ];
}
