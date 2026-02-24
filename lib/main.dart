import 'package:coffee_app/core/constants/app_constants.dart';
import 'package:coffee_app/core/theme/app_theme.dart';
import 'package:coffee_app/data/repositories/auth_repository.dart';
import 'package:coffee_app/data/repositories/banner_repository.dart';
import 'package:coffee_app/data/repositories/bloc/auth_bloc.dart';
import 'package:coffee_app/views/admin/admin_view.dart';
import 'package:coffee_app/views/auth/loading_view.dart';
import 'package:coffee_app/views/auth/login_view.dart';
import 'package:coffee_app/views/main_shell_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await BannerRepository.instance.loadBannerImageUrls();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthRepository>(
      create: (_) => AuthRepository(),
      child: BlocProvider<AuthBloc>(
        create: (context) =>
            AuthBloc(repository: context.read<AuthRepository>()),
        child: ScreenUtilInit(
          designSize: AppConstants.designSize,
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: _themeMode,
              home: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthInitial || state is AuthLoading) {
                    return LoadingView(
                      onInit: state is AuthInitial
                          ? () async {
                              await context
                                  .read<AuthRepository>()
                                  .wakeUpBackend();
                              if (context.mounted) {
                                context.read<AuthBloc>().add(
                                  AuthCheckRequested(),
                                );
                              }
                            }
                          : null,
                    );
                  }
                  if (state is AuthAuthenticated) {
                    if (state.user.isAdmin) {
                      return const AdminView();
                    }
                    return MainShell(
                      user: state.user,
                      onThemeToggle: _toggleTheme,
                      onLogout: () =>
                          context.read<AuthBloc>().add(AuthLogoutRequested()),
                    );
                  }
                  return const LoginView();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
