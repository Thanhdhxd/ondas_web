import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/songs/domain/entities/song.dart';

abstract class GetSongUseCase {
  Future<Either<Failure, Song>> call(GetSongParams params);
}

class GetSongParams extends Equatable {
  final String id;

  const GetSongParams({required this.id});

  @override
  List<Object?> get props => [id];
}
