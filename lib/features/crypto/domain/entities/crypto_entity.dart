import 'package:equatable/equatable.dart';

class CryptoEntity extends Equatable {
  final String id;
  final int rank;
  final String symbol;
  final String name;
  final double price;
  final double change;
  final double marketCap;
  final int listedAt;
  final String iconUrl;
  final List<double> sparkline; 
  final bool isFavorite; 

  const CryptoEntity({
    required this.id,
    required this.rank,
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
    required this.marketCap,
    required this.listedAt,
    required this.iconUrl,
    required this.sparkline,
    this.isFavorite = false, 
  });

  CryptoEntity copyWith({
    bool? isFavorite,
  }) {
    return CryptoEntity(
      id: id,
      rank: rank,
      symbol: symbol,
      name: name,
      price: price,
      change: change,
      marketCap: marketCap,
      listedAt: listedAt,
      iconUrl: iconUrl,
      sparkline: sparkline,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
        id, rank, symbol, name, price, change, marketCap, listedAt, iconUrl, sparkline, isFavorite
      ];
}