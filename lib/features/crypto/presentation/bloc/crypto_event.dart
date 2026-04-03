import 'package:equatable/equatable.dart';

abstract class CryptoEvent extends Equatable {
  const CryptoEvent();

  @override
  List<Object> get props => [];
}

class GetCryptosListEvent extends CryptoEvent {
  final int limit;
  final int offset;

  const GetCryptosListEvent({this.limit = 50, this.offset = 0});

  @override
  List<Object> get props => [limit, offset];
}