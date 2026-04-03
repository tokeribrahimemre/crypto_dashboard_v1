import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/crypto_repository.dart';

class ToggleFavoriteUseCase {
  final CryptoRepository repository;

  ToggleFavoriteUseCase({required this.repository});

  Future<Either<Failure, void>> call(String id) async {
    return await repository.toggleFavorite(id);
  }
}