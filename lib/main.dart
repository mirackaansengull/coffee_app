import 'package:coffee_app/core/constants/app_constants.dart';
import 'package:coffee_app/core/theme/app_theme.dart';
import 'package:coffee_app/data/services/auth_service.dart';
import 'package:coffee_app/views/auth/login_view.dart';
import 'package:coffee_app/views/main_shell_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  bool _isLoggedIn = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    AuthService.instance.loadFromStorage().then((_) {
      if (mounted) {
        setState(() {
          _isLoggedIn = AuthService.instance.isLoggedIn;
          _initialized = true;
        });
      }
    });
  }

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: AppConstants.designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: _themeMode,
          home: !_initialized
              ? const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                )
              : _isLoggedIn
                  ? MainShell(
                      onThemeToggle: _toggleTheme,
                      onLogout: () => setState(() => _isLoggedIn = false),
                    )
                  : LoginView(
                      onLoginSuccess: () => setState(() => _isLoggedIn = true),
                    ),
        );
      },
    );
  }
}
