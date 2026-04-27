import 'package:dartz/dartz.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/songs/domain/entities/song.dart';
import 'package:ondas_web/features/songs/domain/repositories/song_repository.dart';
import 'package:ondas_web/features/songs/domain/usecases/get_songs_usecase.dart';

class GetSongsUseCaseImpl implements GetSongsUseCase {
  final SongRepository _repository;

  const GetSongsUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, PageResultDto<Song>>> call(GetSongsParams params) {
    return _repository.getSongs(
      page: params.page,
      size: params.size,
      query: params.query,
    );
  }
}
