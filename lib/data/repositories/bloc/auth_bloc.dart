import 'package:coffee_app/data/models/auth_user.dart';
import 'package:coffee_app/data/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- Events ---
abstract class AuthEvent {}

class AuthCheckRequested extends AuthEvent {
  AuthCheckRequested();
}

class AuthLoginRequested extends AuthEvent {
  AuthLoginRequested({required this.email, required this.password});
  final String email;
  final String password;
}

class AuthLogoutRequested extends AuthEvent {
  AuthLogoutRequested();
}

// --- States ---
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  AuthAuthenticated(this.user);
  final AuthUser user;
}

class AuthUnauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  AuthFailure(this.message);
  final String message;
}

// --- Bloc ---
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepository repository})
    : _repo = repository,
      super(AuthInitial()) {
    on<AuthCheckRequested>(_onCheck);
    on<AuthLoginRequested>(_onLogin);
    on<AuthLogoutRequested>(_onLogout);
  }
  final AuthRepository _repo;

  Future<void> _onCheck(AuthCheckRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final user = await _repo.getCurrentUser();
    emit(user != null ? AuthAuthenticated(user) : AuthUnauthenticated());
  }

  Future<void> _onLogin(AuthLoginRequested e, Emitter<AuthState> emit) async {
    if (e.email.trim().isEmpty || e.password.isEmpty) {
      emit(AuthFailure('E-posta ve şifre girin.'));
      return;
    }
    emit(AuthLoading());
    final r = await _repo.login(e.email, e.password);
    if (r.success && r.user != null) {
      emit(AuthAuthenticated(r.user!));
    } else {
      emit(AuthFailure(r.error ?? 'Giriş başarısız.'));
    }
  }

  Future<void> _onLogout(AuthLogoutRequested e, Emitter<AuthState> emit) async {
    await _repo.logout();
    emit(AuthUnauthenticated());
  }
}
