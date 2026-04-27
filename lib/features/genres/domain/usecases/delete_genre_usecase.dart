import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ondas_web/core/error/failures.dart';

abstract class DeleteGenreUseCase {
  Future<Either<Failure, void>> call(DeleteGenreParams params);
}

class DeleteGenreParams extends Equatable {
  final int id;

  const DeleteGenreParams({required this.id});

  @override
  List<Object?> get props => [id];
}
