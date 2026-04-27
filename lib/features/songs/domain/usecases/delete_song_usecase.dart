import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ondas_web/core/error/failures.dart';

abstract class DeleteSongUseCase {
  Future<Either<Failure, void>> call(DeleteSongParams params);
}

class DeleteSongParams extends Equatable {
  final String id;

  const DeleteSongParams({required this.id});

  @override
  List<Object?> get props => [id];
}
