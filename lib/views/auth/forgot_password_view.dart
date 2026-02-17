import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/data/services/auth_service.dart';
import 'package:coffee_app/views/auth/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key, required this.onSuccess});

  final VoidCallback onSuccess;

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _loading = false;
  String? _error;
  String? _message;
  bool _codeSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _error = 'E-posta girin.');
      return;
    }
    setState(() {
      _error = null;
      _message = null;
      _loading = true;
    });
    final result = await AuthService.instance.sendResetCode(email);
    setState(() {
      _loading = false;
      if (result.success) {
        _message = result.message;
        _codeSent = true;
      } else {
        _error = result.error;
      }
    });
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    final code = _codeController.text.trim();
    final newPassword = _newPasswordController.text;
    if (email.isEmpty || code.isEmpty || newPassword.length < 6) {
      setState(() => _error = 'E-posta, 6 haneli kod ve en az 6 karakter yeni şifre girin.');
      return;
    }
    setState(() {
      _error = null;
      _loading = true;
    });
    final result = await AuthService.instance.resetPassword(
      email: email,
      code: code,
      newPassword: newPassword,
    );
    setState(() => _loading = false);
    if (result.success) {
      widget.onSuccess();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginView(onLoginSuccess: widget.onSuccess),
          ),
        );
      }
    } else {
      setState(() => _error = result.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Şifremi Unuttum', style: TextStyle(fontSize: 18.sp, color: colors.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
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
                _AuthInput(
                  controller: _emailController,
                  hint: 'E-posta',
                  keyboardType: TextInputType.emailAddress,
                  enabled: !_codeSent,
                ),
                if (_codeSent) ...[
                  SizedBox(height: 16.h),
                  _AuthInput(
                    controller: _codeController,
                    hint: '6 haneli kod',
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                  ),
                  SizedBox(height: 16.h),
                  _AuthInput(
                    controller: _newPasswordController,
                    hint: 'Yeni şifre (en az 6 karakter)',
                    obscureText: _obscurePassword,
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                        color: colors.textHint,
                        size: 22.sp,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ],
                if (_message != null) ...[
                  SizedBox(height: 12.h),
                  Text(
                    _message!,
                    style: TextStyle(color: colors.progressIndicator, fontSize: 13.sp),
                  ),
                ],
                if (_error != null) ...[
                  SizedBox(height: 12.h),
                  Text(
                    _error!,
                    style: TextStyle(color: Colors.red.shade300, fontSize: 13.sp),
                  ),
                ],
                SizedBox(height: 24.h),
                if (!_codeSent)
                  _SubmitButton(
                    loading: _loading,
                    label: 'Kod gönder',
                    onPressed: _sendCode,
                  )
                else ...[
                  _SubmitButton(
                    loading: _loading,
                    label: 'Şifreyi güncelle',
                    onPressed: _resetPassword,
                  ),
                  SizedBox(height: 12.h),
                  TextButton(
                    onPressed: () => setState(() {
                      _codeSent = false;
                      _codeController.clear();
                      _message = null;
                      _error = null;
                    }),
                    child: Text(
                      'Farklı e-posta kullan',
                      style: TextStyle(color: colors.textHint, fontSize: 14.sp),
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
  }
}

class _AuthInput extends StatelessWidget {
  const _AuthInput({
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.enabled = true,
    this.maxLength,
    this.suffix,
  });

  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool enabled;
  final int? maxLength;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceDark.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.surfaceBorder, width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        enabled: enabled,
        maxLength: maxLength,
        style: TextStyle(color: colors.textPrimary, fontSize: 16.sp),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: colors.textHint, fontSize: 16.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          counterText: '',
          suffixIcon: suffix,
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.loading,
    required this.label,
    required this.onPressed,
  });

  final bool loading;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return SizedBox(
      height: 52.h,
      child: FilledButton(
        onPressed: loading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: colors.surfaceMedium,
          foregroundColor: colors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: loading
            ? SizedBox(
                width: 24.w,
                height: 24.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colors.progressIndicator,
                ),
              )
            : Text(label),
      ),
    );
  }
}
