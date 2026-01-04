// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
// import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
// import 'package:prime_academy/features/profileScreen/data/models/student_profile_response.dart';
// import 'package:prime_academy/features/profileScreen/logic/profile_cubit.dart';
// import 'package:prime_academy/features/profileScreen/logic/profile_state.dart';
// import 'package:prime_academy/layout/app_layout.dart';
// import 'package:prime_academy/layout/custom_app_bar.dart';
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
//     super.initState();
//     context.read<ProfileCubit>().emitprofileState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final isMobile = width < 600;

//     return Scaffold(
//       backgroundColor: Mycolors.backgroundColor,
//       appBar: CustomAppBar(
//         user: widget.user,
//         onLogoPressed: () => Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => AppLayout(user: widget.user)),
//           (route) => false,
//         ),
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
//               SizedBox(height: isMobile ? 40 : 60),
//               LogoutButton(isMobile: isMobile),
//               SizedBox(height: isMobile ? 50 : 80),
//               CategoryTabs(
//                 isMobile: isMobile,
//                 selectedIndex: selectedIndex,
//                 onTabSelected: (index) {
//                   setState(() {
//                     selectedIndex = index;
//                   });
//                 },
//               ),
//               SizedBox(height: isMobile ? 100 : 120),

//               if (selectedIndex == 0) ...[
//                 BlocBuilder<ProfileCubit, ProfileState>(
//                   builder: (context, state) {
//                     return state.when(
//                       initial: () => const SizedBox.shrink(),
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
//                                 // childAspectRatio: isMobile ? 0.9 : 0.8,
//                                 childAspectRatio: isMobile ? 1.1 : .8,
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
//                               user: widget.user,
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
//   if (imagePath.startsWith('http')) return imagePath;

//   const String cdnPrefix = "https://cdn.primeacademy.education/primeacademy";
//   final fixedPath = imagePath.startsWith('/') ? imagePath : '/$imagePath';
//   return "$cdnPrefix$fixedPath";
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/features/profileScreen/data/models/student_profile_response.dart';
import 'package:prime_academy/features/profileScreen/logic/profile_cubit.dart';
import 'package:prime_academy/features/profileScreen/logic/profile_state.dart';
import 'package:prime_academy/layout/app_layout.dart';
import 'package:prime_academy/layout/custom_app_bar.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/category_tabs.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/course_card.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/empty_state.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/logout_button.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/profile_header.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/reward_box.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/my_rank.dart';

class HomePage extends StatefulWidget {
  final LoginResponse user;
  final int initialTab; 
  
  const HomePage({
    super.key, 
    required this.user,
    this.initialTab = 0, 
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialTab; 
    context.read<ProfileCubit>().emitprofileState();
    
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      backgroundColor: Mycolors.backgroundColor,
      appBar: CustomAppBar(
        user: widget.user,
        onLogoPressed: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AppLayout(user: widget.user)),
          (route) => false,
        ), showBackArrow: true,
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
              SizedBox(height: isMobile ? 40 : 60),
              LogoutButton(isMobile: isMobile),
              SizedBox(height: isMobile ? 50 : 80),
              CategoryTabs(
                isMobile: isMobile,
                selectedIndex: selectedIndex,
                onTabSelected: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
              SizedBox(height: isMobile ? 100 : 120),

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
                                childAspectRatio: isMobile ? 1.1 : .8,
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
  if (imagePath.startsWith('http')) return imagePath;

  const String cdnPrefix = "https://cdn.primeacademy.education/primeacademy";
  final fixedPath = imagePath.startsWith('/') ? imagePath : '/$imagePath';
  return "$cdnPrefix$fixedPath";
}