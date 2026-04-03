import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/crypto_entity.dart';

abstract class CryptoRepository {
  Future<Either<Failure, List<CryptoEntity>>> getCryptos({int limit = 50, int offset = 0});
  
  Future<Either<Failure, void>> toggleFavorite(String id); 
}