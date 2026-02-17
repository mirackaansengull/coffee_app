import 'package:coffee_app/data/repositories/bloc/auth_bloc.dart';
import 'package:coffee_app/data/repositories/bloc/register_bloc.dart';
import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/data/repositories/auth_repository.dart';
import 'package:coffee_app/views/auth/login_view.dart';
import 'package:coffee_app/widgets/auth/auth_app_bar.dart';
import 'package:coffee_app/widgets/auth/auth_footer_link.dart';
import 'package:coffee_app/widgets/auth/auth_input.dart';
import 'package:coffee_app/widgets/auth/auth_message_text.dart';
import 'package:coffee_app/widgets/auth/auth_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return BlocProvider<RegisterBloc>(
      create: (_) => RegisterBloc(repository: context.read<AuthRepository>()),
      child: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            context.read<AuthBloc>().add(AuthCheckRequested());
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          final codeSent = state is RegisterCodeSent;
          final isLoading = state is RegisterLoading;
          final message = state is RegisterCodeSent ? state.message : null;
          final errorMessage = state is RegisterFailure ? state.message : null;

          return Scaffold(
            appBar: AuthAppBar(
              title: 'Kayıt Ol',
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
                      AuthInput(
                        controller: _emailController,
                        hint: 'E-posta',
                        keyboardType: TextInputType.emailAddress,
                        enabled: !codeSent,
                      ),
                      SizedBox(height: 16.h),
                      if (codeSent) ...[
                        AuthInput(
                          controller: _codeController,
                          hint: '6 haneli kod',
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                        ),
                        SizedBox(height: 16.h),
                        AuthInput(
                          controller: _nameController,
                          hint: 'Ad (isteğe bağlı)',
                        ),
                        SizedBox(height: 16.h),
                        AuthInput(
                          controller: _passwordController,
                          hint: 'Şifre (en az 6 karakter)',
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
                          label: 'Doğrulama kodu gönder',
                          loading: isLoading,
                          onPressed: () {
                            context.read<RegisterBloc>().add(
                              RegisterSendCode(_emailController.text.trim()),
                            );
                          },
                        )
                      else ...[
                        AuthSubmitButton(
                          label: 'Kayıt ol',
                          loading: isLoading,
                          onPressed: () {
                            context.read<RegisterBloc>().add(RegisterVerify(
                              email: _emailController.text.trim(),
                              code: _codeController.text.trim(),
                              password: _passwordController.text,
                              name: _nameController.text.trim(),
                            ));
                          },
                        ),
                        SizedBox(height: 12.h),
                        TextButton(
                          onPressed: () {
                            context.read<RegisterBloc>().add(RegisterReset());
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
                      SizedBox(height: 24.h),
                      AuthFooterLink(
                        text: 'Zaten hesabın var mı? ',
                        linkLabel: 'Giriş yap',
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginView(),
                            ),
                          );
                        },
                      ),
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
