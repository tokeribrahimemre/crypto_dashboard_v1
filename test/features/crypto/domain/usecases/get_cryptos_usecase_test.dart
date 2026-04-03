import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:marsky_crypto_dashboard/core/error/failures.dart';
import 'package:marsky_crypto_dashboard/features/crypto/domain/entities/crypto_entity.dart';
import 'package:marsky_crypto_dashboard/features/crypto/domain/repositories/crypto_repository.dart';
import 'package:marsky_crypto_dashboard/features/crypto/domain/usecases/get_cryptos_usecase.dart';

class MockCryptoRepository extends Mock implements CryptoRepository {}

void main() {
  late GetCryptosUseCase usecase;
  late MockCryptoRepository mockRepository;

  setUp(() {
    mockRepository = MockCryptoRepository();
    usecase = GetCryptosUseCase(repository: mockRepository);
  });

  final tCryptoList = [
    const CryptoEntity(
      id: '1',
      rank: 1,
      symbol: 'BTC',
      name: 'Bitcoin',
      price: 50000.0,
      change: 2.5,
      marketCap: 1000000.0,
      listedAt: 123456789,
      iconUrl: 'https://test.com/btc.png',
      sparkline: [49000.0, 50000.0],
    )
  ];

  test('should get list of cryptos from the repository when successful', () async {
    when(() => mockRepository.getCryptos(limit: any(named: 'limit'), offset: any(named: 'offset')))
        .thenAnswer((_) async => Right(tCryptoList));

    final result = await usecase(limit: 50, offset: 0);

    expect(result, Right(tCryptoList));
    verify(() => mockRepository.getCryptos(limit: 50, offset: 0)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure when repository fails', () async {
    when(() => mockRepository.getCryptos(limit: any(named: 'limit'), offset: any(named: 'offset')))
        .thenAnswer((_) async => Left(ServerFailure()));

    final result = await usecase(limit: 50, offset: 0);

    expect(result, Left(ServerFailure()));
    verify(() => mockRepository.getCryptos(limit: 50, offset: 0)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}