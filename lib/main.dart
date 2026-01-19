import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/Utils/GlobalLoadingCubit.dart';
import 'package:prime_academy/core/di/dependency_injection.dart';
import 'package:prime_academy/core/networking/api_service.dart';
import 'package:prime_academy/core/routing/app_routes.dart';
import 'package:prime_academy/core/services/firebase_notification_service.dart';
import 'package:prime_academy/core/services/unified_sse_service.dart';
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
import 'package:prime_academy/layout/GlobalLoadingOverlay.dart';
import 'package:prime_academy/presentation/splashScreens/custom_splash.dart';
import 'package:flutter/foundation.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // تشغيل العمليات الثقيلة بالتوازي
      await Future.wait([
        setupGetIt(),
        FirebaseNotificationService.initializeFirebaseMessaging(),
      ]);

      // معالجة الأخطاء
      FlutterError.onError = (FlutterErrorDetails details) {
        final errorString = details.exception.toString();

        if (errorString.contains('Connection closed while receiving data') ||
            errorString.contains('IOClient') ||
            errorString.contains('SocketException')) {
          return;
        }

        FlutterError.presentError(details);
      };

       runApp(const MyApp());
    },
    (error, stackTrace) {
      final errorString = error.toString();

      if (errorString.contains('Connection closed while receiving data') ||
          errorString.contains('IOClient') ||
          errorString.contains('SocketException')) {
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
          BlocProvider(create: (_) => SplashCubit()..start(), lazy: false),
          BlocProvider(create: (_) => LoginCubit(getIt()), lazy: false),
          BlocProvider(create: (_) => ProfileCubit(getIt()), lazy: false),
          BlocProvider(create: (_) => StartScreenCubit(getIt()), lazy: false),

          BlocProvider(create: (_) => RankCubit(RankRepository()), lazy: true),
          BlocProvider(
            create: (_) => ModulesCubit(ModulesRepository()),
            lazy: true,
          ),
          BlocProvider(create: (_) => GlobalLoadingCubit(), lazy: true),

          BlocProvider(
            create: (_) => ContactUsCubit(ContactUsRepo()),
            lazy: true,
          ),
          BlocProvider(
            create: (context) {
              final cubit = NotificationCubit(NotificationRepository());

              Future.delayed(const Duration(milliseconds: 1000), () {
                if (context.mounted) {
                  cubit.fetchNotifications();
                  UnifiedSSEService().registerNotificationCubit(cubit);
                }
              });

              return cubit;
            },
            lazy: true,
          ),
          BlocProvider(create: (_) => StudentPreviewCubit(getIt()), lazy: true),
          BlocProvider(
            create: (context) => ModuleLessonsCubit(
              RepositoryProvider.of<ModulesLessonsRepo>(context),
            ),
            lazy: true,
          ),
          BlocProvider(
            create: (_) =>
                LessonDetailsCubit(LessonDetailsRepo(getIt<ApiService>())),
            lazy: true,
          ),
          BlocProvider(
            create: (_) =>
                MarkAnsweredCubit(MarkAnsweredRepo(getIt<ApiService>())),
            lazy: true,
          ),
          BlocProvider(
            create: (_) =>
                TestimonalCubit(StudentTestimonalRepo(getIt<ApiService>())),
            lazy: true,
          ),
        ],
        child: MaterialApp(
          builder: (context, child) {
    return Stack(
      children: [
        child!,
        const GlobalLoadingOverlay(),
      ],
    );
  },

          debugShowCheckedModeBanner: false,
          useInheritedMediaQuery: true,

          onGenerateRoute: AppRoutes().generateRoute,
          home: const CustomSplashScreen(),
          theme: ThemeData(
            fontFamily: "Bahij",
            scaffoldBackgroundColor: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
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

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:device_preview/device_preview.dart';
// import 'package:prime_academy/core/Utils/GlobalLoadingCubit.dart';
// import 'package:prime_academy/core/di/dependency_injection.dart';
// import 'package:prime_academy/core/networking/api_service.dart';
// import 'package:prime_academy/core/routing/app_routes.dart';
// import 'package:prime_academy/core/services/firebase_notification_service.dart';
// import 'package:prime_academy/core/services/unified_sse_service.dart';
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
// import 'package:prime_academy/features/profileScreen/logic/profile_cubit.dart';
// import 'package:prime_academy/features/ranckingScreen/data/repos/rank_repo.dart';
// import 'package:prime_academy/features/ranckingScreen/logic/rank_cubit.dart';
// import 'package:prime_academy/features/splashScreens/logic/splash_cubit.dart';
// import 'package:prime_academy/features/startScreen/logic/start_screen_cubit.dart';
// import 'package:prime_academy/features/startScreen/logic/student_preview_cubit.dart';
// import 'package:prime_academy/features/studentsTestimonals/data/repos/student_testimonal_repo.dart';
// import 'package:prime_academy/features/studentsTestimonals/logic/testimonal_cubit.dart';
// import 'package:prime_academy/layout/GlobalLoadingOverlay.dart';
// import 'package:prime_academy/presentation/splashScreens/custom_splash.dart';
// import 'package:flutter/foundation.dart';

// void main() {
//   runZonedGuarded(
//     () async {
//       WidgetsFlutterBinding.ensureInitialized();

     
//       await Future.wait([
//         setupGetIt(),
//         FirebaseNotificationService.initializeFirebaseMessaging(),
//       ]);

      
//       FlutterError.onError = (FlutterErrorDetails details) {
//         final errorString = details.exception.toString();

//         if (errorString.contains('Connection closed while receiving data') ||
//             errorString.contains('IOClient') ||
//             errorString.contains('SocketException')) {
//           return;
//         }

//         FlutterError.presentError(details);
//       };

//       runApp(
//         DevicePreview(
//           enabled: !kReleaseMode,
//           builder: (context) => const MyApp(),
//         ),
//       );
     
//     },
//     (error, stackTrace) {
//       final errorString = error.toString();

//       if (errorString.contains('Connection closed while receiving data') ||
//           errorString.contains('IOClient') ||
//           errorString.contains('SocketException')) {
//         return;
//       }

//       debugPrint('Caught error: $error');
//     },
//   );
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
          
//           BlocProvider.value(
//             value: getIt<GlobalLoadingCubit>(),
//           ),
          
//           BlocProvider(create: (_) => SplashCubit()..start(), lazy: false),
//           BlocProvider(create: (_) => LoginCubit(getIt()), lazy: false),
//           BlocProvider(create: (_) => ProfileCubit(getIt()), lazy: false),
//           BlocProvider(create: (_) => StartScreenCubit(getIt()), lazy: false),
//           BlocProvider(create: (_) => RankCubit(RankRepository()), lazy: true),
//           BlocProvider(
//             create: (_) => ModulesCubit(ModulesRepository()),
//             lazy: true,
//           ),
         
          
//           BlocProvider(
//             create: (_) => ContactUsCubit(ContactUsRepo()),
//             lazy: true,
//           ),
//           BlocProvider(
//             create: (context) {
//               final cubit = NotificationCubit(NotificationRepository());

//               Future.delayed(const Duration(milliseconds: 1000), () {
//                 if (context.mounted) {
//                   cubit.fetchNotifications();
//                   UnifiedSSEService().registerNotificationCubit(cubit);
//                 }
//               });

//               return cubit;
//             },
//             lazy: true,
//           ),
//           BlocProvider(create: (_) => StudentPreviewCubit(getIt()), lazy: true),
//           BlocProvider(
//             create: (context) => ModuleLessonsCubit(
//               RepositoryProvider.of<ModulesLessonsRepo>(context),
//             ),
//             lazy: true,
//           ),
//           BlocProvider(
//             create: (_) =>
//                 LessonDetailsCubit(LessonDetailsRepo(getIt<ApiService>())),
//             lazy: true,
//           ),
//           BlocProvider(
//             create: (_) =>
//                 MarkAnsweredCubit(MarkAnsweredRepo(getIt<ApiService>())),
//             lazy: true,
//           ),
//           BlocProvider(
//             create: (_) =>
//                 TestimonalCubit(StudentTestimonalRepo(getIt<ApiService>())),
//             lazy: true,
//           ),
//         ],
//         child: MaterialApp(
//           debugShowCheckedModeBanner: false,
//           useInheritedMediaQuery: true,
//           builder: (context, child) {
//             final previewChild = DevicePreview.appBuilder(context, child);

//             return Stack(
//               children: [
//                 previewChild, 
//                 const GlobalLoadingOverlay(),
//               ],
//             );
//           },
//           onGenerateRoute: AppRoutes().generateRoute,
//           home: const CustomSplashScreen(),
//           theme: ThemeData(
//             fontFamily: "Bahij",
//             scaffoldBackgroundColor: Colors.white,
//             visualDensity: VisualDensity.adaptivePlatformDensity,
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

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:device_preview/device_preview.dart';
// import 'package:prime_academy/core/Utils/GlobalLoadingCubit.dart';
// import 'package:prime_academy/core/di/dependency_injection.dart';
// import 'package:prime_academy/core/routing/app_routes.dart';
// import 'package:prime_academy/core/services/firebase_notification_service.dart';
// import 'package:prime_academy/core/services/unified_sse_service.dart';
// import 'package:prime_academy/features/Chat/data/repos/chat_Repo.dart';
// import 'package:prime_academy/features/CoursesModules/data/repo/modules_lessons_repo.dart';
// import 'package:prime_academy/core/networking/api_service.dart';
// import 'package:prime_academy/features/Notification/data/repos/notification_repo.dart';
// import 'package:prime_academy/features/Notification/logic/notification_cubit.dart';
// import 'package:prime_academy/features/authScreen/logic/login_cubit.dart';
// import 'package:prime_academy/features/splashScreens/logic/splash_cubit.dart';
// import 'package:prime_academy/features/startScreen/logic/student_preview_cubit.dart';
// import 'package:prime_academy/layout/GlobalLoadingOverlay.dart';
// import 'package:prime_academy/presentation/splashScreens/custom_splash.dart';
// import 'package:flutter/foundation.dart';

// void main() {
//   runZonedGuarded(
//     () async {
//       WidgetsFlutterBinding.ensureInitialized();

//       await Future.wait([
//         setupGetIt(),
//         FirebaseNotificationService.initializeFirebaseMessaging(),
//       ]);

//       FlutterError.onError = (FlutterErrorDetails details) {
//         final errorString = details.exception.toString();

//         if (errorString.contains('Connection closed while receiving data') ||
//             errorString.contains('IOClient') ||
//             errorString.contains('SocketException')) {
//           return;
//         }

//         FlutterError.presentError(details);
//       };

//       runApp(
//         DevicePreview(
//           enabled: !kReleaseMode,
//           builder: (context) => const MyApp(),
//         ),
//       );
//     },
//     (error, stackTrace) {
//       final errorString = error.toString();

//       if (errorString.contains('Connection closed while receiving data') ||
//           errorString.contains('IOClient') ||
//           errorString.contains('SocketException')) {
//         return;
//       }

//       debugPrint('Caught error: $error');
//     },
//   );
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
          
//           BlocProvider.value(
//             value: getIt<GlobalLoadingCubit>(),
//           ),
          
         
//           BlocProvider(
//             create: (_) => SplashCubit()..start(),
//             lazy: false,
//           ),
          
         
//           BlocProvider(
//             create: (_) => LoginCubit(getIt()),
//             lazy: false,
//           ),
//           BlocProvider(
//                 create: (context) {
//                   final cubit = NotificationCubit(NotificationRepository());
                  
                 
//                   Future.delayed(const Duration(milliseconds: 1000), () {
//                     if (context.mounted) {
//                       cubit.fetchNotifications();
//                       UnifiedSSEService().registerNotificationCubit(cubit);
//                     }
//                   });
                  
//                   return cubit;
//                 },
//               ),
//               BlocProvider(
//                 create: (_) => StudentPreviewCubit(getIt()),)
//         ],
//         child: MaterialApp(
//           debugShowCheckedModeBanner: false,
//           useInheritedMediaQuery: true,
//           builder: (context, child) {
//             final previewChild = DevicePreview.appBuilder(context, child);

//             return Stack(
//               children: [
//                 previewChild,
//                 // const GlobalLoadingOverlay(),
//               ],
//             );
//           },
//           onGenerateRoute: AppRoutes().generateRoute,
//           home: const CustomSplashScreen(),
//           theme: ThemeData(
//             fontFamily: "Bahij",
//             scaffoldBackgroundColor: Colors.white,
//             visualDensity: VisualDensity.adaptivePlatformDensity,
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