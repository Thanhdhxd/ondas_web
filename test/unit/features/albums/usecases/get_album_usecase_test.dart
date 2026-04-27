import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/albums/data/models/album_model.dart';
import 'package:ondas_web/features/albums/domain/repositories/album_repository.dart';
import 'package:ondas_web/features/albums/domain/usecases/get_album_usecase.dart';
import 'package:ondas_web/features/albums/domain/usecases/get_album_usecase_impl.dart';

class MockAlbumRepository extends Mock implements AlbumRepository {}

void main() {
  late GetAlbumUseCase useCase;
  late MockAlbumRepository mockRepository;

  const tAlbum = AlbumModel(
    id: 'uuid-1',
    title: 'Test Album',
    slug: 'test-album',
    albumType: 'ALBUM',
    artistNames: ['Artist 1'],
    artistIds: ['artist-uuid-1'],
  );

  const tParams = GetAlbumParams(id: 'uuid-1');

  setUpAll(() {
    registerFallbackValue(tParams);
  });

  setUp(() {
    mockRepository = MockAlbumRepository();
    useCase = GetAlbumUseCaseImpl(mockRepository);
  });

  group('GetAlbumUseCase', () {
    test('should return album when repository call is successful', () async {
      when(() => mockRepository.getAlbum(id: any(named: 'id')))
          .thenAnswer((_) async => const Right(tAlbum));

      final result = await useCase(tParams);

      expect(result, const Right(tAlbum));
      verify(() => mockRepository.getAlbum(id: 'uuid-1')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when album is not found (404)', () async {
      const failure = ServerFailure(message: 'Album not found', statusCode: 404);
      when(() => mockRepository.getAlbum(id: any(named: 'id')))
          .thenAnswer((_) async => const Left(failure));

      final result = await useCase(tParams);

      expect(result, const Left(failure));
      verify(() => mockRepository.getAlbum(id: 'uuid-1')).called(1);
    });

    test('should return NetworkFailure when there is no connection', () async {
      const failure = NetworkFailure(message: 'No internet connection');
      when(() => mockRepository.getAlbum(id: any(named: 'id')))
          .thenAnswer((_) async => const Left(failure));

      final result = await useCase(tParams);

      expect(result, const Left(failure));
    });

    test('should call repository with the exact id from params', () async {
      const otherId = 'other-uuid-99';
      const otherParams = GetAlbumParams(id: otherId);
      const otherAlbum = AlbumModel(id: otherId, title: 'Other Album', artistNames: []);

      when(() => mockRepository.getAlbum(id: otherId))
          .thenAnswer((_) async => const Right(otherAlbum));

      final result = await useCase(otherParams);

      expect(result, const Right(otherAlbum));
      verify(() => mockRepository.getAlbum(id: otherId)).called(1);
      verifyNever(() => mockRepository.getAlbum(id: 'uuid-1'));
    });
  });
}
