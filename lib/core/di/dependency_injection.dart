import 'package:dio/dio.dart';

import 'package:get_it/get_it.dart';
import 'package:prime_academy/core/networking/api_service.dart';
import 'package:prime_academy/features/authScreen/data/repos/login_repo.dart';
import 'package:prime_academy/features/authScreen/logic/login_cubit.dart';

import '../networking/dio_factory.dart';

final getIt = GetIt
    .instance; //Simple direct Service Locator that allows to decouple the interface from a concrete implementation and to access the concrete implementation from everywhere in your App

Future<void> setupGetIt() async {
  // Dio & ApiService
  Dio dio = DioFactory.getDio();
  getIt.registerLazySingleton<ApiService>(
    () => ApiService(dio),
  ); //create only one instance

  // login
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));
}
