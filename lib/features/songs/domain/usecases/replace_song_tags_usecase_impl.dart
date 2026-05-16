import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/songs/domain/repositories/song_repository.dart';
import 'package:ondas_web/features/songs/domain/usecases/replace_song_tags_usecase.dart';
import 'package:ondas_web/features/tags/domain/entities/tag.dart';

class ReplaceSongTagsUseCaseImpl implements ReplaceSongTagsUseCase {
  final SongRepository _repository;

  const ReplaceSongTagsUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, List<Tag>>> call(ReplaceSongTagsParams params) {
    return _repository.replaceSongTags(
      songId: params.songId,
      tagIds: params.tagIds,
    );
  }
}
