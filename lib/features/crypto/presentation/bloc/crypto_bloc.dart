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

  int _currentOffset = 0;
  final int _limit = 50;
  bool _isFetchingMore = false;
  CryptoSortType _currentSortType = CryptoSortType.rank;

  CryptoBloc({
    required this.getCryptosUseCase,
    required this.toggleFavoriteUseCase,
  }) : super(CryptoInitial()) {
    on<GetCryptosListEvent>(_onGetCryptosList);
    on<LoadMoreCryptosEvent>(_onLoadMoreCryptos);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<SortCryptosEvent>(_onSortCryptos);
  }

  Future<void> _onGetCryptosList(GetCryptosListEvent event, Emitter<CryptoState> emit) async {
    _currentOffset = 0;
    _currentSortType = CryptoSortType.rank;
    emit(CryptoLoading());

    final failureOrCryptos = await getCryptosUseCase(limit: _limit, offset: _currentOffset);

    failureOrCryptos.fold(
      (failure) => emit(CryptoError(message: _mapFailureToMessage(failure))),
      (cryptos) {
        _currentOffset += _limit;
        emit(CryptoLoaded(cryptos: cryptos, hasReachedMax: cryptos.length < _limit));
      },
    );
  }

  Future<void> _onLoadMoreCryptos(LoadMoreCryptosEvent event, Emitter<CryptoState> emit) async {
    if (_isFetchingMore || state is! CryptoLoaded) return;
    
    final currentState = state as CryptoLoaded;
    if (currentState.hasReachedMax) return;

    _isFetchingMore = true;

    final failureOrCryptos = await getCryptosUseCase(limit: _limit, offset: _currentOffset);

    failureOrCryptos.fold(
      (failure) {
        _isFetchingMore = false;
      },
      (newCryptos) {
        _isFetchingMore = false;
        if (newCryptos.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          _currentOffset += _limit;
          final updatedList = List<CryptoEntity>.from(currentState.cryptos)..addAll(newCryptos);
          _applySorting(updatedList, _currentSortType);
          emit(CryptoLoaded(
            cryptos: updatedList,
            hasReachedMax: newCryptos.length < _limit,
          ));
        }
      },
    );
  }

  Future<void> _onToggleFavorite(ToggleFavoriteEvent event, Emitter<CryptoState> emit) async {
    if (state is CryptoLoaded) {
      final currentState = state as CryptoLoaded;
      
      final updatedCryptos = currentState.cryptos.map((crypto) {
        if (crypto.id == event.id) {
          return crypto.copyWith(isFavorite: !crypto.isFavorite);
        }
        return crypto;
      }).toList();

      emit(currentState.copyWith(cryptos: updatedCryptos));
      await toggleFavoriteUseCase(event.id);
    }
  }

  Future<void> _onSortCryptos(SortCryptosEvent event, Emitter<CryptoState> emit) async {
    if (state is CryptoLoaded) {
      final currentState = state as CryptoLoaded;
      _currentSortType = event.sortType;
      
      final cryptos = List<CryptoEntity>.from(currentState.cryptos);
      _applySorting(cryptos, _currentSortType);
      
      emit(currentState.copyWith(cryptos: cryptos));
    }
  }

  void _applySorting(List<CryptoEntity> cryptos, CryptoSortType sortType) {
    switch (sortType) {
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
      case CryptoSortType.volume:
        cryptos.sort((a, b) => b.volume.compareTo(a.volume));
        break;  
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