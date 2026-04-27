import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/albums/domain/entities/album.dart';

abstract class GetAlbumUseCase {
  Future<Either<Failure, Album>> call(GetAlbumParams params);
}

class GetAlbumParams extends Equatable {
  final String id;

  const GetAlbumParams({required this.id});

  @override
  List<Object?> get props => [id];
}
