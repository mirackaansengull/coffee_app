import 'package:coffee_app/data/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- Events ---
abstract class ForgotPasswordEvent {}

class ForgotPasswordSendCode extends ForgotPasswordEvent {
  ForgotPasswordSendCode(this.email);
  final String email;
}

class ForgotPasswordReset extends ForgotPasswordEvent {
  ForgotPasswordReset({
    required this.email,
    required this.code,
    required this.newPassword,
  });
  final String email, code, newPassword;
}

class ForgotPasswordResetForm extends ForgotPasswordEvent {
  ForgotPasswordResetForm();
}

// --- States ---
abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordCodeSent extends ForgotPasswordState {
  ForgotPasswordCodeSent(this.message);
  final String message;
}

class ForgotPasswordDone extends ForgotPasswordState {
  ForgotPasswordDone(this.message);
  final String message;
}

class ForgotPasswordFailure extends ForgotPasswordState {
  ForgotPasswordFailure(this.message);
  final String message;
}

// --- Bloc ---
class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc({required AuthRepository repository})
      : _repo = repository,
        super(ForgotPasswordInitial()) {
    on<ForgotPasswordSendCode>(_sendCode);
    on<ForgotPasswordReset>(_reset);
    on<ForgotPasswordResetForm>(_resetForm);
  }
  final AuthRepository _repo;

  Future<void> _sendCode(
      ForgotPasswordSendCode e, Emitter<ForgotPasswordState> emit) async {
    if (e.email.trim().isEmpty) {
      emit(ForgotPasswordFailure('E-posta girin.'));
      return;
    }
    emit(ForgotPasswordLoading());
    final r = await _repo.sendResetCode(e.email);
    if (r.success) {
      emit(ForgotPasswordCodeSent(r.message ?? 'Kod gönderildi.'));
    } else {
      emit(ForgotPasswordFailure(r.error ?? 'Hata oluştu.'));
    }
  }

  Future<void> _reset(
      ForgotPasswordReset e, Emitter<ForgotPasswordState> emit) async {
    if (e.code.trim().isEmpty || e.newPassword.length < 6) {
      emit(ForgotPasswordFailure('Kod ve en az 6 karakter şifre girin.'));
      return;
    }
    emit(ForgotPasswordLoading());
    final r = await _repo.resetPassword(
      email: e.email,
      code: e.code,
      newPassword: e.newPassword,
    );
    if (r.success) {
      emit(ForgotPasswordDone(r.message ?? 'Şifre güncellendi.'));
    } else {
      emit(ForgotPasswordFailure(r.error ?? 'Şifre sıfırlama başarısız.'));
    }
  }

  void _resetForm(
      ForgotPasswordResetForm e, Emitter<ForgotPasswordState> emit) {
    emit(ForgotPasswordInitial());
  }
}
