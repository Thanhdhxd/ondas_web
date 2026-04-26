import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ondas_web/core/error/failures.dart';
import 'package:ondas_web/features/auth/data/models/auth_response_model.dart';
import 'package:ondas_web/features/auth/data/models/user_model.dart';
import 'package:ondas_web/features/auth/domain/usecases/login_usecase.dart';
import 'package:ondas_web/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ondas_web/features/auth/presentation/bloc/auth_event.dart';
import 'package:ondas_web/features/auth/presentation/bloc/auth_state.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late AuthBloc bloc;
  late MockLoginUseCase mockLoginUseCase;

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

  setUpAll(() {
    registerFallbackValue(
      const LoginParams(email: 'test@test.com', password: 'password'),
    );
  });

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    bloc = AuthBloc(loginUseCase: mockLoginUseCase);
  });

  tearDown(() => bloc.close());

  test('initial state is AuthInitial', () {
    expect(bloc.state, const AuthInitial());
  });

  group('LoginSubmitted', () {
    const tEvent = LoginSubmitted(
      email: 'admin@example.com',
      password: 'password123',
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess] when login succeeds',
      build: () {
        when(() => mockLoginUseCase(any()))
            .thenAnswer((_) async => Right(tAuthResponse));
        return bloc;
      },
      act: (b) => b.add(tEvent),
      expect: () => [
        const AuthLoading(),
        AuthSuccess(authResponse: tAuthResponse),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure] when credentials are invalid',
      build: () {
        when(() => mockLoginUseCase(any())).thenAnswer(
          (_) async => const Left(
            ServerFailure(message: 'Email hoặc mật khẩu không đúng', statusCode: 401),
          ),
        );
        return bloc;
      },
      act: (b) => b.add(tEvent),
      expect: () => [
        const AuthLoading(),
        const AuthFailure(message: 'Email hoặc mật khẩu không đúng'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure] on network error',
      build: () {
        when(() => mockLoginUseCase(any())).thenAnswer(
          (_) async => const Left(
            NetworkFailure(message: 'Không có kết nối mạng'),
          ),
        );
        return bloc;
      },
      act: (b) => b.add(tEvent),
      expect: () => [
        const AuthLoading(),
        const AuthFailure(message: 'Không có kết nối mạng'),
      ],
    );
  });
}
