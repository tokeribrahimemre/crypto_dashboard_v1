import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:marsky_crypto_dashboard/core/error/failures.dart';
import 'package:marsky_crypto_dashboard/features/auth/domain/repositories/auth_repository.dart';
import 'package:marsky_crypto_dashboard/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:marsky_crypto_dashboard/features/auth/presentation/bloc/auth_event.dart';
import 'package:marsky_crypto_dashboard/features/auth/presentation/bloc/auth_state.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthBloc bloc;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    bloc = AuthBloc(authRepository: mockAuthRepository);
  });

  const tEmail = 'test@test.com';
  const tPassword = 'password123';
  const tUserId = 'user-123';

  test('initial state should be AuthInitial', () {
    expect(bloc.state, AuthInitial());
  });

  blocTest<AuthBloc, AuthState>(
    'should emit [AuthLoading, Authenticated] when sign in is successful',
    build: () {
      when(() => mockAuthRepository.signIn(tEmail, tPassword))
          .thenAnswer((_) async => const Right(tUserId));
      return bloc;
    },
    act: (bloc) => bloc.add(const SignInEvent(email: tEmail, password: tPassword)),
    expect: () => [
      AuthLoading(),
      const Authenticated(userId: tUserId),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'should emit [AuthLoading, AuthError] when sign in fails',
    build: () {
      when(() => mockAuthRepository.signIn(tEmail, tPassword))
          .thenAnswer((_) async => Left(ServerFailure()));
      return bloc;
    },
    act: (bloc) => bloc.add(const SignInEvent(email: tEmail, password: tPassword)),
    expect: () => [
      AuthLoading(),
      const AuthError(message: 'Giriş başarısız. Lütfen bilgilerinizi kontrol edin.'),
    ],
  );
}