import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/crypto_bloc.dart';
import '../bloc/crypto_state.dart';
import '../bloc/crypto_event.dart';
import '../widgets/crypto_list_tile.dart';
import '../widgets/crypto_detail_bottom_sheet.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: BlocBuilder<CryptoBloc, CryptoState>(
        builder: (context, state) {
          if (state is CryptoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CryptoError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state is CryptoLoaded) {
            final favoriteCryptos = state.cryptos.where((c) => c.isFavorite).toList();

            if (favoriteCryptos.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 64, color: Colors.grey.shade600),
                    const SizedBox(height: 16),
                    const Text(
                      'Henüz favori kripto paranız bulunmuyor.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: favoriteCryptos.length,
              itemBuilder: (context, index) {
                final crypto = favoriteCryptos[index];
                
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
                    context.read<CryptoBloc>().add(
                      ToggleFavoriteEvent(id: crypto.id),
                    );
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