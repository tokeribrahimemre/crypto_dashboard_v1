import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import 'package:marsky_crypto_dashboard/injection_container.dart' as di;
import 'package:marsky_crypto_dashboard/features/crypto/presentation/bloc/crypto_bloc.dart';
import 'package:marsky_crypto_dashboard/features/crypto/presentation/bloc/crypto_event.dart';
import 'package:marsky_crypto_dashboard/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:marsky_crypto_dashboard/features/auth/presentation/bloc/auth_event.dart';
import 'package:marsky_crypto_dashboard/features/auth/presentation/bloc/auth_state.dart';
import 'package:marsky_crypto_dashboard/features/auth/presentation/pages/login_page.dart';
import 'package:marsky_crypto_dashboard/features/crypto/presentation/pages/main_view.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://hczvnmpohedtxgxhyxzd.supabase.co',
    anonKey: 'sb_publishable_Y82aq4JBEV2Q060qWERAjA_D-fQniF4',
  );

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
        BlocProvider(
          create: (_) => di.sl<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Marsky Crypto',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF121212),
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return const MainView();
            }
            return const LoginPage();
          },
        ),
      ),
    );
  }
}