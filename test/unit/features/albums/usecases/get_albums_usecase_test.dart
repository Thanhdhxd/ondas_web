import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/core/network/api_response.dart';
import 'package:ondas_web/features/albums/data/models/album_model.dart';
import 'package:ondas_web/features/albums/domain/repositories/album_repository.dart';
import 'package:ondas_web/features/albums/domain/usecases/get_albums_usecase.dart';
import 'package:ondas_web/features/albums/domain/usecases/get_albums_usecase_impl.dart';

class MockAlbumRepository extends Mock implements AlbumRepository {}

void main() {
  late GetAlbumsUseCase useCase;
  late MockAlbumRepository mockRepository;

  const tAlbum = AlbumModel(
    id: 'uuid-1',
    title: 'Test Album',
    artistNames: ['Artist 1'],
  );

  final tPage = PageResultDto<AlbumModel>(
    items: [tAlbum],
    page: 0,
    size: 20,
    totalElements: 1,
    totalPages: 1,
  );

  const tParams = GetAlbumsParams(page: 0, size: 20);

  setUp(() {
    mockRepository = MockAlbumRepository();
    useCase = GetAlbumsUseCaseImpl(mockRepository);
  });

  group('GetAlbumsUseCase', () {
    test('should return page of albums when successful', () async {
      when(
        () => mockRepository.getAlbums(
          page: any(named: 'page'),
          size: any(named: 'size'),
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) async => Right(tPage));

      final result = await useCase(tParams);

      expect(result, Right(tPage));
      verify(
        () => mockRepository.getAlbums(
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
        () => mockRepository.getAlbums(
          page: any(named: 'page'),
          size: any(named: 'size'),
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase(tParams);

      expect(result, const Left(failure));
    });
  });
}
