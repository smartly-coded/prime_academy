// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
// import 'package:prime_academy/features/CoursesModules/data/repo/modules_repository.dart';
// import 'package:prime_academy/features/CoursesModules/logic/modules_cubit.dart';
// import 'package:prime_academy/features/Notification/logic/notification_cubit.dart';
// import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
// import 'package:prime_academy/features/profileScreen/logic/profile_cubit.dart';
// import 'package:prime_academy/layout/app_layout.dart';
// import 'package:prime_academy/layout/custom_app_bar.dart';
// import 'package:prime_academy/presentation/Notification/notification_screen.dart';
// import 'package:prime_academy/presentation/widgets/modulesWidgets/module_tile.dart';

// class ModulesPage extends StatelessWidget {
//   final int courseId;
//   final String courseName;
//   final LoginResponse user;

//   const ModulesPage({
//     super.key,
//     required this.courseId,
//     required this.courseName,
//     required this.user,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) =>
//           ModulesCubit(ModulesRepository())..loadModules(courseId),
//       child: Scaffold(
//         backgroundColor: Mycolors.backgroundColor,
//         appBar: CustomAppBar(
//           user: user,
//           onLogoPressed: () => Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (context) => AppLayout(user: user)),
//             (route) => false,
//           ),
//         ),
//         body: BlocBuilder<ModulesCubit, ModulesState>(
//           builder: (context, state) {
//             if (state is ModulesLoading) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (state is ModulesLoaded) {
//               final course = state.course;
//               return SingleChildScrollView(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 50),
//                     Container(
//                       padding: const EdgeInsets.all(10),
//                       width: double.infinity,
//                       height: 60,
//                       decoration: BoxDecoration(
//                         gradient: Mycolors.module_card,
//                         // borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Center(
//                         child: Text(
//                           courseName,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             // fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 50),

//                     Container(
//                       padding: const EdgeInsets.only(top: 90),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF12161f),
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                       child: Column(
//                         children: course.modules
//                             .asMap()
//                             .entries
//                             .map(
//                               (entry) => Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 8.0,
//                                 ),
//                                 child: ModuleTile(
//                                   module: entry.value,
//                                   courseId: courseId,
//                                   user: user,
//                                   index: entry.key,
//                                 ),
//                               ),
//                             )
//                             .toList(),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             } else if (state is ModulesError) {
//               return Center(child: Text("Error: ${state.message}"));
//             } else {
//               return const SizedBox();
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/CoursesModules/data/repo/modules_repository.dart';
import 'package:prime_academy/features/CoursesModules/logic/modules_cubit.dart';
import 'package:prime_academy/features/Notification/logic/notification_cubit.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/features/profileScreen/logic/profile_cubit.dart';
import 'package:prime_academy/layout/app_layout.dart';
import 'package:prime_academy/layout/custom_app_bar.dart';
import 'package:prime_academy/presentation/Notification/notification_screen.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/module_tile.dart';

class ModulesPage extends StatelessWidget {
  final int courseId;
  final String courseName;
  final LoginResponse user;

  const ModulesPage({
    super.key,
    required this.courseId,
    required this.courseName,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ModulesCubit(ModulesRepository())..loadModules(courseId),
      child: Scaffold(
        backgroundColor: Mycolors.backgroundColor,
        appBar: CustomAppBar(
          user: user,
          onLogoPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => AppLayout(user: user)),
            (route) => false,
          ),
          showBackArrow: true,
        ),
        body: BlocBuilder<ModulesCubit, ModulesState>(
          builder: (context, state) {
            if (state is ModulesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ModulesLoaded) {
              final course = state.course;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(gradient: Mycolors.module_card),
                      child: Center(
                        child: Text(
                          courseName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),

                    // ✅ Container يشمل كل الـ modules
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(
                        maxWidth: 1100,
                        minHeight: 413,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFF12161f),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(64),
                          topRight: Radius.circular(64),
                          bottomLeft: Radius.zero,
                          bottomRight: Radius.zero,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 80,
                        horizontal: 24,
                      ),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 896),
                        child: Column(
                          children: course.modules
                              .asMap()
                              .entries
                              .map(
                                (entry) => Padding(
                                  padding: EdgeInsets.only(
                                    bottom:
                                        entry.key < course.modules.length - 1
                                        ? 16
                                        : 0,
                                  ),
                                  child: ModuleTile(
                                    module: entry.value,
                                    courseId: courseId,
                                    user: user,
                                    index: entry.key,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ModulesError) {
              return Center(child: Text("Error: ${state.message}"));
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
