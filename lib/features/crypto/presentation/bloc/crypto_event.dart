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

class ToggleFavoriteEvent extends CryptoEvent {
  final String id;

  const ToggleFavoriteEvent({required this.id});

  @override
  List<Object> get props => [id];
}

enum CryptoSortType { rank, price, marketCap, change, listedAt, volume }

class SortCryptosEvent extends CryptoEvent {
  final CryptoSortType sortType;

  const SortCryptosEvent({required this.sortType});

  @override
  List<Object> get props => [sortType];
}

class LoadMoreCryptosEvent extends CryptoEvent {
  const LoadMoreCryptosEvent();

  @override
  List<Object> get props => [];
}