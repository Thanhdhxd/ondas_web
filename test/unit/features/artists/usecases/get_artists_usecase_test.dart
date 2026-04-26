import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/artists/data/models/artist_model.dart';
import 'package:ondas_web/features/artists/domain/repositories/artist_repository.dart';
import 'package:ondas_web/features/artists/domain/usecases/get_artists_usecase.dart';
import 'package:ondas_web/features/artists/domain/usecases/get_artists_usecase_impl.dart';

class MockArtistRepository extends Mock implements ArtistRepository {}

void main() {
  late GetArtistsUseCase useCase;
  late MockArtistRepository mockRepository;

  const tArtist = ArtistModel(
    id: 'uuid-1',
    name: 'Sơn Tùng M-TP',
    slug: 'son-tung-m-tp',
    country: 'Vietnam',
  );

  final tPage = PageResultDto<ArtistModel>(
    items: [tArtist],
    page: 0,
    size: 20,
    totalElements: 1,
    totalPages: 1,
  );

  const tParams = GetArtistsParams(page: 0, size: 20);

  setUp(() {
    mockRepository = MockArtistRepository();
    useCase = GetArtistsUseCaseImpl(mockRepository);
  });

  group('GetArtistsUseCase', () {
    test('should return page of artists when successful', () async {
      when(
        () => mockRepository.getArtists(
          page: any(named: 'page'),
          size: any(named: 'size'),
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) async => Right(tPage));

      final result = await useCase(tParams);

      expect(result, Right(tPage));
      verify(
        () => mockRepository.getArtists(
          page: tParams.page,
          size: tParams.size,
          query: tParams.query,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when request fails', () async {
      const failure =
          ServerFailure(message: 'Server error', statusCode: 500);
      when(
        () => mockRepository.getArtists(
          page: any(named: 'page'),
          size: any(named: 'size'),
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase(tParams);

      expect(result, const Left(failure));
    });

    test('should pass query param when provided', () async {
      const paramsWithQuery =
          GetArtistsParams(page: 0, size: 20, query: 'son tung');
      when(
        () => mockRepository.getArtists(
          page: any(named: 'page'),
          size: any(named: 'size'),
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) async => Right(tPage));

      await useCase(paramsWithQuery);

      verify(
        () => mockRepository.getArtists(
          page: 0,
          size: 20,
          query: 'son tung',
        ),
      ).called(1);
    });
  });
}
