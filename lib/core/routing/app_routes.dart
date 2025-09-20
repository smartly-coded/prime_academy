import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/di/dependency_injection.dart';
import 'package:prime_academy/features/CoursesModules/logic/lesson_details_cubit.dart';
import 'package:prime_academy/features/CoursesModules/logic/module_lessons_cubit.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/features/authScreen/logic/login_cubit.dart';
import 'package:prime_academy/features/profileScreen/logic/profile_cubit.dart';
import 'package:prime_academy/features/splashScreens/logic/splash_cubit.dart';
import 'package:prime_academy/features/startScreen/logic/student_preview_cubit.dart';
import 'package:prime_academy/presentation/Home/veiw/home_screen.dart';
import 'package:prime_academy/presentation/Modules/veiw/view_lesson.dart';
import 'package:prime_academy/presentation/Start_homeScreen/student_detail_screen.dart';
import 'package:prime_academy/presentation/login/veiw/loginScreen.dart';
import 'package:prime_academy/presentation/splashScreens/splash_one.dart';

class AppRoutes {
  static const String login = '/login';
  static const String splash = '/splash';
  static const String Home = '/home';
  static const String studentDetail = 'student-detail';
  static const String moduleLessonsPreview = '/module_lesson_preview';
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
      case studentDetail:
        final studentId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<StudentPreviewCubit>(),
            child: StudentDetailScreen(studentId: studentId),
          ),
        );
      case moduleLessonsPreview:
        final args = settings.arguments as Map<String, dynamic>;
        final moduleId = args['moduleId'] as int;
        final courseId = args['courseId'] as int;
        final videoUrl = args['externalUrl'] as String?;
         final loginResponse = args['user'] as LoginResponse;
        final itemId = args['itemId'] as int;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<ModuleLessonsCubit>()),
              BlocProvider(create: (context) => getIt<LessonDetailsCubit>()),
            ],
            child: ViewModule(
              moduleId: moduleId,
              courseId: courseId,
              selectedVideoUrl: videoUrl, user: loginResponse,
              itemId: itemId,
            ),
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
