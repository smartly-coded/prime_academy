import 'package:dio/dio.dart';

import 'package:get_it/get_it.dart';
import 'package:prime_academy/core/networking/api_service.dart';
import 'package:prime_academy/features/CoursesModules/data/repo/modules_lessons_repo.dart';
import 'package:prime_academy/features/CoursesModules/logic/module_lessons_cubit.dart';
import 'package:prime_academy/features/authScreen/data/repos/login_repo.dart';
import 'package:prime_academy/features/authScreen/logic/login_cubit.dart';
import 'package:prime_academy/features/profileScreen/data/Repos/student_profile_repo.dart';
import 'package:prime_academy/features/profileScreen/logic/profile_cubit.dart';
import 'package:prime_academy/features/startScreen/data/repos/start_screen_repo.dart';
import 'package:prime_academy/features/startScreen/data/repos/student_preview_repo.dart';
import 'package:prime_academy/features/startScreen/logic/certificate_cubit.dart';
import 'package:prime_academy/features/startScreen/logic/start_screen_cubit.dart';
import 'package:prime_academy/features/startScreen/logic/student_preview_cubit.dart';

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
  getIt.registerLazySingleton<StartScreenRepo>(() => StartScreenRepo(getIt()));
  getIt.registerFactory<StartScreenCubit>(() => StartScreenCubit(getIt()));
  getIt.registerFactory<CertificateCubit>(() => CertificateCubit(getIt()));
  getIt.registerLazySingleton<StudentProfileRepo>(
    () => StudentProfileRepo(getIt()),
  );
  getIt.registerFactory<ProfileCubit>(() => ProfileCubit(getIt()));
  getIt.registerLazySingleton<StudentPreviewRepo>(
    () => StudentPreviewRepo(getIt()),
  );
  getIt.registerFactory<StudentPreviewCubit>(
    () => StudentPreviewCubit(getIt()),
  );
  getIt.registerLazySingleton<ModulesLessonsRepo>(
    () => ModulesLessonsRepo(getIt()),
  );
  getIt.registerFactory<ModuleLessonsCubit>(() => ModuleLessonsCubit(getIt()));
}
