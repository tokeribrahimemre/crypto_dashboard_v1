import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart'; 

import 'features/crypto/data/datasources/crypto_remote_data_source.dart';
import 'features/crypto/data/datasources/favorites_local_data_source.dart'; 
import 'features/crypto/data/repositories/crypto_repository_impl.dart';
import 'features/crypto/domain/repositories/crypto_repository.dart';
import 'features/crypto/domain/usecases/get_cryptos_usecase.dart';
import 'features/crypto/presentation/bloc/crypto_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await Hive.initFlutter();
  final favoritesBox = await Hive.openBox<String>('favorites_box');
  sl.registerLazySingleton(() => favoritesBox);

  sl.registerFactory(() => CryptoBloc(getCryptosUseCase: sl()));

  sl.registerLazySingleton(() => GetCryptosUseCase(repository: sl()));

  sl.registerLazySingleton<CryptoRepository>(
    () => CryptoRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(), 
    ),
  );

  sl.registerLazySingleton<CryptoRemoteDataSource>(
    () => CryptoRemoteDataSourceImpl(client: sl()),
  );
  
  sl.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSourceImpl(box: sl()),
  );

  sl.registerLazySingleton(() => http.Client());
}