import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:marsky_crypto_dashboard/core/error/failures.dart';
import 'package:marsky_crypto_dashboard/features/crypto/domain/entities/crypto_entity.dart';
import 'package:marsky_crypto_dashboard/features/crypto/domain/usecases/get_cryptos_usecase.dart';
import 'package:marsky_crypto_dashboard/features/crypto/domain/usecases/toggle_favorite_usecase.dart';
import 'package:marsky_crypto_dashboard/features/crypto/presentation/bloc/crypto_bloc.dart';
import 'package:marsky_crypto_dashboard/features/crypto/presentation/bloc/crypto_event.dart';
import 'package:marsky_crypto_dashboard/features/crypto/presentation/bloc/crypto_state.dart';

class MockGetCryptosUseCase extends Mock implements GetCryptosUseCase {}
class MockToggleFavoriteUseCase extends Mock implements ToggleFavoriteUseCase {}

void main() {
  late CryptoBloc bloc;
  late MockGetCryptosUseCase mockGetCryptosUseCase;
  late MockToggleFavoriteUseCase mockToggleFavoriteUseCase;

  setUp(() {
    mockGetCryptosUseCase = MockGetCryptosUseCase();
    mockToggleFavoriteUseCase = MockToggleFavoriteUseCase();
    bloc = CryptoBloc(
      getCryptosUseCase: mockGetCryptosUseCase,
      toggleFavoriteUseCase: mockToggleFavoriteUseCase,
    );
  });

  final tCryptoList = [
    const CryptoEntity(
      id: '1', rank: 1, symbol: 'BTC', name: 'Bitcoin', price: 50000.0, 
      change: 2.5, marketCap: 1000000.0, listedAt: 123456789, 
      iconUrl: 'url', sparkline: [],
      volume: 5000000.0,
    )
  ];

  test('initial state should be CryptoInitial', () {
    expect(bloc.state, CryptoInitial());
  });

  blocTest<CryptoBloc, CryptoState>(
    'should emit [CryptoLoading, CryptoLoaded] when data is gotten successfully',
    build: () {
      when(() => mockGetCryptosUseCase(limit: 50, offset: 0))
          .thenAnswer((_) async => Right(tCryptoList));
      return bloc;
    },
    act: (bloc) => bloc.add(const GetCryptosListEvent()),
    expect: () => [
      CryptoLoading(),
      // hasReachedMax değerini true olarak güncelledik çünkü 1 tane veri geliyor (1 < 50)
      CryptoLoaded(cryptos: tCryptoList, hasReachedMax: true), 
    ],
  );

  blocTest<CryptoBloc, CryptoState>(
    'should emit [CryptoLoading, CryptoError] when getting data fails',
    build: () {
      when(() => mockGetCryptosUseCase(limit: 50, offset: 0))
          .thenAnswer((_) async => Left(ServerFailure()));
      return bloc;
    },
    act: (bloc) => bloc.add(const GetCryptosListEvent()),
    expect: () => [
      CryptoLoading(),
      const CryptoError(message: 'Sunucu ile iletişim kurulamadı. Lütfen internet bağlantınızı kontrol edin.'),
    ],
  );
}