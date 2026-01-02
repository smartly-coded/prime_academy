// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:device_preview/device_preview.dart';
// import 'package:prime_academy/core/di/dependency_injection.dart';
// import 'package:prime_academy/core/networking/api_service.dart';
// import 'package:prime_academy/core/routing/app_routes.dart';
// import 'package:prime_academy/core/services/firebase_notification_service.dart';
// import 'package:prime_academy/core/services/notification_eventsource.dart';
// import 'package:prime_academy/features/Chat/data/repos/chat_Repo.dart';
// import 'package:prime_academy/features/CoursesModules/data/repo/lesson_details_repo.dart';
// import 'package:prime_academy/features/CoursesModules/data/repo/mark_answered_repo.dart';
// import 'package:prime_academy/features/CoursesModules/data/repo/modules_lessons_repo.dart';
// import 'package:prime_academy/features/CoursesModules/data/repo/modules_repository.dart';
// import 'package:prime_academy/features/CoursesModules/logic/lesson_details_cubit.dart';
// import 'package:prime_academy/features/CoursesModules/logic/mark_answered_cubit.dart';
// import 'package:prime_academy/features/CoursesModules/logic/module_lessons_cubit.dart';
// import 'package:prime_academy/features/CoursesModules/logic/modules_cubit.dart';
// import 'package:prime_academy/features/Notification/data/repos/notification_repo.dart';
// import 'package:prime_academy/features/Notification/logic/notification_cubit.dart';
// import 'package:prime_academy/features/authScreen/logic/login_cubit.dart';
// import 'package:prime_academy/features/contact_us/data/Repos/contact_us_repo.dart';
// import 'package:prime_academy/features/contact_us/logic/inquery_cubit.dart';
// import 'package:prime_academy/features/ranckingScreen/data/repos/rank_repo.dart';
// import 'package:prime_academy/features/ranckingScreen/logic/rank_cubit.dart';
// import 'package:prime_academy/features/splashScreens/logic/splash_cubit.dart';
// import 'package:prime_academy/features/startScreen/logic/start_screen_cubit.dart';
// import 'package:prime_academy/features/startScreen/logic/student_preview_cubit.dart';
// import 'package:prime_academy/features/studentsTestimonals/data/repos/student_testimonal_repo.dart';
// import 'package:prime_academy/features/studentsTestimonals/logic/testimonal_cubit.dart';

// import 'package:prime_academy/presentation/splashScreens/custom_splash.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await setupGetIt();
//   await FirebaseNotificationService.initializeFirebaseMessaging();

//   runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));
//   //  runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiRepositoryProvider(
//       providers: [
//         RepositoryProvider<ChatRepo>(create: (_) => ChatRepo()),
//         RepositoryProvider(
//           create: (_) => ModulesLessonsRepo(getIt<ApiService>()),
//         ),
//       ],
//       child: MultiBlocProvider(
//         providers: [
//           BlocProvider(create: (_) => SplashCubit()..start()),
//           BlocProvider(create: (_) => RankCubit(RankRepository())),
//           BlocProvider(create: (_) => ModulesCubit(ModulesRepository())),
//           BlocProvider(create: (_) => ContactUsCubit(ContactUsRepo())),
//           BlocProvider(create: (_) => LoginCubit(getIt())),
//           BlocProvider(
//             create: (_) => NotificationCubit(
//               NotificationRepository(),
//               NotificationSSEService(),
//             )..fetchNotifications(),
//           ),

//           BlocProvider(create: (_) => StartScreenCubit(getIt())),
//           BlocProvider(create: (_) => StudentPreviewCubit(getIt())),
//           BlocProvider(
//             create: (_) => ModuleLessonsCubit(
//               RepositoryProvider.of<ModulesLessonsRepo>(context),
//             ),
//           ),
//           BlocProvider(
//             create: (_) =>
//                 LessonDetailsCubit(LessonDetailsRepo(getIt<ApiService>())),
//           ),
//           BlocProvider(
//             create: (_) =>
//                 MarkAnsweredCubit(MarkAnsweredRepo(getIt<ApiService>())),
//           ),
//           BlocProvider(
//             create: (_) =>
//                 TestimonalCubit(StudentTestimonalRepo(getIt<ApiService>())),
//           ),
//         ],
//         child: MaterialApp(
//           debugShowCheckedModeBanner: false,
//           useInheritedMediaQuery: true,

//           builder: DevicePreview.appBuilder,
//           onGenerateRoute: AppRoutes().generateRoute,
//           home: const CustomSplashScreen(),
//           theme: ThemeData(
//             fontFamily: "Bahij",
//             scaffoldBackgroundColor: Colors.white,
//             textTheme: const TextTheme(
//               bodyLarge: TextStyle(fontFamily: "Bahij"),
//               bodyMedium: TextStyle(fontFamily: "Bahij"),
//               bodySmall: TextStyle(fontFamily: "Bahij"),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:device_preview/device_preview.dart';
import 'package:prime_academy/core/di/dependency_injection.dart';
import 'package:prime_academy/core/networking/api_service.dart';
import 'package:prime_academy/core/routing/app_routes.dart';
import 'package:prime_academy/core/services/firebase_notification_service.dart';
import 'package:prime_academy/core/services/notification_eventsource.dart';
import 'package:prime_academy/features/Chat/data/repos/chat_Repo.dart';
import 'package:prime_academy/features/CoursesModules/data/repo/lesson_details_repo.dart';
import 'package:prime_academy/features/CoursesModules/data/repo/mark_answered_repo.dart';
import 'package:prime_academy/features/CoursesModules/data/repo/modules_lessons_repo.dart';
import 'package:prime_academy/features/CoursesModules/data/repo/modules_repository.dart';
import 'package:prime_academy/features/CoursesModules/logic/lesson_details_cubit.dart';
import 'package:prime_academy/features/CoursesModules/logic/mark_answered_cubit.dart';
import 'package:prime_academy/features/CoursesModules/logic/module_lessons_cubit.dart';
import 'package:prime_academy/features/CoursesModules/logic/modules_cubit.dart';
import 'package:prime_academy/features/Notification/data/repos/notification_repo.dart';
import 'package:prime_academy/features/Notification/logic/notification_cubit.dart';
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

import 'package:prime_academy/presentation/splashScreens/custom_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupGetIt();
  await FirebaseNotificationService.initializeFirebaseMessaging();

 
  FlutterError.onError = (FlutterErrorDetails details) {
    final errorString = details.exception.toString();
    
    
    if (errorString.contains('Connection closed while receiving data') ||
        errorString.contains('IOClient')) {
      return; 
    }
    
   
    FlutterError.presentError(details);
  };

  
  runZonedGuarded(
    () {
      // runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));
      runApp(const MyApp());
    },
    (error, stack) {
      final errorString = error.toString();
      
     
      if (errorString.contains('Connection closed while receiving data') ||
          errorString.contains('IOClient')) {
        return;
      }
      
      
      debugPrint('Caught error: $error');
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ChatRepo>(create: (_) => ChatRepo()),
        RepositoryProvider(
          create: (_) => ModulesLessonsRepo(getIt<ApiService>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => SplashCubit()..start()),
          BlocProvider(create: (_) => RankCubit(RankRepository())),
          BlocProvider(create: (_) => ModulesCubit(ModulesRepository())),
          BlocProvider(create: (_) => ContactUsCubit(ContactUsRepo())),
          BlocProvider(create: (_) => LoginCubit(getIt())),
          BlocProvider(
            create: (_) => NotificationCubit(
              NotificationRepository(),
              NotificationSSEService(),
            )..fetchNotifications(),
          ),
          BlocProvider(create: (_) => ProfileCubit(getIt())),
          BlocProvider(create: (_) => StartScreenCubit(getIt())),
          BlocProvider(create: (_) => StudentPreviewCubit(getIt())),
          BlocProvider(
            create: (_) => ModuleLessonsCubit(
              RepositoryProvider.of<ModulesLessonsRepo>(context),
            ),
          ),
          BlocProvider(
            create: (_) =>
                LessonDetailsCubit(LessonDetailsRepo(getIt<ApiService>())),
          ),
          BlocProvider(
            create: (_) =>
                MarkAnsweredCubit(MarkAnsweredRepo(getIt<ApiService>())),
          ),
          BlocProvider(
            create: (_) =>
                TestimonalCubit(StudentTestimonalRepo(getIt<ApiService>())),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          useInheritedMediaQuery: true,

          // builder: DevicePreview.appBuilder,
          onGenerateRoute: AppRoutes().generateRoute,
          home: const CustomSplashScreen(),
          theme: ThemeData(
            fontFamily: "Bahij",
            scaffoldBackgroundColor: Colors.white,
            textTheme: const TextTheme(
              bodyLarge: TextStyle(fontFamily: "Bahij"),
              bodyMedium: TextStyle(fontFamily: "Bahij"),
              bodySmall: TextStyle(fontFamily: "Bahij"),
            ),
          ),
        ),
      ),
    );
  }
}