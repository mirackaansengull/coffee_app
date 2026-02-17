import 'package:coffee_app/data/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- Events ---
abstract class RegisterEvent {}

class RegisterSendCode extends RegisterEvent {
  RegisterSendCode(this.email);
  final String email;
}

class RegisterVerify extends RegisterEvent {
  RegisterVerify({
    required this.email,
    required this.code,
    required this.password,
    this.name = '',
  });
  final String email, code, password;
  final String name;
}

class RegisterReset extends RegisterEvent {
  RegisterReset();
}

// --- States ---
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterCodeSent extends RegisterState {
  RegisterCodeSent(this.message);
  final String message;
}

class RegisterSuccess extends RegisterState {}

class RegisterFailure extends RegisterState {
  RegisterFailure(this.message);
  final String message;
}

// --- Bloc ---
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({required AuthRepository repository})
      : _repo = repository,
        super(RegisterInitial()) {
    on<RegisterSendCode>(_sendCode);
    on<RegisterVerify>(_verify);
    on<RegisterReset>(_reset);
  }
  final AuthRepository _repo;

  Future<void> _sendCode(RegisterSendCode e, Emitter<RegisterState> emit) async {
    if (e.email.trim().isEmpty) {
      emit(RegisterFailure('E-posta girin.'));
      return;
    }
    emit(RegisterLoading());
    final r = await _repo.sendRegisterCode(e.email);
    if (r.success) {
      emit(RegisterCodeSent(r.message ?? 'Kod gönderildi.'));
    } else {
      emit(RegisterFailure(r.error ?? 'Hata oluştu.'));
    }
  }

  Future<void> _verify(RegisterVerify e, Emitter<RegisterState> emit) async {
    if (e.code.trim().isEmpty || e.password.length < 6) {
      emit(RegisterFailure('Kod ve en az 6 karakter şifre girin.'));
      return;
    }
    emit(RegisterLoading());
    final r = await _repo.verifyRegister(
      email: e.email,
      code: e.code,
      password: e.password,
      name: e.name,
    );
    if (r.success) {
      emit(RegisterSuccess());
    } else {
      emit(RegisterFailure(r.error ?? 'Doğrulama başarısız.'));
    }
  }

  void _reset(RegisterReset e, Emitter<RegisterState> emit) {
    emit(RegisterInitial());
  }
}
