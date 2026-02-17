import 'package:coffee_app/data/models/auth_user.dart';

class AuthResult {
  const AuthResult._({
    this.success = false,
    this.message,
    this.error,
    this.user,
  });

  final bool success;
  final String? message;
  final String? error;
  final AuthUser? user;

  factory AuthResult.successResult({String? message, AuthUser? user}) =>
      AuthResult._(success: true, message: message, user: user);

  factory AuthResult.fail(String error) =>
      AuthResult._(success: false, error: error);
}
