// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:prime_academy/core/di/dependency_injection.dart';
// import 'package:prime_academy/core/routing/app_routes.dart';
// import 'package:prime_academy/features/Notification/logic/notification_cubit.dart';
// import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
// import 'package:prime_academy/features/startScreen/data/repos/start_screen_repo.dart';
// import 'package:prime_academy/features/startScreen/logic/certificate_cubit.dart';
// import 'package:prime_academy/features/startScreen/logic/start_screen_cubit.dart';
// import 'package:prime_academy/presentation/ContactUs/ContactUs_page.dart';
// import 'package:prime_academy/presentation/Notification/notification_screen.dart';
// import 'package:prime_academy/presentation/Start_homeScreen/start-screen.dart';
// import 'package:prime_academy/presentation/about/about.dart';
// import 'nav_items.dart';

// class AppLayout extends StatefulWidget {
//   const AppLayout({super.key, this.user});
//   final LoginResponse? user;
//   @override
//   State<AppLayout> createState() => _AppLayoutState();
// }

// class _AppLayoutState extends State<AppLayout> {
//   int _currentIndex = 0;
//     MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (_) =>
//               StartScreenCubit(getIt<StartScreenRepo>())
//                 ..emitStartScreenState(),
//         ),
//        BlocProvider(
//             create: (context) =>
//               CertificateCubit(getIt<StartScreenRepo>())
//                 ..emitCertificateState(),
//           ),
//       ],
//       child: StartPage(),    ),

//     AboutUsPage(),

//     AboutUsPage(),
//     ContactUsPage(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 0,
//         title: Image.asset("assets/images/footer-logo.webp", height: 40),
//         // actions: [
//         //   Container(
//         //     padding: EdgeInsets.all(2),
//         //     width: 70,
//         //     height: 40,
//         //     decoration: BoxDecoration(
//         //       gradient: LinearGradient(
//         //         colors: [Color(0xff4f2349), Color(0xffa76433)],
//         //       ),
//         //       borderRadius: BorderRadius.circular(20),
//         //     ),
//         //     child: Container(
//         //       width: 50,
//         //       height: 30,

//         //       decoration: BoxDecoration(
//         //         color: Color(0XFF0f1217),
//         //         borderRadius: BorderRadius.circular(20),
//         //       ),
//         //       child: TextButton(
//         //         onPressed: () {
//         //           Navigator.pushNamed(context, AppRoutes.login);
//         //         },
//         //         child: const Text(
//         //           "حسابي",
//         //           style: TextStyle(color: Colors.white),
//         //         ),
//         //       ),
//         //     ),
//         //   ),

//         //   // IconButton(
//         //   //   icon: const Icon(Icons.notifications_none, color: Colors.white),
//         //   //   onPressed: () {
//         //   //     showNotificationsDialog(context);
//         //   //   },
//         //   // ),
//         //   BlocBuilder<NotificationCubit, NotificationState>(
//         //     builder: (context, state) {
//         //       bool hasUnread = false;

//         //       if (state is NotificationLoaded) {
//         //         hasUnread = state.notifications.any((n) => n.isRead == false);
//  }
//         //       return Stack(
//         //         cliBehavior:
//         //             Clip.none, // ✅ عشان يسمح للنقطة تطلع برا لو محتاجة
//         //         children: [
//         //           Container(
//         //             padding: EdgeInsets.all(2),
//         //             width: 40,
//         //             height: 40,
//         //             decoration: BoxDecoration(
//         //               gradient: LinearGradient(
//         //                 colors: [Color(0xff4f2349), Color(0xffa76433)],
//         //               ),
//         //               borderRadius: BorderRadius.circular(50),
//         //             ),
//         //             child: Container(
//         //               decoration: BoxDecoration(
//         //                 color: Color(0XFF0f1217),
//         //                 borderRadius: BorderRadius.circular(20),
//         //               ),
//         //               child: Center(
//         //                 child: IconButton(
//         //                   icon: const Icon(
//         //                     Icons.notifications_none,
//         //                     color: Colors.white,
//         //                     size: 20,
//         //                   ),
//         //                   onPressed: () {
//         //                     if (widget.user == null) {
//         //                       Navigator.pushNamed(context, AppRoutes.login);
//         //                     } else {
//         //                       showNotificationsDialog(context, widget.user!);
//         //                     }
//         //                   },
//         //                 ),
//         //               ),
//         //             ),
//         //           ),

//         //           if (hasUnread)
//         //             Positioned(
//         //               right: 4,
//         //               top: -1,
//         //               child: Container(
//         //                 width: 10,
//         //                 height: 10,
//         //                 decoration: BoxDecoration(
//         //                   color: Colors.red,
//         //                   shape: BoxShape.circle,
//         //                 ),
//         //               ),
//         //             ),
//         //         ],
//         //       );
//         //     },
//         //   ),
//         // ],
//         actions: [
//   Container(
//     padding: EdgeInsets.all(2),
//     width: 70,
//     height: 40,
//     decoration: BoxDecoration(
//       gradient: LinearGradient(
//         colors: [Color(0xff4f2349), Color(0xffa76433)],
//       ),
//       borderRadius: BorderRadius.circular(20),
//     ),
//     child: Container(
//       width: 50,
//       height: 30,
//       decoration: BoxDecoration(
//         color: Color(0XFF0f1217),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: TextButton(
//         onPressed: () {
//           Navigator.pushNamed(context, AppRoutes.login);
//         },
//         child: const Text(
//           "حسابي",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//     ),
//   ),

//   // ✅ هنا الشرط الجديد
//   if (widget.user != null)
//     BlocBuilder<NotificationCubit, NotificationState>(
//       builder: (context, state) {
//         bool hasUnread = false;

//         if (state is NotificationLoaded) {
//           hasUnread = state.notifications.any((n) => n.isRead == false);
//         }

//         return Stack(
//           clipBehavior: Clip.none,
//           children: [
//             Container(
//               padding: EdgeInsets.all(2),
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Color(0xff4f2349), Color(0xffa76433)],
//                 ),
//                 borderRadius: BorderRadius.circular(50),
//               ),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Color(0XFF0f1217),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Center(
//                   child: IconButton(
//                     icon: const Icon(
//                       Icons.notifications_none,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                     onPressed: () {
//                       showNotificationsDialog(context, widget.user!);
//                     },
//                   ),
//                 ),
//               ),
//             ),

//             if (hasUnread)
//               Positioned(
//                 right: 4,
//                 top: -1,
//                 child: Container(
//                   width: 10,
//                   height: 10,
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//               ),
//           ],
//         );
//       },
//     ),
// ],

//       ),
//       body: _pages[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) => setState(() => _currentIndex = index),
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Colors.orange,
//         unselectedItemColor: Colors.white70,
//         backgroundColor: Colors.black,
//         items: bottomNavItems,
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:prime_academy/core/di/dependency_injection.dart';
import 'package:prime_academy/core/routing/app_routes.dart';
import 'package:prime_academy/features/Notification/logic/notification_cubit.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/features/authScreen/logic/login_cubit.dart';
import 'package:prime_academy/features/startScreen/data/repos/start_screen_repo.dart';
import 'package:prime_academy/features/startScreen/logic/certificate_cubit.dart';
import 'package:prime_academy/features/startScreen/logic/start_screen_cubit.dart';
import 'package:prime_academy/presentation/ContactUs/ContactUs_page.dart';
import 'package:prime_academy/presentation/Notification/notification_screen.dart';
import 'package:prime_academy/presentation/Start_homeScreen/start-screen.dart';
import 'package:prime_academy/presentation/about/about.dart';
import 'nav_items.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key, this.user});
  final LoginResponse? user;

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _currentIndex = 0;
  LoginResponse? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // 🔥 دالة لتحميل بيانات المستخدم
  Future<void> _loadUserData() async {
    // لو جاي من الـ constructor
    if (widget.user != null) {
      setState(() {
        _currentUser = widget.user;
      });
      return;
    }

    // لو مش جاي، جيبه من LoginCubit
    final loginCubit = context.read<LoginCubit>();
    final savedUser = await loginCubit.loadSavedUser();

    if (savedUser != null) {
      setState(() {
        _currentUser = savedUser;
      });
      // حدّث الـ LoginCubit كمان
      loginCubit.currentUser = savedUser;
    }
  }

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

  // 🔥 دالة للتعامل مع زر "حسابي"
  Future<void> _handleAccountButton() async {
    try {
      const storage = FlutterSecureStorage();
      final accessToken = await storage.read(key: "accessToken");

      // لو مافيش توكن، روح تسجيل دخول
      if (accessToken == null || accessToken.isEmpty) {
        print("⏩ No accessToken, navigating to LoginScreen");
        if (mounted) {
          Navigator.pushNamed(context, AppRoutes.login);
        }
        return;
      }

      // لو فيه توكن، اجيب بيانات المستخدم
      final userData = await storage.read(key: "userData");

      if (userData == null || userData.isEmpty) {
        print("⚠️ Token exists but no userData, navigating to login");
        await storage.delete(key: "accessToken");
        await storage.delete(key: "refreshToken");
        if (mounted) {
          Navigator.pushNamed(context, AppRoutes.login);
        }
        return;
      }

      try {
        final loginResponse = LoginResponse.fromJson(jsonDecode(userData));
        print("✅ Navigating to HomeScreen from AppLayout");

        if (mounted) {
          Navigator.pushNamed(
            context,
            AppRoutes.Home,
            arguments: loginResponse,
          );
        }
      } catch (parseError) {
        print("❌ Error parsing userData: $parseError");
        await storage.delete(key: "userData");
        await storage.delete(key: "accessToken");
        await storage.delete(key: "refreshToken");

        if (mounted) {
          Navigator.pushNamed(context, AppRoutes.login);
        }
      }
    } catch (e) {
      print("❌ Error in _handleAccountButton: $e");
      if (mounted) {
        Navigator.pushNamed(context, AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Image.asset("assets/images/footer-logo.webp", height: 40),
        actions: [
          // زر "حسابي"
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
                onPressed: _handleAccountButton, // 🔥 استخدم الدالة الجديدة
                child: const Text(
                  "حسابي",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // 🔥 أيقونة النوتيفيكيشن - تظهر بس لو اليوزر مسجل
          if (_currentUser != null)
            BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                bool hasUnread = false;

                if (state is NotificationLoaded) {
                  hasUnread = state.notifications.any((n) => n.isRead == false);
                }

                return Stack(
                  clipBehavior: Clip.none,
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
                              showNotificationsDialog(context, _currentUser!);
                            },
                          ),
                        ),
                      ),
                    ),

                    // النقطة الحمرا لو فيه إشعارات جديدة
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
