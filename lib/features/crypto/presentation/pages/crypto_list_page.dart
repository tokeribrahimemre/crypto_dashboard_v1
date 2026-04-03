import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marsky_crypto_dashboard/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:marsky_crypto_dashboard/features/auth/presentation/bloc/auth_event.dart';
import '../bloc/crypto_bloc.dart';
import '../bloc/crypto_event.dart';
import '../bloc/crypto_state.dart';
import '../widgets/crypto_list_tile.dart';
import '../widgets/crypto_detail_bottom_sheet.dart';

class CryptoListPage extends StatefulWidget {
  const CryptoListPage({super.key});

  @override
  State<CryptoListPage> createState() => _CryptoListPageState();
}

class _CryptoListPageState extends State<CryptoListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<CryptoBloc>().add(const LoadMoreCryptosEvent());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market'),
        actions: [
          PopupMenuButton<CryptoSortType>(
            icon: const Icon(Icons.sort),
            onSelected: (sortType) {
              context.read<CryptoBloc>().add(SortCryptosEvent(sortType: sortType));
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: CryptoSortType.rank, child: Text('Rank (Varsayılan)')),
              const PopupMenuItem(value: CryptoSortType.price, child: Text('Fiyat (En Yüksek)')),
              const PopupMenuItem(value: CryptoSortType.marketCap, child: Text('Market Değeri')),
              const PopupMenuItem(value: CryptoSortType.change, child: Text('Değişim (24s)')),
              const PopupMenuItem(value: CryptoSortType.listedAt, child: Text('Listelenme Tarihi')),
              const PopupMenuItem(value: CryptoSortType.volume, child: Text('24s Hacim (Volume)')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text('Çıkış Yap'),
                    content: const Text('Hesabınızdan çıkış yapmak istediğinize emin misiniz?'),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: const Text('İptal', style: TextStyle(color: Colors.grey)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          context.read<AuthBloc>().add(SignOutEvent());
                        },
                        child: const Text('Çıkış Yap', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  );
                },
              );
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
              controller: _scrollController,
              itemCount: state.hasReachedMax ? cryptos.length : cryptos.length + 1,
              itemBuilder: (context, index) {
                if (index >= cryptos.length) {
                  return const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

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
                    context.read<CryptoBloc>().add(ToggleFavoriteEvent(id: crypto.id));
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