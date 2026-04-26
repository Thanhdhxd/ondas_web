import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ondas_web/core/error/failures.dart';

abstract class DeleteArtistUseCase {
  Future<Either<Failure, void>> call(DeleteArtistParams params);
}

class DeleteArtistParams extends Equatable {
  final String id;

  const DeleteArtistParams({required this.id});

  @override
  List<Object?> get props => [id];
}
