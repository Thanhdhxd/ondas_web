import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/songs/domain/repositories/song_repository.dart';
import 'package:ondas_web/features/songs/domain/usecases/get_song_tags_usecase.dart';
import 'package:ondas_web/features/tags/domain/entities/tag.dart';

class GetSongTagsUseCaseImpl implements GetSongTagsUseCase {
  final SongRepository _repository;

  const GetSongTagsUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, List<Tag>>> call(GetSongTagsParams params) {
    return _repository.getSongTags(songId: params.songId);
  }
}
