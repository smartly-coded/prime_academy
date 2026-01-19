import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/di/dependency_injection.dart';
import 'package:prime_academy/features/CoursesModules/data/repo/lesson_details_repo.dart';
import 'package:prime_academy/features/CoursesModules/data/repo/mark_answered_repo.dart';
import 'package:prime_academy/features/CoursesModules/data/repo/modules_lessons_repo.dart';
import 'package:prime_academy/features/CoursesModules/data/repo/modules_repository.dart';
import 'package:prime_academy/features/CoursesModules/logic/lesson_details_cubit.dart';
import 'package:prime_academy/features/CoursesModules/logic/mark_answered_cubit.dart';
import 'package:prime_academy/features/CoursesModules/logic/module_lessons_cubit.dart';
import 'package:prime_academy/features/CoursesModules/logic/modules_cubit.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/features/authScreen/logic/login_cubit.dart';
import 'package:prime_academy/features/contact_us/data/Repos/contact_us_repo.dart';
import 'package:prime_academy/features/contact_us/logic/inquery_cubit.dart';
import 'package:prime_academy/features/profileScreen/logic/profile_cubit.dart';
import 'package:prime_academy/features/ranckingScreen/data/repos/rank_repo.dart';
import 'package:prime_academy/features/ranckingScreen/logic/rank_cubit.dart';
import 'package:prime_academy/features/splashScreens/logic/splash_cubit.dart';
import 'package:prime_academy/features/startScreen/logic/start_screen_cubit.dart';
import 'package:prime_academy/features/startScreen/logic/student_preview_cubit.dart';
import 'package:prime_academy/features/studentsTestimonals/data/repos/student_testimonal_repo.dart';
import 'package:prime_academy/features/studentsTestimonals/logic/testimonal_cubit.dart';
import 'package:prime_academy/core/networking/api_service.dart';
import 'package:prime_academy/presentation/Home/veiw/home_screen.dart';
import 'package:prime_academy/presentation/Modules/veiw/view_lesson.dart';
import 'package:prime_academy/presentation/Start_homeScreen/student_detail_screen.dart';
import 'package:prime_academy/presentation/login/veiw/loginScreen.dart';
import 'package:prime_academy/presentation/splashScreens/splash_one.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/all_students_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String splash = '/splash';
  static const String Home = '/home';
  static const String studentDetail = 'student-detail';
  static const String moduleLessonsPreview = '/module_lesson_preview';
  static const allStudentsPage = "/allStudentsPage";

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
          builder: (_) => MultiBlocProvider(
            providers: [
              
              BlocProvider(
                create: (context) => ProfileCubit(getIt()),
              ),
              
              
              BlocProvider(
                create: (context) => StartScreenCubit(getIt()),
              ),
              
           
              // BlocProvider(
              //   create: (context) {
              //     final cubit = NotificationCubit(NotificationRepository());
                  
              //     
              //     Future.delayed(const Duration(milliseconds: 1000), () {
              //       if (context.mounted) {
              //         cubit.fetchNotifications();
              //         UnifiedSSEService().registerNotificationCubit(cubit);
              //       }
              //     });
                  
              //     return cubit;
              //   },
              // ),
             
              BlocProvider(
                create: (context) => ModulesCubit(ModulesRepository()),
              ),
              
             
              BlocProvider(
                create: (context) => ContactUsCubit(ContactUsRepo()),
              ),
              
              
              BlocProvider(
                create: (context) => RankCubit(RankRepository()),
              ),
            ],
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
            create: (context) => StudentPreviewCubit(getIt()),
            child: StudentDetailScreen(studentId: studentId),
          ),
        );

      
      case moduleLessonsPreview:
        final args = settings.arguments as Map<String, dynamic>;
        final moduleId = args['moduleId'] as int;
        final courseId = args['courseId'] as int;
        final loginResponse = args['user'] as LoginResponse;
        final itemId = args['itemId'] as int;
        
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
             
              BlocProvider(
                create: (context) => ModuleLessonsCubit(
                  RepositoryProvider.of<ModulesLessonsRepo>(context),
                ),
              ),
              
             
              BlocProvider(
                create: (context) => LessonDetailsCubit(
                  LessonDetailsRepo(getIt<ApiService>()),
                ),
              ),
              

              BlocProvider(
                create: (context) => MarkAnsweredCubit(
                  MarkAnsweredRepo(getIt<ApiService>()),
                ),
              ),
              
        
              BlocProvider(
                create: (context) => TestimonalCubit(
                  StudentTestimonalRepo(getIt<ApiService>()),
                ),
              ),
            ],
            child: ViewModule(
              moduleId: moduleId,
              courseId: courseId,
              user: loginResponse,
              itemId: itemId,
            ),
          ),
        );


      case allStudentsPage:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => StudentPreviewCubit(getIt()),
            child: const AllStudentsPage(),
          ),
        );

      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}