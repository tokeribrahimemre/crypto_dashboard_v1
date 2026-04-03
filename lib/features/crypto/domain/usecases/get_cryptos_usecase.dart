import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/crypto_entity.dart';
import '../repositories/crypto_repository.dart';

class GetCryptosUseCase {
  final CryptoRepository repository;

  GetCryptosUseCase({required this.repository});

  Future<Either<Failure, List<CryptoEntity>>> call({int limit = 50, int offset = 0}) async {
    return await repository.getCryptos(limit: limit, offset: offset);
  }
}