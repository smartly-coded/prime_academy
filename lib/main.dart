import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/features/splashScreens/logic/splash_cubit.dart';
import 'package:prime_academy/features/splashScreens/logic/splash_state.dart';
import 'package:prime_academy/presentation/homeScreen/start-screen.dart';
import 'package:prime_academy/presentation/splashScreens/splash_one.dart';
import 'package:prime_academy/presentation/splashScreens/splash_three.dart';
import 'package:prime_academy/presentation/splashScreens/splash_two.dart';

void main() {
  runApp(DevicePreview(enabled: true, builder: (context) => MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..start(),
      child: MaterialApp(
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<SplashCubit, SplashState>(
          builder: (context, state) {
            if (state is SplashOneState) return SplashOne();
            if (state is SplashTwoState) return SplashTwo();
            if (state is SplashThreeState) return SplashThree();
            if (state is SplashFinished) return StartScreen();
            return SizedBox(); // أول ما يفتح قبل تحديد الحالة
          },
        ),
      ),
    );
  }
}
