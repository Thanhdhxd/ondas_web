import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ondas_web/core/error/failures.dart';

abstract class DeleteAlbumUseCase {
  Future<Either<Failure, void>> call(DeleteAlbumParams params);
}

class DeleteAlbumParams extends Equatable {
  final String id;

  const DeleteAlbumParams({required this.id});

  @override
  List<Object?> get props => [id];
}
