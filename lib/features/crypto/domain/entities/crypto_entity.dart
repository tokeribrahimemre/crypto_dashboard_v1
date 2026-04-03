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
  final double volume;

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
    required this.volume,
    this.isFavorite = false,
  });

  CryptoEntity copyWith({
    String? id,
    int? rank,
    String? symbol,
    String? name,
    double? price,
    double? change,
    double? marketCap,
    int? listedAt,
    String? iconUrl,
    List<double>? sparkline,
    bool? isFavorite,
    double? volume,
  }) {
    return CryptoEntity(
      id: id ?? this.id,
      rank: rank ?? this.rank,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      price: price ?? this.price,
      change: change ?? this.change,
      marketCap: marketCap ?? this.marketCap,
      listedAt: listedAt ?? this.listedAt,
      iconUrl: iconUrl ?? this.iconUrl,
      sparkline: sparkline ?? this.sparkline,
      isFavorite: isFavorite ?? this.isFavorite,
      volume: volume ?? this.volume,
    );
  }

  @override
  List<Object?> get props => [
        id, rank, symbol, name, price, change, marketCap, 
        listedAt, iconUrl, sparkline, isFavorite, volume,
      ];
}