import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/crypto/data/datasources/crypto_remote_data_source.dart';
import 'features/crypto/data/datasources/favorites_local_data_source.dart';
import 'features/crypto/data/repositories/crypto_repository_impl.dart';
import 'features/crypto/domain/repositories/crypto_repository.dart';
import 'features/crypto/domain/usecases/get_cryptos_usecase.dart';
import 'features/crypto/domain/usecases/toggle_favorite_usecase.dart';
import 'features/crypto/presentation/bloc/crypto_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await Hive.initFlutter();
  final favoritesBox = await Hive.openBox<String>('favorites_box');
  sl.registerLazySingleton(() => favoritesBox);

  sl.registerFactory(() => CryptoBloc(
        getCryptosUseCase: sl(),
        toggleFavoriteUseCase: sl(),
      ));

  sl.registerLazySingleton(() => GetCryptosUseCase(repository: sl()));
  sl.registerLazySingleton(() => ToggleFavoriteUseCase(repository: sl()));

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

  final supabase = Supabase.instance.client;
  sl.registerLazySingleton(() => supabase);

  sl.registerFactory(() => AuthBloc(authRepository: sl()));

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabaseClient: sl()),
  );
}