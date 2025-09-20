import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/di/dependency_injection.dart';
import 'package:prime_academy/core/routing/app_routes.dart';
import 'package:prime_academy/core/services/notification_eventsource.dart';
import 'package:prime_academy/features/Chat/data/repos/chat_Repo.dart';
import 'package:prime_academy/features/CoursesModules/data/repo/modules_repository.dart';
import 'package:prime_academy/features/CoursesModules/logic/modules_cubit.dart';
import 'package:prime_academy/features/Notigication/data/repos/notification_repo.dart';
import 'package:prime_academy/features/Notigication/logic/notification_cubit.dart';
import 'package:prime_academy/features/contact_us/data/Repos/contact_us_repo.dart';
import 'package:prime_academy/features/contact_us/logic/inquery_cubit.dart';
import 'package:prime_academy/features/ranckingScreen/data/repos/rank_repo.dart';
import 'package:prime_academy/features/ranckingScreen/logic/rank_cubit.dart';
import 'package:prime_academy/features/splashScreens/logic/splash_cubit.dart';
import 'package:prime_academy/features/splashScreens/logic/splash_state.dart';
import 'package:prime_academy/layout/app_layout.dart';
import 'package:prime_academy/presentation/ContactUs/ContactUs_page.dart';

import 'package:prime_academy/presentation/splashScreens/splash_one.dart';
import 'package:prime_academy/presentation/splashScreens/splash_three.dart';
import 'package:prime_academy/presentation/splashScreens/splash_two.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupGetIt();
  runApp(DevicePreview(enabled: true, builder: (context) => MyApp()));
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MultiRepositoryProvider(
      providers: [
        
        RepositoryProvider<ChatRepo>(
          create: (_) => ChatRepo(),
        ),
      ],
    
    child:  MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SplashCubit()..start(),
        ),
        
        BlocProvider(
          create: (_) => RankCubit(
            RankRepository(
              
            ),
          )
        ),

            BlocProvider(
      create: (context) => ModulesCubit(ModulesRepository(
       
      )),
    ),
    BlocProvider(
  create: (_) => ContactUsCubit(ContactUsRepo()),
  child: ContactUsPage(),
),

BlocProvider(
  create: (_) => NotificationCubit(NotificationRepository(), NotificationSSEService(),)..fetchNotifications(),
  child: AppLayout(),
)


      ],
      child: MaterialApp(
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        onGenerateRoute: AppRoutes().generateRoute,
        debugShowCheckedModeBanner: false,
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: BlocBuilder<SplashCubit, SplashState>(
            builder: (context, state) {
              if (state is SplashOneState) return SplashOne();
              if (state is SplashTwoState) return SplashTwo();
              if (state is SplashThreeState) return SplashThree();
              if (state is SplashFinished) return AppLayout();
              return const SizedBox();
            },
          ),
        ),
      ),
    ));
  }
}
