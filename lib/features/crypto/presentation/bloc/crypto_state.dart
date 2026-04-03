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

  const CryptoLoaded({required this.cryptos});

  @override
  List<Object> get props => [cryptos];
}

class CryptoError extends CryptoState {
  final String message;

  const CryptoError({required this.message});

  @override
  List<Object> get props => [message];
}