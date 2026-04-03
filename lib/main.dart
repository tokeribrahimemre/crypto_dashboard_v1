import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:marsky_crypto_dashboard/features/crypto/presentation/pages/main_view.dart';
import 'package:marsky_crypto_dashboard/injection_container.dart' as di;
import 'package:marsky_crypto_dashboard/features/crypto/presentation/bloc/crypto_bloc.dart';
import 'package:marsky_crypto_dashboard/features/crypto/presentation/bloc/crypto_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await di.init(); 
  
  runApp(const MarskyApp());
}

class MarskyApp extends StatelessWidget {
  const MarskyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<CryptoBloc>()..add(const GetCryptosListEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Marsky Crypto',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF121212),
        ),
        home: const MainView(),
      ),
    );
  }
}