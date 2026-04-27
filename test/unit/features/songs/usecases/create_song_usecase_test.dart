import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/songs/data/models/song_model.dart';
import 'package:ondas_web/features/songs/domain/repositories/song_repository.dart';
import 'package:ondas_web/features/songs/domain/usecases/create_song_usecase.dart';
import 'package:ondas_web/features/songs/domain/usecases/create_song_usecase_impl.dart';

class MockSongRepository extends Mock implements SongRepository {}

void main() {
  late CreateSongUseCase useCase;
  late MockSongRepository mockRepository;

  const tSong = SongModel(
    id: 'uuid-1',
    title: 'Noi nay co anh',
    active: true,
  );

  const tParams = CreateSongParams(
    title: 'Noi nay co anh',
    artistIds: ['artist-1'],
    genreIds: [1],
    audioBytes: [1, 2, 3],
    audioFileName: 'song.mp3',
  );

  setUp(() {
    mockRepository = MockSongRepository();
    useCase = CreateSongUseCaseImpl(mockRepository);
  });

  group('CreateSongUseCase', () {
    test('should return Song when creation succeeds', () async {
      when(
        () => mockRepository.createSong(
          title: any(named: 'title'),
          albumId: any(named: 'albumId'),
          trackNumber: any(named: 'trackNumber'),
          releaseDate: any(named: 'releaseDate'),
          artistIds: any(named: 'artistIds'),
          genreIds: any(named: 'genreIds'),
          audioBytes: any(named: 'audioBytes'),
          audioFileName: any(named: 'audioFileName'),
          coverBytes: any(named: 'coverBytes'),
          coverFileName: any(named: 'coverFileName'),
        ),
      ).thenAnswer((_) async => const Right(tSong));

      final result = await useCase(tParams);

      expect(result, const Right(tSong));
      verify(
        () => mockRepository.createSong(
          title: tParams.title,
          albumId: tParams.albumId,
          trackNumber: tParams.trackNumber,
          releaseDate: tParams.releaseDate,
          artistIds: tParams.artistIds,
          genreIds: tParams.genreIds,
          audioBytes: tParams.audioBytes,
          audioFileName: tParams.audioFileName,
          coverBytes: tParams.coverBytes,
          coverFileName: tParams.coverFileName,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when creation fails', () async {
      const failure = ServerFailure(message: 'Validation error', statusCode: 400);
      when(
        () => mockRepository.createSong(
          title: any(named: 'title'),
          albumId: any(named: 'albumId'),
          trackNumber: any(named: 'trackNumber'),
          releaseDate: any(named: 'releaseDate'),
          artistIds: any(named: 'artistIds'),
          genreIds: any(named: 'genreIds'),
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
