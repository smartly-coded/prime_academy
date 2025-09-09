// import 'package:flutter/material.dart';
// import 'package:prime_academy/core/routing/app_routes.dart';
// import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
// import 'package:prime_academy/presentation/widgets/homeWidgets/build_text.dart';
// import 'package:prime_academy/presentation/widgets/homeWidgets/three_tabs_widget.dart';

// class HomeScreen extends StatelessWidget {
//   final LoginResponse? user;
//   const HomeScreen({super.key, this.user});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0XFF0f1217),
//       appBar: AppBar(
//         backgroundColor: const Color(0XFF0f1217),
//         title: const Text("Home", style: TextStyle(color: Colors.white)),
//         actions: [
//           Container(
//             padding: EdgeInsets.all(2),
//             width: 100,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xff4f2349), Color(0xffa76433)],
//               ),
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: Container(
//               width: 80,

//               decoration: BoxDecoration(
//                 color: Color(0XFF0f1217),
//                 borderRadius: BorderRadius.circular(
//                   15,
//                 ),
//               ),
//               child: TextButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, AppRoutes.login);
//                 },
//                 child: const Text(
//                   "تسجيل الخروج",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           buildText("مرحبا", "${user!.firstname} ${user!.lastname}", context),
//           ThreeTabsWidget(),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/features/HomeScreen/data/Repos/course_repository.dart';
import 'package:prime_academy/features/HomeScreen/logic/home_cubit.dart';
import 'package:prime_academy/features/HomeScreen/logic/home_state.dart';

import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/category_tabs.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/course_card.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/empty_state.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/logout_button.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/profile_header.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/reward_box.dart'; 

class HomePage extends StatefulWidget {
  final LoginResponse user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return BlocProvider(
      create: (_) =>
          CourseCubit(CourseRepository("http://192.168.1.9:4005/api"))
            ..loadUserCourses(widget.user.id!),
      child: Scaffold(
        backgroundColor: const Color(0xFF0f1217),
        appBar:  AppBar(
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
                
                },
                child: const Text(
                  "حسابي",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
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

                
                if (selectedIndex == 0) ...[
               
                  BlocBuilder<CourseCubit, CourseState>(
                    builder: (context, state) {
                      if (state is CourseLoading) {
                        return const Center(
                            child: CircularProgressIndicator());
                      } else if (state is CourseLoaded) {
                        if (state.courses.isEmpty) {
                          return EmptyState(
                              message: "لا توجد دورات", isMobile: isMobile);
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
                          itemCount: state.courses.length,
                          itemBuilder: (context, index) {
                            final course = state.courses[index];
                            return CourseCard(
                              courseName: course.title,
                              isMobile: isMobile,
                            );
                          },
                        );
                      } else if (state is CourseError) {
                        return EmptyState(
                          message: "خطأ: ${state.message}",
                          isMobile: isMobile,
                        );
                      }
                      return const SizedBox();
                    },
                  )
                ] else if (selectedIndex == 1) ...[
                  
                  RewardBox(isMobile: isMobile, rewardsCount:2,),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
