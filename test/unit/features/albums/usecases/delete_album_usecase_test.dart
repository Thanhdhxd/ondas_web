import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/albums/domain/repositories/album_repository.dart';
import 'package:ondas_web/features/albums/domain/usecases/delete_album_usecase.dart';
import 'package:ondas_web/features/albums/domain/usecases/delete_album_usecase_impl.dart';

class MockAlbumRepository extends Mock implements AlbumRepository {}

void main() {
  late DeleteAlbumUseCase useCase;
  late MockAlbumRepository mockRepository;

  const tParams = DeleteAlbumParams(id: 'uuid-1');

  setUp(() {
    mockRepository = MockAlbumRepository();
    useCase = DeleteAlbumUseCaseImpl(mockRepository);
  });

  group('DeleteAlbumUseCase', () {
    test('should return null when successful', () async {
      when(() => mockRepository.deleteAlbum(id: any(named: 'id')))
          .thenAnswer((_) async => const Right(null));

      final result = await useCase(tParams);

      expect(result, const Right(null));
      verify(() => mockRepository.deleteAlbum(id: tParams.id)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when request fails', () async {
      const failure = ServerFailure(message: 'Error', statusCode: 400);
      when(() => mockRepository.deleteAlbum(id: any(named: 'id')))
          .thenAnswer((_) async => const Left(failure));

      final result = await useCase(tParams);

      expect(result, const Left(failure));
    });
  });
}
