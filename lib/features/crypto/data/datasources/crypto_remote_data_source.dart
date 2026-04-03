import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/crypto_model.dart';
import '../../../../core/error/exceptions.dart'; 


abstract class CryptoRemoteDataSource {
  Future<List<CryptoModel>> getCryptos({int limit = 50, int offset = 0});
}


class CryptoRemoteDataSourceImpl implements CryptoRemoteDataSource {
  final http.Client client;

  CryptoRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CryptoModel>> getCryptos({int limit = 50, int offset = 0}) async {
    final Uri url = Uri.parse(
        'https://api.coinranking.com/v2/coins?limit=$limit&offset=$offset');

    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body);
      
      final List<dynamic> coinsList = decodedJson['data']['coins'];

      return coinsList.map((coin) => CryptoModel.fromJson(coin)).toList();
    } else {
      throw ServerException();
    }
  }
}