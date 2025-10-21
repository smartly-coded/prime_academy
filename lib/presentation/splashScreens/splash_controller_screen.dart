import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/features/splashScreens/logic/splash_cubit.dart';
import 'package:prime_academy/features/splashScreens/logic/splash_state.dart';
import 'package:prime_academy/layout/app_layout.dart';
import 'package:prime_academy/presentation/splashScreens/splash_one.dart';
import 'package:prime_academy/presentation/splashScreens/splash_two.dart';
import 'package:prime_academy/presentation/splashScreens/splash_three.dart';

class SplashControllerScreen extends StatelessWidget {
  const SplashControllerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit()..start(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocBuilder<SplashCubit, SplashState>(
          builder: (context, state) {
            if (state is SplashOneState) return const SplashOne();
            if (state is SplashTwoState) return const SplashTwo();
            if (state is SplashThreeState) return const SplashThree();
            if (state is SplashFinished) return const AppLayout();
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
