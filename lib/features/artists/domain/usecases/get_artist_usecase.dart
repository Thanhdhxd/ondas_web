import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/artists/domain/entities/artist.dart';

abstract class GetArtistUseCase {
  Future<Either<Failure, Artist>> call(GetArtistParams params);
}

class GetArtistParams extends Equatable {
  final String id;

  const GetArtistParams({required this.id});

  @override
  List<Object?> get props => [id];
}
