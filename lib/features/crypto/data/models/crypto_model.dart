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
    required super.volume,
    super.isFavorite,
  });

  factory CryptoModel.fromJson(Map<String, dynamic> json) {
    return CryptoModel(
      id: json['uuid'] ?? '',
      // ESNEK TİP DÖNÜŞÜMÜ: String gelse bile int'e çeviriyoruz
      rank: int.tryParse(json['rank']?.toString() ?? '0') ?? 0,
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      change: double.tryParse(json['change']?.toString() ?? '0') ?? 0.0,
      marketCap: double.tryParse(json['marketCap']?.toString() ?? '0') ?? 0.0,
      // ESNEK TİP DÖNÜŞÜMÜ: listedAt bazen büyük sayı (timestamp) olarak String gelebilir
      listedAt: int.tryParse(json['listedAt']?.toString() ?? '0') ?? 0,
      iconUrl: json['iconUrl'] ?? '',
      sparkline: (json['sparkline'] as List<dynamic>?)
              ?.map((e) => double.tryParse(e?.toString() ?? '0') ?? 0.0)
              .toList() ?? [],
      volume: double.tryParse(json['24hVolume']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': id,
      'rank': rank,
      'symbol': symbol,
      'name': name,
      'price': price.toString(),
      'change': change.toString(),
      'marketCap': marketCap.toString(),
      'listedAt': listedAt,
      'iconUrl': iconUrl,
      'sparkline': sparkline.map((e) => e.toString()).toList(),
      '24hVolume': volume.toString(),
    };
  }
}