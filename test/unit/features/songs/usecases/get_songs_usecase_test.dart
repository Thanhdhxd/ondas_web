import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/songs/data/models/song_model.dart';
import 'package:ondas_web/features/songs/domain/repositories/song_repository.dart';
import 'package:ondas_web/features/songs/domain/usecases/get_songs_usecase.dart';
import 'package:ondas_web/features/songs/domain/usecases/get_songs_usecase_impl.dart';

class MockSongRepository extends Mock implements SongRepository {}

void main() {
  late GetSongsUseCase useCase;
  late MockSongRepository mockRepository;

  const tSong = SongModel(
    id: 'uuid-1',
    title: 'Noi nay co anh',
    slug: 'noi-nay-co-anh',
    active: true,
  );

  final tPage = PageResultDto<SongModel>(
    items: const [tSong],
    page: 0,
    size: 20,
    totalElements: 1,
    totalPages: 1,
  );

  const tParams = GetSongsParams(page: 0, size: 20);

  setUp(() {
    mockRepository = MockSongRepository();
    useCase = GetSongsUseCaseImpl(mockRepository);
  });

  group('GetSongsUseCase', () {
    test('should return page of songs when successful', () async {
      when(
        () => mockRepository.getSongs(
          page: any(named: 'page'),
          size: any(named: 'size'),
          query: any(named: 'query'),
          mode: any(named: 'mode'),
        ),
      ).thenAnswer((_) async => Right(tPage));

      final result = await useCase(tParams);

      expect(result, Right(tPage));
      verify(
        () => mockRepository.getSongs(
          page: tParams.page,
          size: tParams.size,
          query: tParams.query,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when request fails', () async {
      const failure = ServerFailure(message: 'Server error', statusCode: 500);
      when(
        () => mockRepository.getSongs(
          page: any(named: 'page'),
          size: any(named: 'size'),
          query: any(named: 'query'),
          mode: any(named: 'mode'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase(tParams);

      expect(result, const Left(failure));
    });

    test('should pass query param when provided', () async {
      const paramsWithQuery = GetSongsParams(page: 0, size: 20, query: 'son tung');
      when(
        () => mockRepository.getSongs(
          page: any(named: 'page'),
          size: any(named: 'size'),
          query: any(named: 'query'),
          mode: any(named: 'mode'),
        ),
      ).thenAnswer((_) async => Right(tPage));

      await useCase(paramsWithQuery);

      verify(() => mockRepository.getSongs(page: 0, size: 20, query: 'son tung'))
          .called(1);
    });
  });
}
