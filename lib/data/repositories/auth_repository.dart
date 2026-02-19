import 'dart:convert';

import 'package:coffee_app/core/constants/api_constants.dart';
import 'package:coffee_app/data/models/auth_result.dart';
import 'package:coffee_app/data/models/auth_user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  AuthRepository();

  static const _keyToken = 'auth_token';
  static const _keyUser = 'auth_user';
  String get _base => ApiConstants.baseUrl;

  /// Render gibi ücretsiz sunucular uykuya geçer. İlk istekte uyanana kadar
  /// periyodik ping atar; başarılı olunca tamamlanır (max ~30 sn).
  Future<void> wakeUpBackend() async {
    const maxAttempts = 15;
    const interval = Duration(seconds: 2);
    for (var i = 0; i < maxAttempts; i++) {
      try {
        final res = await http
            .get(Uri.parse(_base))
            .timeout(const Duration(seconds: 10));
        if (res.statusCode == 200) return;
      } catch (_) {}
      if (i < maxAttempts - 1) await Future<void>.delayed(interval);
    }
  }

  Future<AuthUser?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final j = prefs.getString(_keyUser);
    if (j == null) return null;
    try {
      return AuthUser.fromJson(Map<String, dynamic>.from(jsonDecode(j) as Map));
    } catch (_) {
      return null;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUser);
  }

  Future<void> _save(String token, AuthUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyUser, jsonEncode(user.toJson()));
  }

  Future<AuthResult> sendRegisterCode(String email) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/api/auth/register/send-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email.trim().toLowerCase()}),
      );
      final d = _decode(res.body);
      if (res.statusCode == 200) {
        return AuthResult.successResult(
          message: d['message'] as String? ?? 'Kod gönderildi.',
        );
      }
      return AuthResult.fail(d['error'] as String? ?? 'Bir hata oluştu.');
    } catch (e) {
      return AuthResult.fail('Bağlantı hatası: $e');
    }
  }

  Future<AuthResult> verifyRegister({
    required String email,
    required String code,
    required String password,
    String name = '',
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/api/auth/register/verify'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.trim().toLowerCase(),
          'code': code.trim(),
          'password': password,
          'name': name.trim(),
        }),
      );
      final d = _decode(res.body);
      if (res.statusCode == 200 && d['token'] != null && d['user'] != null) {
        final user = AuthUser.fromJson(
          Map<String, dynamic>.from(d['user'] as Map),
        );
        await _save(d['token'] as String, user);
        return AuthResult.successResult(user: user);
      }
      return AuthResult.fail(d['error'] as String? ?? 'Doğrulama başarısız.');
    } catch (e) {
      return AuthResult.fail('Bağlantı hatası: $e');
    }
  }

  Future<AuthResult> login(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.trim().toLowerCase(),
          'password': password,
        }),
      );
      final d = _decode(res.body);
      if (res.statusCode == 200 && d['token'] != null && d['user'] != null) {
        final user = AuthUser.fromJson(
          Map<String, dynamic>.from(d['user'] as Map),
        );
        await _save(d['token'] as String, user);
        return AuthResult.successResult(user: user);
      }
      return AuthResult.fail(d['error'] as String? ?? 'Giriş başarısız.');
    } catch (e) {
      return AuthResult.fail('Bağlantı hatası: $e');
    }
  }

  Future<AuthResult> sendResetCode(String email) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/api/auth/forgot-password/send-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email.trim().toLowerCase()}),
      );
      final d = _decode(res.body);
      if (res.statusCode == 200) {
        return AuthResult.successResult(
          message: d['message'] as String? ?? 'Kod gönderildi.',
        );
      }
      return AuthResult.fail(d['error'] as String? ?? 'Bir hata oluştu.');
    } catch (e) {
      return AuthResult.fail('Bağlantı hatası: $e');
    }
  }

  Future<AuthResult> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/api/auth/forgot-password/reset'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.trim().toLowerCase(),
          'code': code.trim(),
          'newPassword': newPassword,
        }),
      );
      final d = _decode(res.body);
      if (res.statusCode == 200) {
        return AuthResult.successResult(
          message: d['message'] as String? ?? 'Şifre güncellendi.',
        );
      }
      return AuthResult.fail(
        d['error'] as String? ?? 'Şifre sıfırlama başarısız.',
      );
    } catch (e) {
      return AuthResult.fail('Bağlantı hatası: $e');
    }
  }

  Map<String, dynamic> _decode(String body) {
    try {
      return Map<String, dynamic>.from(jsonDecode(body) as Map);
    } catch (_) {
      return {};
    }
  }
}
