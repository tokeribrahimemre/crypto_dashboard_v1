import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_cryptos_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';
import '../../domain/entities/crypto_entity.dart';
import 'crypto_event.dart';
import 'crypto_state.dart';

class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  final GetCryptosUseCase getCryptosUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;

  CryptoBloc({
    required this.getCryptosUseCase,
    required this.toggleFavoriteUseCase,
  }) : super(CryptoInitial()) {
    on<GetCryptosListEvent>(_onGetCryptosList);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<SortCryptosEvent>(_onSortCryptos);
  }

  Future<void> _onGetCryptosList(GetCryptosListEvent event, Emitter<CryptoState> emit) async {
    emit(CryptoLoading());

    final failureOrCryptos = await getCryptosUseCase(
      limit: event.limit, 
      offset: event.offset
    );

    failureOrCryptos.fold(
      (failure) => emit(CryptoError(message: _mapFailureToMessage(failure))),
      (cryptos) => emit(CryptoLoaded(cryptos: cryptos)),
    );
  }

  Future<void> _onToggleFavorite(ToggleFavoriteEvent event, Emitter<CryptoState> emit) async {
    if (state is CryptoLoaded) {
      final currentState = state as CryptoLoaded;
      final cryptos = currentState.cryptos;

      final updatedCryptos = cryptos.map((crypto) {
        if (crypto.id == event.id) {
          return crypto.copyWith(isFavorite: !crypto.isFavorite);
        }
        return crypto;
      }).toList();

      emit(CryptoLoaded(cryptos: updatedCryptos));
      await toggleFavoriteUseCase(event.id);
    }
  }

  Future<void> _onSortCryptos(SortCryptosEvent event, Emitter<CryptoState> emit) async {
    if (state is CryptoLoaded) {
      final currentState = state as CryptoLoaded;
      final cryptos = List<CryptoEntity>.from(currentState.cryptos);

      switch (event.sortType) {
        case CryptoSortType.rank:
          cryptos.sort((a, b) => a.rank.compareTo(b.rank));
          break;
        case CryptoSortType.price:
          cryptos.sort((a, b) => b.price.compareTo(a.price));
          break;
        case CryptoSortType.marketCap:
          cryptos.sort((a, b) => b.marketCap.compareTo(a.marketCap));
          break;
        case CryptoSortType.change:
          cryptos.sort((a, b) => b.change.compareTo(a.change));
          break;
        case CryptoSortType.listedAt:
          cryptos.sort((a, b) => b.listedAt.compareTo(a.listedAt));
          break;
      }
      emit(CryptoLoaded(cryptos: cryptos));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Sunucu ile iletişim kurulamadı. Lütfen internet bağlantınızı kontrol edin.';
      case CacheFailure:
        return 'Yerel veriler okunurken bir hata oluştu.';
      default:
        return 'Beklenmedik bir hata oluştu.';
    }
  }
}