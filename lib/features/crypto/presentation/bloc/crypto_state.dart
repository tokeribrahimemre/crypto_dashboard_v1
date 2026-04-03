import 'package:equatable/equatable.dart';
import '../../domain/entities/crypto_entity.dart';

abstract class CryptoState extends Equatable {
  const CryptoState();
  
  @override
  List<Object> get props => [];
}

class CryptoInitial extends CryptoState {}

class CryptoLoading extends CryptoState {}

class CryptoLoaded extends CryptoState {
  final List<CryptoEntity> cryptos;
  final bool hasReachedMax;

  const CryptoLoaded({
    required this.cryptos,
    this.hasReachedMax = false,
  });

  CryptoLoaded copyWith({
    List<CryptoEntity>? cryptos,
    bool? hasReachedMax,
  }) {
    return CryptoLoaded(
      cryptos: cryptos ?? this.cryptos,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [cryptos, hasReachedMax];
}

class CryptoError extends CryptoState {
  final String message;

  const CryptoError({required this.message});

  @override
  List<Object> get props => [message];
}