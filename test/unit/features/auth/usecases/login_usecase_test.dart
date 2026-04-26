import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/auth/data/models/auth_response_model.dart';
import 'package:ondas_web/features/auth/data/models/user_model.dart';
import 'package:ondas_web/features/auth/domain/repositories/auth_repository.dart';
import 'package:ondas_web/features/auth/domain/usecases/login_usecase.dart';
import 'package:ondas_web/features/auth/domain/usecases/login_usecase_impl.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  final tUser = UserModel(
    id: 'uuid-1',
    email: 'admin@example.com',
    displayName: 'Admin',
    role: 'ADMIN',
  );

  final tAuthResponse = AuthResponseModel(
    accessToken: 'access-token',
    refreshToken: 'refresh-token',
    user: tUser,
  );

  const tParams = LoginParams(
    email: 'admin@example.com',
    password: 'password123',
  );

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCaseImpl(mockRepository);
  });

  group('LoginUseCase', () {
    test('should return AuthResponse when login succeeds', () async {
      when(
        () => mockRepository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => Right(tAuthResponse));

      final result = await useCase(tParams);

      expect(result, Right(tAuthResponse));
      verify(
        () => mockRepository.login(
          email: tParams.email,
          password: tParams.password,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when login fails', () async {
      const failure = ServerFailure(
        message: 'Invalid credentials',
        statusCode: 401,
      );
      when(
        () => mockRepository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase(tParams);

      expect(result, const Left(failure));
    });

    test('should return NetworkFailure on network error', () async {
      const failure = NetworkFailure(message: 'No internet connection');
      when(
        () => mockRepository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase(tParams);

      expect(result, const Left(failure));
    });

    test(
        'should return InsufficientRoleFailure when user role is not allowed',
        () async {
      const failure = InsufficientRoleFailure();
      when(
        () => mockRepository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase(tParams);

      expect(result, const Left(failure));
    });
  });
}
