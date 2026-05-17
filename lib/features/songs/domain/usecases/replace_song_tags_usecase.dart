import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/tags/domain/entities/tag.dart';

abstract class ReplaceSongTagsUseCase {
  Future<Either<Failure, List<Tag>>> call(ReplaceSongTagsParams params);
}

class ReplaceSongTagsParams extends Equatable {
  final String songId;
  final List<int> tagIds;

  const ReplaceSongTagsParams({
    required this.songId,
    required this.tagIds,
  });

  @override
  List<Object?> get props => [songId, tagIds];
}
