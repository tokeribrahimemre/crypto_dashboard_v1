import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<SignInEvent>(_onSignIn);
    on<SignUpEvent>(_onSignUp);
    on<SignOutEvent>(_onSignOut);
  }

  void _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<AuthState> emit) {
    final isSignedIn = authRepository.isSignedIn;
    if (isSignedIn) {
      emit(const Authenticated(userId: ''));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authRepository.signIn(event.email, event.password);
    
    result.fold(
      (failure) => emit(const AuthError(message: 'Giriş başarısız. Lütfen bilgilerinizi kontrol edin.')),
      (userId) => emit(Authenticated(userId: userId)),
    );
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authRepository.signUp(event.email, event.password);
    
    result.fold(
      (failure) => emit(const AuthError(message: 'Kayıt olunamadı. Şifreniz en az 6 karakter olmalıdır.')),
      (userId) => emit(Authenticated(userId: userId)),
    );
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await authRepository.signOut();
    emit(Unauthenticated());
  }
}