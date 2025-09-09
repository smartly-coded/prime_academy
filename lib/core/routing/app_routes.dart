import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/di/dependency_injection.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/features/authScreen/logic/login_cubit.dart';
import 'package:prime_academy/features/profileScreen/logic/profile_cubit.dart';
import 'package:prime_academy/features/splashScreens/logic/splash_cubit.dart';
import 'package:prime_academy/presentation/Home/veiw/home_screen.dart';
import 'package:prime_academy/presentation/login/veiw/loginScreen.dart';
import 'package:prime_academy/presentation/splashScreens/splash_one.dart';

class AppRoutes {
  static const String login = '/login';
  static const String splash = '/splash';
  static const String Home = '/home';

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<SplashCubit>(),
            child: SplashOne(),
          ),
        );
      case Home:
        final loginResponse = settings.arguments as LoginResponse;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ProfileCubit>(),
            child: HomePage(user: loginResponse),
          ),
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: LoginScreen(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
