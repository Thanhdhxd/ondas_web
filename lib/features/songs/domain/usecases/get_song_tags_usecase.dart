import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/tags/domain/entities/tag.dart';

abstract class GetSongTagsUseCase {
  Future<Either<Failure, List<Tag>>> call(GetSongTagsParams params);
}

class GetSongTagsParams extends Equatable {
  final String songId;

  const GetSongTagsParams({required this.songId});

  @override
  List<Object?> get props => [songId];
}
