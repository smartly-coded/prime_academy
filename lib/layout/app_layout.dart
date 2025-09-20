import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/di/dependency_injection.dart';
import 'package:prime_academy/core/routing/app_routes.dart';
import 'package:prime_academy/features/Notigication/logic/notification_cubit.dart';
import 'package:prime_academy/features/startScreen/data/repos/start_screen_repo.dart';
import 'package:prime_academy/features/startScreen/logic/certificate_cubit.dart';
import 'package:prime_academy/features/startScreen/logic/start_screen_cubit.dart';
import 'package:prime_academy/presentation/ContactUs/ContactUs_page.dart';
import 'package:prime_academy/presentation/Notification/notification_screen.dart';
import 'package:prime_academy/presentation/Start_homeScreen/start-screen.dart';
import 'package:prime_academy/presentation/about/about.dart';
import 'nav_items.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              StartScreenCubit(getIt<StartScreenRepo>())
                ..emitStartScreenState(),
        ),
        BlocProvider(
          create: (context) =>
              CertificateCubit(getIt<StartScreenRepo>())
                ..emitCertificateState(),
        ),
      ],
      child: StartPage(),
    ),

    AboutUsPage(),

    AboutUsPage(),
    ContactUsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Image.asset("assets/images/footer-logo.webp", height: 40),
        actions: [
          Container(
            padding: EdgeInsets.all(2),
            width: 70,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff4f2349), Color(0xffa76433)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: 50,
              height: 30,

              decoration: BoxDecoration(
                color: Color(0XFF0f1217),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.login);
                },
                child: const Text(
                  "حسابي",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),

          // IconButton(
          //   icon: const Icon(Icons.notifications_none, color: Colors.white),
          //   onPressed: () {
          //     showNotificationsDialog(context);
          //   },
          // ),
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              bool hasUnread = false;

              if (state is NotificationLoaded) {
                hasUnread = state.notifications.any((n) => n.isRead == false);
              }
              return Stack(
                clipBehavior:
                    Clip.none, // ✅ عشان يسمح للنقطة تطلع برا لو محتاجة
                children: [
                  Container(
                    padding: EdgeInsets.all(2),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff4f2349), Color(0xffa76433)],
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0XFF0f1217),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: IconButton(
                          icon: const Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            showNotificationsDialog(context);
                          },
                        ),
                      ),
                    ),
                  ),

                  if (hasUnread)
                    Positioned(
                      right: 4,
                      top: -1,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.black,
        items: bottomNavItems,
      ),
    );
  }
}
