import 'package:coffee_app/core/constants/asset_paths.dart';
import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/data/repositories/bloc/auth_bloc.dart';
import 'package:coffee_app/views/auth/forgot_password_view.dart';
import 'package:coffee_app/views/auth/register_view.dart';
import 'package:coffee_app/widgets/auth/auth_footer_link.dart';
import 'package:coffee_app/widgets/auth/auth_input.dart';
import 'package:coffee_app/widgets/auth/auth_message_text.dart';
import 'package:coffee_app/widgets/auth/auth_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoginInProgress;
        final errorMessage = state is AuthFailure ? state.message : null;

        final isLight = Theme.of(context).brightness == Brightness.light;
        final logoColor = isLight ? Colors.black : Colors.white;

        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                AssetPaths.background,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  decoration: BoxDecoration(gradient: colors.gradientBackground),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colors.backgroundPrimary.withValues(alpha: 0.8),
                      colors.backgroundSecondary.withValues(alpha: 0.85),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 40.h),
                    Center(
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(logoColor, BlendMode.srcIn),
                        child: Image.asset(
                          AssetPaths.logoHorizontal,
                          width: 160.w,
                          height: 100.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    Text(
                      'Giriş Yap',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 32.h),
                    AuthInput(
                      controller: _emailController,
                      hint: 'E-posta',
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                    ),
                    SizedBox(height: 16.h),
                    AuthInput(
                      controller: _passwordController,
                      hint: 'Şifre',
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
                    if (errorMessage != null) ...[
                      SizedBox(height: 12.h),
                      AuthMessageText(text: errorMessage, isError: true),
                    ],
                    SizedBox(height: 24.h),
                    AuthSubmitButton(
                      label: 'Giriş Yap',
                      loading: isLoading,
                      onPressed: () {
                        context.read<AuthBloc>().add(
                          AuthLoginRequested(
                            email: _emailController.text.trim(),
                            password: _passwordController.text,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16.h),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordView(),
                          ),
                        );
                      },
                      child: Text(
                        'Şifremi unuttum',
                        style: TextStyle(
                          color: colors.textHint,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    AuthFooterLink(
                      text: 'Hesabın yok mu? ',
                      linkLabel: 'Kayıt ol',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterView(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 48.h),
                  ],
                ),
              ),
            ),
            ],
          ),
        );
      },
    );
  }
}
