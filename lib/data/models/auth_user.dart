class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    this.name = '',
    this.isAdmin = false,
  });

  final String id;
  final String email;
  final String name;
  final bool isAdmin;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      isAdmin: json['isAdmin'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'isAdmin': isAdmin,
  };
}
