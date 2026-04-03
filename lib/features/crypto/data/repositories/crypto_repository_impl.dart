import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/crypto_entity.dart';
import '../../domain/repositories/crypto_repository.dart';
import '../datasources/crypto_remote_data_source.dart';
import '../datasources/favorites_local_data_source.dart'; 

class CryptoRepositoryImpl implements CryptoRepository {
  final CryptoRemoteDataSource remoteDataSource;
  final FavoritesLocalDataSource localDataSource; 

  CryptoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<CryptoEntity>>> getCryptos({int limit = 50, int offset = 0}) async {
    try {
      final remoteCryptos = await remoteDataSource.getCryptos(limit: limit, offset: offset);
      final favoriteIds = localDataSource.getFavoriteIds(); 

      final cryptosWithFavorites = remoteCryptos.map((crypto) {
        return crypto.copyWith(isFavorite: favoriteIds.contains(crypto.id));
      }).toList();

      return Right(cryptosWithFavorites);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(String id) async {
    try {
      await localDataSource.toggleFavorite(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}