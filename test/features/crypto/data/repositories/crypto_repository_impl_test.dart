import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:marsky_crypto_dashboard/core/error/exceptions.dart';
import 'package:marsky_crypto_dashboard/core/error/failures.dart';
import 'package:marsky_crypto_dashboard/features/crypto/data/datasources/crypto_remote_data_source.dart';
import 'package:marsky_crypto_dashboard/features/crypto/data/datasources/favorites_local_data_source.dart';
import 'package:marsky_crypto_dashboard/features/crypto/data/repositories/crypto_repository_impl.dart';
import 'package:marsky_crypto_dashboard/features/crypto/data/models/crypto_model.dart';

class MockRemoteDataSource extends Mock implements CryptoRemoteDataSource {}
class MockLocalDataSource extends Mock implements FavoritesLocalDataSource {}

void main() {
  late CryptoRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    repository = CryptoRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tCryptoModelList = <CryptoModel>[
    const CryptoModel(
      id: '1', rank: 1, symbol: 'BTC', name: 'Bitcoin', price: 50000.0, 
      change: 2.5, marketCap: 1000000.0, listedAt: 123456789, 
      iconUrl: 'url', sparkline: [], isFavorite: false,
      volume: 5000000.0,
    )
  ];

  group('getCryptos', () {
    test('should return remote data and merge with local favorites when successful', () async {
      when(() => mockRemoteDataSource.getCryptos(limit: 50, offset: 0))
          .thenAnswer((_) async => tCryptoModelList);
      when(() => mockLocalDataSource.getFavoriteIds())
          .thenReturn(['1']);

      final result = await repository.getCryptos(limit: 50, offset: 0);

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (cryptos) {
          expect(cryptos.first.id, '1');
          expect(cryptos.first.isFavorite, true);
        },
      );
    });

    test('should return ServerFailure when remote data source throws ServerException', () async {
      when(() => mockRemoteDataSource.getCryptos(limit: 50, offset: 0))
          .thenThrow(ServerException());

      final result = await repository.getCryptos(limit: 50, offset: 0);

      expect(result, Left(ServerFailure()));
    });
  });
}