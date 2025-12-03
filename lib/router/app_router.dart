import 'package:flutter/material.dart';
import 'package:luar_sekolah_lms/main_shell.dart';
import 'package:luar_sekolah_lms/features/auth_module/presentation/screens/login_screen.dart';

class RouteNames {
  static const login = '/login';
  static const shell = '/shell';
}

Route _fadeSlide(Widget page) => PageRouteBuilder(
  pageBuilder: (_, __, ___) => page,
  transitionDuration: const Duration(milliseconds: 280),
  transitionsBuilder: (_, a, __, child) {
    final fade = CurvedAnimation(parent: a, curve: Curves.easeOutCubic);
    final slide = Tween<Offset>(
      begin: const Offset(0, .04),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(a);
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(position: slide, child: child),
    );
  },
);

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings s) {
    switch (s.name) {
      case RouteNames.login:
        return _fadeSlide(const LoginScreen());
      case RouteNames.shell:
        return _fadeSlide(const MainShell());
      default:
        return _fadeSlide(const LoginScreen());
    }
  }

  static void goToShell(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(RouteNames.shell);
  }

  static void goToLoginClearingStack(BuildContext context) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(RouteNames.login, (r) => false);
  }
}
