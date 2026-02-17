import 'package:coffee_app/data/repositories/bloc/forgot_password_bloc.dart';
import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/data/repositories/auth_repository.dart';
import 'package:coffee_app/views/auth/login_view.dart';
import 'package:coffee_app/widgets/auth/auth_app_bar.dart';
import 'package:coffee_app/widgets/auth/auth_input.dart';
import 'package:coffee_app/widgets/auth/auth_message_text.dart';
import 'package:coffee_app/widgets/auth/auth_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return BlocProvider<ForgotPasswordBloc>(
      create: (_) =>
          ForgotPasswordBloc(repository: context.read<AuthRepository>()),
      child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordDone) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginView()),
            );
          }
        },
        builder: (context, state) {
          final codeSent = state is ForgotPasswordCodeSent;
          final isLoading = state is ForgotPasswordLoading;
          final message = state is ForgotPasswordCodeSent
              ? state.message
              : null;
          final errorMessage = state is ForgotPasswordFailure
              ? state.message
              : null;

          return Scaffold(
            appBar: AuthAppBar(
              title: 'Şifremi Unuttum',
              onBack: () => Navigator.pop(context),
            ),
            body: Container(
              width: double.infinity,
              decoration: BoxDecoration(gradient: colors.gradientBackground),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 16.h),
                      Text(
                        'E-posta adresine 6 haneli bir kod göndereceğiz. Kodu girip yeni şifreni belirleyebilirsin.',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: colors.textHint,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 24.h),
                      AuthInput(
                        controller: _emailController,
                        hint: 'E-posta',
                        keyboardType: TextInputType.emailAddress,
                        enabled: !codeSent,
                      ),
                      if (codeSent) ...[
                        SizedBox(height: 16.h),
                        AuthInput(
                          controller: _codeController,
                          hint: '6 haneli kod',
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                        ),
                        SizedBox(height: 16.h),
                        AuthInput(
                          controller: _newPasswordController,
                          hint: 'Yeni şifre (en az 6 karakter)',
                          obscureText: _obscurePassword,
                          suffix: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              color: colors.textHint,
                              size: 22.sp,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                      ],
                      if (message != null) ...[
                        SizedBox(height: 12.h),
                        AuthMessageText(text: message),
                      ],
                      if (errorMessage != null) ...[
                        SizedBox(height: 12.h),
                        AuthMessageText(text: errorMessage, isError: true),
                      ],
                      SizedBox(height: 24.h),
                      if (!codeSent)
                        AuthSubmitButton(
                          label: 'Kod gönder',
                          loading: isLoading,
                          onPressed: () {
context.read<ForgotPasswordBloc>().add(
                                  ForgotPasswordSendCode(_emailController.text.trim()),
                                );
                          },
                        )
                      else ...[
                        AuthSubmitButton(
                          label: 'Şifreyi güncelle',
                          loading: isLoading,
                          onPressed: () {
context.read<ForgotPasswordBloc>().add(ForgotPasswordReset(
                                  email: _emailController.text.trim(),
                                  code: _codeController.text.trim(),
                                  newPassword: _newPasswordController.text,
                                ));
                          },
                        ),
                        SizedBox(height: 12.h),
                        TextButton(
                          onPressed: () {
context.read<ForgotPasswordBloc>().add(ForgotPasswordResetForm());
                            _codeController.clear();
                          },
                          child: Text(
                            'Farklı e-posta kullan',
                            style: TextStyle(
                              color: colors.textHint,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                      SizedBox(height: 48.h),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
