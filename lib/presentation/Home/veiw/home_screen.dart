// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:prime_academy/core/helpers/constants.dart';
// import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
// import 'package:prime_academy/core/routing/app_routes.dart';
// import 'package:prime_academy/features/Notification/logic/notification_cubit.dart';
// import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
// import 'package:prime_academy/features/profileScreen/data/models/student_profile_response.dart';
// import 'package:prime_academy/features/profileScreen/logic/profile_cubit.dart';
// import 'package:prime_academy/features/profileScreen/logic/profile_state.dart';
// import 'package:prime_academy/presentation/Notification/notification_screen.dart';
// import 'package:prime_academy/presentation/widgets/homeWidgets/category_tabs.dart';
// import 'package:prime_academy/presentation/widgets/homeWidgets/course_card.dart';
// import 'package:prime_academy/presentation/widgets/homeWidgets/empty_state.dart';
// import 'package:prime_academy/presentation/widgets/homeWidgets/logout_button.dart';

// import 'package:prime_academy/presentation/widgets/homeWidgets/profile_header.dart';
// import 'package:prime_academy/presentation/widgets/homeWidgets/reward_box.dart';
// import 'package:prime_academy/presentation/widgets/homeWidgets/my_rank.dart';

// class HomePage extends StatefulWidget {
//   final LoginResponse user;
//   const HomePage({super.key, required this.user});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int selectedIndex = 0;
//   @override
//   void initState() {
//     context.read<ProfileCubit>().emitprofileState();
//     super.initState();
//   }
// Future<void> _handleAccountButton() async {
//     try {
//       const storage = FlutterSecureStorage();
//       final accessToken = await storage.read(key: "accessToken");

//       // لو مافيش توكن، روح تسجيل دخول
//       if (accessToken == null || accessToken.isEmpty) {
//         print("⏩ No accessToken, navigating to LoginScreen");
//         if (mounted) {
//           Navigator.pushNamed(context, AppRoutes.login);
//         }
//         return;
//       }

//       // لو فيه توكن، اجيب بيانات المستخدم
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
//     final width = MediaQuery.of(context).size.width;
//     final isMobile = width < 600;

//     return Scaffold(
//       backgroundColor: Mycolors.backgroundColor,
//       // appBar: AppBar(
//       //   backgroundColor: Mycolors.backgroundColor,
//       //   elevation: 0,
//       //   title: Image.asset("assets/images/footer-logo.webp", height: 40),
//       //   actions: [
//       //     Container(
//       //       padding: EdgeInsets.all(2),
//       //       width: 70,
//       //       height: 40,
//       //       decoration: BoxDecoration(
//       //         gradient: LinearGradient(
//       //           colors: [Color(0xff4f2349), Color(0xffa76433)],
//       //         ),
//       //         borderRadius: BorderRadius.circular(20),
//       //       ),
//       //       child: Container(
//       //         width: 50,
//       //         height: 30,

//       //         decoration: BoxDecoration(
//       //           color: Color(0XFF0f1217),
//       //           borderRadius: BorderRadius.circular(20),
//       //         ),
//       //         child: TextButton(
//       //           onPressed: () {},
//       //           child: const Text(
//       //             "حسابي",
//       //             style: TextStyle(color: Colors.white),
//       //           ),
//       //         ),
//       //       ),
//       //     ),
//       //     IconButton(
//       //       icon: const Icon(Icons.notifications_none, color: Colors.white),
//       //       onPressed: () {},
//       //     ),
//       //   ],
//       // ),

//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 0,
//         title: Image.asset("assets/images/footer-logo.webp", height: 40),
//         actions: [
//           // زر "حسابي"
//           Container(
//             padding: EdgeInsets.all(2),
//             width: 70,
//             height: 40,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xff4f2349), Color(0xffa76433)],
//               ),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Container(
//               width: 50,
//               height: 30,
//               decoration: BoxDecoration(
//                 color: Color(0XFF0f1217),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: TextButton(
//                 onPressed: _handleAccountButton, // 🔥 استخدم الدالة الجديدة
//                 child: const Text(
//                   "حسابي",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           ),

//           // 🔥 أيقونة النوتيفيكيشن - تظهر بس لو اليوزر مسجل
//           if (user != null)
//             BlocBuilder<NotificationCubit, NotificationState>(
//               builder: (context, state) {
//                 bool hasUnread = false;

//                 if (state is NotificationLoaded) {
//                   hasUnread = state.notifications.any((n) => n.isRead == false);
//                 }

//                 return Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(2),
//                       width: 40,
//                       height: 40,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [Color(0xff4f2349), Color(0xffa76433)],
//                         ),
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Color(0XFF0f1217),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Center(
//                           child: IconButton(
//                             icon: const Icon(
//                               Icons.notifications_none,
//                               color: Colors.white,
//                               size: 20,
//                             ),
//                             onPressed: () {
//                               showNotificationsDialog(context, user!);
//                             },
//                           ),
//                         ),
//                       ),
//                     ),

//                     // النقطة الحمرا لو فيه إشعارات جديدة
//                     if (hasUnread)
//                       Positioned(
//                         right: 4,
//                         top: -1,
//                         child: Container(
//                           width: 10,
//                           height: 10,
//                           decoration: BoxDecoration(
//                             color: Colors.red,
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                       ),
//                   ],
//                 );
//               },
//             ),
//         ],
//       ),

//       body: Directionality(
//         textDirection: TextDirection.rtl,
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(
//             vertical: 20,
//             horizontal: isMobile ? 15 : width * 0.1,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ProfileHeader(user: widget.user),
//               SizedBox(height: isMobile ? 20 : 30),
//               LogoutButton(isMobile: isMobile),
//               SizedBox(height: isMobile ? 20 : 30),
               
//               CategoryTabs(
//                 isMobile: isMobile,
//                 selectedIndex: selectedIndex,
//                 onTabSelected: (index) {
//                   setState(() {
//                     selectedIndex = index;
//                   });
//                 },
//               ),
//               SizedBox(height: isMobile ? 20 : 30),

//               if (selectedIndex == 0) ...[
//                 BlocBuilder<ProfileCubit, ProfileState>(
//                   builder: (context, state) {
//                     return state.when(
//                       initial: () => const SizedBox(),
//                       loading: () =>
//                           const Center(child: CircularProgressIndicator()),
//                       success: (data) {
//                         final profile = data as StudentProfileResponse;

//                         if (profile.courses == null ||
//                             profile.courses!.isEmpty) {
//                           return EmptyState(
//                             message: "لا توجد دورات",
//                             isMobile: isMobile,
//                           );
//                         }

//                         return GridView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           gridDelegate:
//                               SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: isMobile ? 1 : 2,
//                                 crossAxisSpacing: 20,
//                                 mainAxisSpacing: 20,
//                                 childAspectRatio: isMobile ? 0.9 : 0.8,
//                               ),
//                           itemCount: profile.courses!.length,
//                           itemBuilder: (context, index) {
//                             final course = profile.courses![index];
//                             final imageUrl = buildImageUrl(
//                               course.featuredImage?.url,
//                             );
//                             return CourseCard(
//                               image: imageUrl,
//                               courseName: course.title ?? '',
//                               isMobile: isMobile,
//                               courseId: course.id ?? 0,
//                                user: widget.user,
                              
//                             );
//                           },
//                         );
//                       },
//                       error: (error) => EmptyState(
//                         message: "خطأ: $error",
//                         isMobile: isMobile,
//                       ),
//                     );
//                   },
//                 ),
//               ] else if (selectedIndex == 1) ...[
//                 RewardBox(isMobile: isMobile),
//               ] else if (selectedIndex == 2) ...[
//                 RankingWidget(isMobile: isMobile),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// String buildImageUrl(String? imagePath) {
//   if (imagePath == null || imagePath.isEmpty) return "";

//   if (imagePath.startsWith('http')) {
//     return imagePath;
//   }

//   return imagePath.startsWith('/')
//       ? Constants.baseUrl + imagePath
//       : Constants.baseUrl + '/' + imagePath;
// }



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/helpers/constants.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/Notification/logic/notification_cubit.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/features/profileScreen/data/models/student_profile_response.dart';
import 'package:prime_academy/features/profileScreen/logic/profile_cubit.dart';
import 'package:prime_academy/features/profileScreen/logic/profile_state.dart';
import 'package:prime_academy/presentation/Notification/notification_screen.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/category_tabs.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/course_card.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/empty_state.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/logout_button.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/profile_header.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/reward_box.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/my_rank.dart';

class HomePage extends StatefulWidget {
  final LoginResponse user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().emitprofileState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      backgroundColor: Mycolors.backgroundColor,
      appBar: AppBar(
  backgroundColor: Colors.black,
  elevation: 0,
  automaticallyImplyLeading: false, // علشان ميبقاش في سهم رجوع
  title: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // ✅ اللوجو على اليمين
      Image.asset("assets/images/footer-logo.webp", height: 40),

      // ✅ الزر والإشعار على الشمال
      Row(
        children: [
          // زر "حسابي"
          Container(
            padding: const EdgeInsets.all(2),
            width: 70,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xff4f2349), Color(0xffa76433)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: 50,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0XFF0f1217),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {
                  context.read<ProfileCubit>().emitprofileState();
                },
                child: const Text(
                  "حسابي",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // أيقونة النوتيفيكيشن
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
                    padding: const EdgeInsets.all(2),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xff4f2349), Color(0xffa76433)],
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0XFF0f1217),
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
                            showNotificationsDialog(context, widget.user);
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
                        decoration: const BoxDecoration(
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
    ],
  ),
),

      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: isMobile ? 15 : width * 0.1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeader(user: widget.user),
              SizedBox(height: isMobile ? 20 : 30),
              LogoutButton(isMobile: isMobile),
              SizedBox(height: isMobile ? 20 : 30),
              CategoryTabs(
                isMobile: isMobile,
                selectedIndex: selectedIndex,
                onTabSelected: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
              SizedBox(height: isMobile ? 20 : 30),

              // عرض المحتوى حسب التاب المختار
              if (selectedIndex == 0) ...[
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    return state.when(
                      initial: () => const SizedBox.shrink(),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      success: (data) {
                        final profile = data as StudentProfileResponse;

                        if (profile.courses == null ||
                            profile.courses!.isEmpty) {
                          return EmptyState(
                            message: "لا توجد دورات",
                            isMobile: isMobile,
                          );
                        }

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isMobile ? 1 : 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: isMobile ? 0.9 : 0.8,
                          ),
                          itemCount: profile.courses!.length,
                          itemBuilder: (context, index) {
                            final course = profile.courses![index];
                            final imageUrl = buildImageUrl(
                              course.featuredImage?.url,
                            );
                            return CourseCard(
                              image: imageUrl,
                              courseName: course.title ?? '',
                              isMobile: isMobile,
                              courseId: course.id ?? 0,
                              user: widget.user,
                            );
                          },
                        );
                      },
                      error: (error) => EmptyState(
                        message: "خطأ: $error",
                        isMobile: isMobile,
                      ),
                    );
                  },
                ),
              ] else if (selectedIndex == 1) ...[
                RewardBox(isMobile: isMobile),
              ] else if (selectedIndex == 2) ...[
                RankingWidget(isMobile: isMobile),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

String buildImageUrl(String? imagePath) {
  if (imagePath == null || imagePath.isEmpty) return "";

  if (imagePath.startsWith('http')) {
    return imagePath;
  }

  return imagePath.startsWith('/')
      ? Constants.baseUrl + imagePath
      : '${Constants.baseUrl}/$imagePath';
}