import '../../domain/entities/crypto_entity.dart';

class CryptoModel extends CryptoEntity {
  const CryptoModel({
    required super.id,
    required super.rank,
    required super.symbol,
    required super.name,
    required super.price,
    required super.change,
    required super.marketCap,
    required super.listedAt,
    required super.iconUrl,
    required super.sparkline,
    super.isFavorite,
  });

  factory CryptoModel.fromJson(Map<String, dynamic> json) {
    return CryptoModel(
      id: json['uuid'] ?? '',
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      iconUrl: json['iconUrl'] ?? '',
      
      rank: _parseInt(json['rank']),
      listedAt: _parseInt(json['listedAt']),
      
      price: _parseDouble(json['price']),
      change: _parseDouble(json['change']),
      marketCap: _parseDouble(json['marketCap']),
      
      sparkline: (json['sparkline'] as List<dynamic>?)
              ?.map((e) => _parseDouble(e))
              .toList() ??
          [],
    );
  }


  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }
}