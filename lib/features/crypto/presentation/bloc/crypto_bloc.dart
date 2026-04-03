import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_cryptos_usecase.dart';
import 'crypto_event.dart';
import 'crypto_state.dart';

class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  final GetCryptosUseCase getCryptosUseCase;

  CryptoBloc({required this.getCryptosUseCase}) : super(CryptoInitial()) {
    
    on<GetCryptosListEvent>((event, emit) async {
      emit(CryptoLoading());

      final failureOrCryptos = await getCryptosUseCase(
        limit: event.limit, 
        offset: event.offset
      );

      failureOrCryptos.fold(
        (failure) {
          emit(CryptoError(message: _mapFailureToMessage(failure)));
        },
        (cryptos) {
          emit(CryptoLoaded(cryptos: cryptos));
        },
      );
    });
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