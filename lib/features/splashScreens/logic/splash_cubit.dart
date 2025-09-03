import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  void start() async {
    emit(SplashOneState());
    await Future.delayed(Duration(seconds: 10));

    emit(SplashTwoState());
    await Future.delayed(Duration(seconds: 10));
    emit(SplashThreeState());
    await Future.delayed(Duration(seconds: 10));
    emit(SplashFinished());
  }
}
