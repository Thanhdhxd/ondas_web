import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/songs/data/models/song_model.dart';
import 'package:ondas_web/features/songs/domain/repositories/song_repository.dart';
import 'package:ondas_web/features/songs/domain/usecases/update_song_usecase.dart';
import 'package:ondas_web/features/songs/domain/usecases/update_song_usecase_impl.dart';

class MockSongRepository extends Mock implements SongRepository {}

void main() {
  late UpdateSongUseCase useCase;
  late MockSongRepository mockRepository;

  const tSong = SongModel(
    id: 'uuid-1',
    title: 'Noi nay co anh (Remix)',
    active: true,
  );

  const tParams = UpdateSongParams(id: 'uuid-1', title: 'Noi nay co anh (Remix)');

  setUp(() {
    mockRepository = MockSongRepository();
    useCase = UpdateSongUseCaseImpl(mockRepository);
  });

  group('UpdateSongUseCase', () {
    test('should return updated Song when update succeeds', () async {
      when(
        () => mockRepository.updateSong(
          id: any(named: 'id'),
          title: any(named: 'title'),
          albumId: any(named: 'albumId'),
          trackNumber: any(named: 'trackNumber'),
          releaseDate: any(named: 'releaseDate'),
          artistIds: any(named: 'artistIds'),
          genreIds: any(named: 'genreIds'),
          active: any(named: 'active'),
          audioBytes: any(named: 'audioBytes'),
          audioFileName: any(named: 'audioFileName'),
          coverBytes: any(named: 'coverBytes'),
          coverFileName: any(named: 'coverFileName'),
        ),
      ).thenAnswer((_) async => const Right(tSong));

      final result = await useCase(tParams);

      expect(result, const Right(tSong));
      verify(
        () => mockRepository.updateSong(
          id: tParams.id,
          title: tParams.title,
          albumId: tParams.albumId,
          trackNumber: tParams.trackNumber,
          releaseDate: tParams.releaseDate,
          artistIds: tParams.artistIds,
          genreIds: tParams.genreIds,
          active: tParams.active,
          audioBytes: tParams.audioBytes,
          audioFileName: tParams.audioFileName,
          coverBytes: tParams.coverBytes,
          coverFileName: tParams.coverFileName,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when update fails', () async {
      const failure = ServerFailure(message: 'Not found', statusCode: 404);
      when(
        () => mockRepository.updateSong(
          id: any(named: 'id'),
          title: any(named: 'title'),
          albumId: any(named: 'albumId'),
          trackNumber: any(named: 'trackNumber'),
          releaseDate: any(named: 'releaseDate'),
          artistIds: any(named: 'artistIds'),
          genreIds: any(named: 'genreIds'),
          active: any(named: 'active'),
          audioBytes: any(named: 'audioBytes'),
          audioFileName: any(named: 'audioFileName'),
          coverBytes: any(named: 'coverBytes'),
          coverFileName: any(named: 'coverFileName'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase(tParams);

      expect(result, const Left(failure));
    });
  });
}
