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
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/core/routing/app_routes.dart';
import 'package:prime_academy/features/Notification/logic/notification_cubit.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/features/authScreen/logic/login_cubit.dart';
import 'package:prime_academy/features/startScreen/data/repos/start_screen_repo.dart';
import 'package:prime_academy/features/startScreen/logic/certificate_cubit.dart';
import 'package:prime_academy/features/startScreen/logic/start_screen_cubit.dart';
import 'package:prime_academy/layout/custom_app_bar.dart';
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

  Future<void> _loadUserData() async {
    if (widget.user != null) {
      setState(() {
        _currentUser = widget.user;
      });
      return;
    }

    final loginCubit = context.read<LoginCubit>();
    final savedUser = await loginCubit.loadSavedUser();

    if (savedUser != null) {
      setState(() {
        _currentUser = savedUser;
      });

      loginCubit.currentUser = savedUser;
    }
  }

  final List<Widget> _pages = [
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              StartScreenCubit(getIt<StartScreenRepo>())
                ..emitAllStudentsState(),
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

    ContactUsPage(),
  ];

  Future<void> _handleAccountButton() async {
    try {
      const storage = FlutterSecureStorage();
      final accessToken = await storage.read(key: "accessToken");

      if (accessToken == null || accessToken.isEmpty) {
        print("⏩ No accessToken, navigating to LoginScreen");
        if (mounted) {
          Navigator.pushNamed(context, AppRoutes.login);
        }
        return;
      }

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
      backgroundColor: Mycolors.backgroundColor,
      appBar: CustomAppBar(
        user: _currentUser,
        onAccountPressed: _handleAccountButton, showBackArrow: false,
      ),
      // appBar: AppBar(
      //   backgroundColor:Color.fromRGBO(11, 15, 18, 1.0),
      //   elevation: 0,
      //   title: Image.asset("assets/images/footer-logo.webp", height: 40),
      //   actions: [
      //     Container(
      //       padding: EdgeInsets.all(2),
      //       width: 70,
      //       height: 40,
      //       decoration: BoxDecoration(
      //         gradient: LinearGradient(
      //           colors: Mycolors.primary_color.colors

      //         ),
      //         borderRadius: BorderRadius.circular(20),
      //       ),
      //       child: Container(
      //         width: 50,
      //         height: 30,
      //         decoration: BoxDecoration(
      //           // color: Color(0XFF0f1217),
      //           borderRadius: BorderRadius.circular(20),
      //         ),
      //         child: TextButton(
      //           onPressed: _handleAccountButton,
      //           child: const Text(
      //             "حسابي",
      //             style: TextStyle(color: Colors.white, fontSize: 12),
      //           ),
      //         ),
      //       ),
      //     ),
      //     const SizedBox(width: 10),

      //     //   Container(
      //     //   margin: EdgeInsets.only(left: 6, top: 8, bottom: 8),
      //     //   padding: EdgeInsets.all(2),
      //     //   decoration: BoxDecoration(
      //     //     gradient: LinearGradient(
      //     //       colors:Mycolors.primary_color.colors,
      //     //     ),
      //     //     borderRadius: BorderRadius.circular(18),
      //     //   ),
      //     //   child: Container(
      //     //     padding: EdgeInsets.symmetric(horizontal: 8),
      //     //     decoration: BoxDecoration(
      //     //       color: Color(0XFF0f1217),
      //     //       borderRadius: BorderRadius.circular(16),
      //     //     ),
      //     //     child: Row(
      //     //       mainAxisAlignment: MainAxisAlignment.center,
      //     //       mainAxisSize: MainAxisSize.min,
      //     //       children: [
      //     //         Icon(Icons.location_on, color: Colors.white, size: 14),
      //     //         const SizedBox(width: 3),
      //     //         const Text(
      //     //           "الكويت",
      //     //           style: TextStyle(
      //     //             color: Colors.white,
      //     //             fontSize: 12,
      //     //             fontWeight: FontWeight.w500,
      //     //           ),
      //     //         ),
      //     //       ],
      //     //     ),
      //     //   ),
      //     // ),
      //     if (_currentUser != null)
      //       BlocBuilder<NotificationCubit, NotificationState>(
      //         builder: (context, state) {
      //           bool hasUnread = false;

      //           if (state is NotificationLoaded) {
      //             hasUnread = state.notifications.any((n) => n.isRead == false);
      //           }

      //           return Stack(
      //             clipBehavior: Clip.none,
      //             children: [
      //               Container(
      //                 padding: EdgeInsets.all(2),
      //                 width: 40,
      //                 height: 40,
      //                 decoration: BoxDecoration(
      //                   gradient: LinearGradient(
      //                     colors: Mycolors.primary_color.colors,
      //                   ),
      //                   borderRadius: BorderRadius.circular(50),
      //                 ),                    
      //                 child: Container(         
      //                   decoration: BoxDecoration(
      //                     color: Color(0XFF0f1217),
      //                     borderRadius: BorderRadius.circular(20),
      //                   ),
      //                   child: Center(
      //                     child: IconButton(
      //                       icon: const Icon(
      //                         Icons.notifications_none,
      //                         color: Colors.white,
      //                         size: 20,
      //                       ),
      //                       onPressed: () {
      //                         showNotificationsDialog(context, _currentUser!);
      //                       },            
      //                     ),
      //                   ),
      //                 ),
      //               ),

      //               // النقطة الحمرا لو فيه إشعارات جديدة
      //               if (hasUnread)
      //                 Positioned(
      //                   right: 4,
      //                   top: -1,
      //                   child: Container(
      //                     width: 10,
      //                     height: 10,
      //                     decoration: BoxDecoration(
      //                       color: Colors.red,
      //                       shape: BoxShape.circle,
      //                     ),
      //                   ),
      //                 ),
      //                 Divider(
      //                   indent: 5,
      //                   endIndent: 5,
      //                   color: Colors.white,
      //                 ),
      //             ],
      //           );
      //         },
      //       ),
      //   ],
      // ),
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


// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:prime_academy/core/di/dependency_injection.dart';
// import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
// import 'package:prime_academy/core/routing/app_routes.dart';
// import 'package:prime_academy/features/Notification/logic/notification_cubit.dart';
// import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
// import 'package:prime_academy/features/authScreen/logic/login_cubit.dart';
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
//   LoginResponse? _currentUser;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   Future<void> _loadUserData() async {
//     if (widget.user != null) {
//       setState(() {
//         _currentUser = widget.user;
//       });
//       return;
//     }

//     final loginCubit = context.read<LoginCubit>();
//     final savedUser = await loginCubit.loadSavedUser();

//     if (savedUser != null) {
//       setState(() {
//         _currentUser = savedUser;
//       });
//       loginCubit.currentUser = savedUser;
//     }
//   }

//   final List<Widget> _pages = [
//     MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (_) =>
//               StartScreenCubit(getIt<StartScreenRepo>())
//                 ..emitStartScreenState(),
//         ),
//         BlocProvider(
//           create: (context) =>
//               CertificateCubit(getIt<StartScreenRepo>())
//                 ..emitCertificateState(),
//         ),
//       ],
//       child: StartPage(),
//     ),
//     AboutUsPage(),
//     ContactUsPage(),
//   ];

//   Future<void> _handleAccountButton() async {
//     try {
//       const storage = FlutterSecureStorage();
//       final accessToken = await storage.read(key: "accessToken");

//       if (accessToken == null || accessToken.isEmpty) {
//         print("⏩ No accessToken, navigating to LoginScreen");
//         if (mounted) {
//           Navigator.pushNamed(context, AppRoutes.login);
//         }
//         return;
//       }

//       final userData = await storage.read(key: "userData");

//       if (userData == null || userData.isEmpty) {
//         print("⚠️ Token exists but no userData, navigating to login");
//         await storage.delete(key: "accessToken");
//         await storage.delete(key: "refreshToken");
//         if (mounted) {
//           Navigator.pushNamed(context, AppRoutes.login);
//         }
//         return;
//       }

//       try {
//         final loginResponse = LoginResponse.fromJson(jsonDecode(userData));
//         print("✅ Navigating to HomeScreen from AppLayout");

//         if (mounted) {
//           Navigator.pushNamed(
//             context,
//             AppRoutes.Home,
//             arguments: loginResponse,
//           );
//         }
//       } catch (parseError) {
//         print("❌ Error parsing userData: $parseError");
//         await storage.delete(key: "userData");
//         await storage.delete(key: "accessToken");
//         await storage.delete(key: "refreshToken");

//         if (mounted) {
//           Navigator.pushNamed(context, AppRoutes.login);
//         }
//       }
//     } catch (e) {
//       print("❌ Error in _handleAccountButton: $e");
//       if (mounted) {
//         Navigator.pushNamed(context, AppRoutes.login);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Mycolors.backgroundColor,
//         appBar: AppBar(
//           backgroundColor: Mycolors.backgroundColor,
//           elevation: 0,
         
//           title: Container(
//             padding: EdgeInsets.all(2.5),
//             width: 90,
//             height: 40,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xff4f2349), Color(0xffa76433)],
//               ),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Color(0XFF0f1217),
//                 borderRadius: BorderRadius.circular(18),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     "assets/images/saudi.svg", 
//                     width: 20,
//                     height: 20,
//                   ),
//                   const SizedBox(width: 5),
//                   const Text(
//                     "الكويت",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           centerTitle: true,
          
//           // 👈 اللوجو وزر حسابي على اليمين
//           actions: [
//             Image.asset("assets/images/footer-logo.webp", height: 35),
//             const SizedBox(width: 10),
            
//             // زر حسابي
//             Container(
//               padding: EdgeInsets.all(2),
//               width: 70,
//               height: 35,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Color(0xff4f2349), Color(0xffa76433)],
//                 ),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Color(0XFF0f1217),
//                   borderRadius: BorderRadius.circular(18),
//                 ),
//                 child: TextButton(
//                   onPressed: _handleAccountButton,
//                   style: TextButton.styleFrom(
//                     padding: EdgeInsets.zero,
//                   ),
//                   child: const Text(
//                     "حسابي",
//                     style: TextStyle(color: Colors.white, fontSize: 12),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 10),
            
//             // أيقونة النوتيفيكيشن
//             if (_currentUser != null)
//               BlocBuilder<NotificationCubit, NotificationState>(
//                 builder: (context, state) {
//                   bool hasUnread = false;

//                   if (state is NotificationLoaded) {
//                     hasUnread = state.notifications.any((n) => n.isRead == false);
//                   }

//                   return Stack(
//                     clipBehavior: Clip.none,
//                     children: [
//                       Container(
//                         padding: EdgeInsets.all(2),
//                         width: 40,
//                         height: 40,
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [Color(0xff4f2349), Color(0xffa76433)],
//                           ),
//                           borderRadius: BorderRadius.circular(50),
//                         ),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Color(0XFF0f1217),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Center(
//                             child: IconButton(
//                               icon: const Icon(
//                                 Icons.notifications_none,
//                                 color: Colors.white,
//                                 size: 20,
//                               ),
//                               onPressed: () {
//                                 showNotificationsDialog(context, _currentUser!);
//                               },
//                             ),
//                           ),
//                         ),
//                       ),

//                       if (hasUnread)
//                         Positioned(
//                           right: 4,
//                           top: -1,
//                           child: Container(
//                             width: 10,
//                             height: 10,
//                             decoration: BoxDecoration(
//                               color: Colors.red,
//                               shape: BoxShape.circle,
//                             ),
//                           ),
//                         ),
//                     ],
//                   );
//                 },
//               ),
//             const SizedBox(width: 10),
//           ],
//         ),
//         body: _pages[_currentIndex],
//         bottomNavigationBar: BottomNavigationBar(
//           currentIndex: _currentIndex,
//           onTap: (index) => setState(() => _currentIndex = index),
//           type: BottomNavigationBarType.fixed,
//           selectedItemColor: Colors.orange,
//           unselectedItemColor: Colors.white70,
//           backgroundColor: Colors.black,
//           items: bottomNavItems,
//         ),
//       ),
//     );
//   }
// }
