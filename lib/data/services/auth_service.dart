import 'dart:convert';

import 'package:coffee_app/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  static const _keyToken = 'auth_token';
  static const _keyUser = 'auth_user';

  String? _token;
  Map<String, dynamic>? _user;

  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  bool get isLoggedIn => _token != null && _token!.isNotEmpty;

  Future<void> loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_keyToken);
    final userJson = prefs.getString(_keyUser);
    if (userJson != null) {
      try {
        _user = Map<String, dynamic>.from(jsonDecode(userJson) as Map);
      } catch (_) {}
    }
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    if (_token != null) {
      await prefs.setString(_keyToken, _token!);
      if (_user != null) {
        await prefs.setString(_keyUser, jsonEncode(_user));
      }
    } else {
      await prefs.remove(_keyToken);
      await prefs.remove(_keyUser);
    }
  }

  Future<void> setAuth(String token, Map<String, dynamic> user) async {
    _token = token;
    _user = user;
    await _saveToStorage();
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    await _saveToStorage();
  }

  String get _base => ApiConstants.baseUrl;

  Future<AuthResult> sendRegisterCode(String email) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/api/auth/register/send-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email.trim().toLowerCase()}),
      );
      final data = _decodeBody(res.body);
      if (res.statusCode == 200) {
        return AuthResult.success(message: data['message'] as String? ?? 'Kod gönderildi.');
      }
      return AuthResult.fail(data['error'] as String? ?? 'Bir hata oluştu.');
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
      final data = _decodeBody(res.body);
      if (res.statusCode == 200 && data['token'] != null) {
        await setAuth(
          data['token'] as String,
          Map<String, dynamic>.from(data['user'] as Map),
        );
        return AuthResult.success();
      }
      return AuthResult.fail(data['error'] as String? ?? 'Doğrulama başarısız.');
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
      final data = _decodeBody(res.body);
      if (res.statusCode == 200 && data['token'] != null) {
        await setAuth(
          data['token'] as String,
          Map<String, dynamic>.from(data['user'] as Map),
        );
        return AuthResult.success();
      }
      return AuthResult.fail(data['error'] as String? ?? 'Giriş başarısız.');
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
      final data = _decodeBody(res.body);
      if (res.statusCode == 200) {
        return AuthResult.success(message: data['message'] as String? ?? 'Kod gönderildi.');
      }
      return AuthResult.fail(data['error'] as String? ?? 'Bir hata oluştu.');
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
      final data = _decodeBody(res.body);
      if (res.statusCode == 200) {
        return AuthResult.success(message: data['message'] as String? ?? 'Şifre güncellendi.');
      }
      return AuthResult.fail(data['error'] as String? ?? 'Şifre sıfırlama başarısız.');
    } catch (e) {
      return AuthResult.fail('Bağlantı hatası: $e');
    }
  }

  Map<String, dynamic> _decodeBody(String body) {
    try {
      return Map<String, dynamic>.from(jsonDecode(body) as Map);
    } catch (_) {
      return {};
    }
  }
}

class AuthResult {
  final bool success;
  final String? message;
  final String? error;

  AuthResult._({this.success = false, this.message, this.error});

  factory AuthResult.success({String? message}) =>
      AuthResult._(success: true, message: message);

  factory AuthResult.fail(String error) =>
      AuthResult._(success: false, error: error);
}
