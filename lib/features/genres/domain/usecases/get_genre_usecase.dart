import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/genres/domain/entities/genre.dart';

abstract class GetGenreUseCase {
  Future<Either<Failure, Genre>> call(GetGenreParams params);
}

class GetGenreParams extends Equatable {
  final int id;

  const GetGenreParams({required this.id});

  @override
  List<Object?> get props => [id];
}
