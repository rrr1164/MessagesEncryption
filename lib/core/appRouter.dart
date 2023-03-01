import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:message_encrypter/presentation/views/authentication/loginScreen.dart';
import 'package:message_encrypter/presentation/views/authentication/registerScreen.dart';
import 'package:message_encrypter/presentation/views/home/homeScreen.dart';
import 'package:message_encrypter/presentation/views/splash/splashScreen.dart';

abstract class AppRouter {
  static const kHomeScreen = '/homeScreen';
  static const kRegisterScreen = '/Register';
  static const kSplashScreen = '/';
  static const kLoginScreen = '/LoginScreen';
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: kSplashScreen,
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),

      GoRoute(
        path: kRegisterScreen,
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterScreen();
        },
      ),
      GoRoute(
        path: kHomeScreen,
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: kLoginScreen,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
    ],
  );

  static void navigateToLogin(BuildContext context) {
    GoRouter.of(context).pushReplacement(AppRouter.kLoginScreen);
  }
  static void navigateToRegister(BuildContext context) {
    GoRouter.of(context).pushReplacement(AppRouter.kRegisterScreen);
  }

  static void navigateToHome(BuildContext context) {
    GoRouter.of(context).pushReplacement(AppRouter.kHomeScreen);
  }
}
