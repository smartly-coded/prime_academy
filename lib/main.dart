import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/di/dependency_injection.dart';
import 'package:prime_academy/core/routing/app_routes.dart';
import 'package:prime_academy/core/services/firebase_notification_service.dart';
import 'package:prime_academy/core/services/notification_eventsource.dart';
import 'package:prime_academy/features/Chat/data/repos/chat_Repo.dart';
import 'package:prime_academy/features/CoursesModules/data/repo/modules_repository.dart';
import 'package:prime_academy/features/CoursesModules/logic/modules_cubit.dart';
import 'package:prime_academy/features/Notification/data/repos/notification_repo.dart';
import 'package:prime_academy/features/Notification/logic/notification_cubit.dart';
import 'package:prime_academy/features/authScreen/logic/login_cubit.dart';
import 'package:prime_academy/features/contact_us/data/Repos/contact_us_repo.dart';
import 'package:prime_academy/features/contact_us/logic/inquery_cubit.dart';
import 'package:prime_academy/features/ranckingScreen/data/repos/rank_repo.dart';
import 'package:prime_academy/features/ranckingScreen/logic/rank_cubit.dart';
import 'package:prime_academy/features/splashScreens/logic/splash_cubit.dart';
import 'package:prime_academy/layout/app_layout.dart';
import 'package:prime_academy/presentation/ContactUs/ContactUs_page.dart';
import 'package:prime_academy/presentation/splashScreens/custom_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupGetIt();
  await FirebaseNotificationService.initializeFirebaseMessaging();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ChatRepo>(create: (_) => ChatRepo()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => SplashCubit()..start()),
          BlocProvider(create: (_) => RankCubit(RankRepository())),
          BlocProvider(create: (_) => ModulesCubit(ModulesRepository())),
          BlocProvider(
            create: (_) => ContactUsCubit(ContactUsRepo()),
            child: ContactUsPage(),
          ),
          BlocProvider(create: (_) => LoginCubit(getIt())),
          BlocProvider(
            create: (_) => NotificationCubit(
              NotificationRepository(),
              NotificationSSEService(),
            )..fetchNotifications(),
            child: const AppLayout(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
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
