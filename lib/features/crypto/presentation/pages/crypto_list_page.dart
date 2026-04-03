import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/crypto_bloc.dart';
import '../bloc/crypto_state.dart';
import '../widgets/crypto_list_tile.dart';
import '../widgets/crypto_detail_bottom_sheet.dart';


class CryptoListPage extends StatelessWidget {
  const CryptoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
            },
          ),
        ],
      ),
      body: BlocBuilder<CryptoBloc, CryptoState>(
        builder: (context, state) {
          if (state is CryptoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CryptoError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          } else if (state is CryptoLoaded) {
            final cryptos = state.cryptos;
            
            return ListView.builder(
              itemCount: cryptos.length,
              itemBuilder: (context, index) {
                final crypto = cryptos[index];
                
                return CryptoListTile(
                  crypto: crypto,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true, 
                      backgroundColor: Colors.transparent, 
                      builder: (context) => CryptoDetailBottomSheet(crypto: crypto),
                    );
                  },
                  onFavoriteTapped: () {
                    print('${crypto.name} favori butonuna basıldı!');
                  },
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}