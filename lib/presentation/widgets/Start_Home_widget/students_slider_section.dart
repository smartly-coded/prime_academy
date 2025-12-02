// // import 'dart:async';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:prime_academy/core/helpers/constants.dart';
// // import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
// // import 'package:prime_academy/core/routing/app_routes.dart';
// // import 'package:prime_academy/features/startScreen/logic/start_screen_cubit.dart';
// // import 'package:prime_academy/features/startScreen/logic/start_screen_state.dart';

// // class StudentsSliderSection extends StatefulWidget {
// //   const StudentsSliderSection({super.key});

// //   @override
// //   State<StudentsSliderSection> createState() => _StudentsSliderSectionState();
// // }

// // class _StudentsSliderSectionState extends State<StudentsSliderSection> {
// //   late PageController _pageController;
// //   Timer? _timer;
// //   int _currentIndex = 0;
// //   List<dynamic> _students = [];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _pageController = PageController(viewportFraction: 0.33);
// //     context.read<StartScreenCubit>().emitStartScreenState();
// //   }

// //   void _startTimer() {
// //     _timer?.cancel();
// //     if (_students.isEmpty) return;

// //     _timer = Timer.periodic(Duration(seconds: 3), (timer) {
// //       if (mounted && _pageController.hasClients) {
// //         // الانتقال للعنصر التالي
// //         _currentIndex = (_currentIndex + 1) % _students.length;

// //         _pageController.animateToPage(
// //           _currentIndex,
// //           duration: Duration(milliseconds: 500),
// //           curve: Curves.easeInOut,
// //         );
// //       }
// //     });
// //   }

// //   void _stopTimer() {
// //     _timer?.cancel();
// //   }

// //   // String _buildImageUrl(String? imagePath) {
// //   //   if (imagePath == null || imagePath.isEmpty) return "";

// //   //   if (imagePath.startsWith('http')) {
// //   //     return imagePath;
// //   //   }

// //   //   return imagePath.startsWith('/')
// //   //       ? Constants.baseUrl + imagePath
// //   //       : '${Constants.baseUrl}/$imagePath';
// //   // }
// // String _buildImageUrl(String? imagePath) {
// //   if (imagePath == null || imagePath.isEmpty) return "";
// //   if (imagePath.startsWith('http')) return imagePath;

// //   const String cdnPrefix = "https://cdn.primeacademy.education/primeacademy";
// //   return imagePath.startsWith('/')
// //       ? "$cdnPrefix$imagePath"
// //       : "$cdnPrefix/$imagePath";
// // }
// //   void _goToStudentDetail(dynamic student) {
// //     // إيقاف التايمر مؤقتاً
// //     _stopTimer();

// //     // الانتقال للصفحة
// //     Navigator.pushNamed(
// //       context,
// //       AppRoutes.studentDetail,
// //       arguments: student.id,
// //     ).then((_) {
// //       // إعادة تشغيل التايمر عند الرجوع
// //       _startTimer();
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _timer?.cancel();
// //     _pageController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final isMobile = MediaQuery.of(context).size.width < 600;

// //     return BlocBuilder<StartScreenCubit, StartScreenState>(
// //       builder: (context, state) {
// //         return state.when(
// //           initial: () => const SizedBox.shrink(),
// //           loading: () => const Center(
// //             child: CircularProgressIndicator(
// //               valueColor: AlwaysStoppedAnimation<Color>(Color(0xffa76433)),
// //             ),
// //           ),
// //           error: (error) => Center(
// //             child: Text(
// //               'خطأ في تحميل البيانات: $error',
// //               style: const TextStyle(color: Colors.red),
// //               textAlign: TextAlign.center,
// //             ),
// //           ),
// //           success: (studentsResponse) {
// //             _students = studentsResponse.data ?? [];

// //             // بدء التايمر فقط عند النجاح
// //             WidgetsBinding.instance.addPostFrameCallback((_) {
// //               if (_timer == null && _students.isNotEmpty) {
// //                 _startTimer();
// //               }
// //             });

// //             if (_students.isEmpty) {
// //               return Center(
// //                 child: Text(
// //                   'لا توجد بيانات طلاب',
// //                   style: TextStyle(color: Colors.white),
// //                 ),
// //               );
// //             }

// //             return Container(
// //               padding: const EdgeInsets.symmetric(vertical: 50),
// //               color: Mycolors.cardColor1,
// //               child: Column(
// //                 children: [
// //                   // العنوان
// //                   Container(
// //                     padding: const EdgeInsets.all(3),
// //                     margin: const EdgeInsets.only(bottom: 30),
// //                     decoration: BoxDecoration(
// //                       borderRadius: BorderRadius.circular(12),
// //                       gradient: const LinearGradient(
// //                         colors: [Color(0xffa76433), Color(0xff4f2349)],
// //                       ),
// //                     ),
// //                     child: Container(
// //                       padding: const EdgeInsets.symmetric(
// //                         horizontal: 16,
// //                         vertical: 10,
// //                       ),
// //                       decoration: BoxDecoration(
// //                         borderRadius: BorderRadius.circular(12),
// //                         color: Mycolors.darkblue,
// //                       ),
// //                       child: const Text(
// //                         "طلاب برايم أكاديمي",
// //                         style: TextStyle(
// //                           fontSize: 20,
// //                           fontWeight: FontWeight.bold,
// //                           fontFamily: 'Cairo',
// //                           color: Colors.white,
// //                         ),
// //                       ),
// //                     ),
// //                   ),

// //                   // الـ PageView
// //                   SizedBox(
// //                     height: isMobile ? 200 : 250,
// //                     child: PageView.builder(
// //                       controller: _pageController,
// //                       onPageChanged: (index) {
// //                         setState(() {
// //                           _currentIndex = index % _students.length;
// //                         });
// //                       },
// //                       itemCount: _students.length,
// //                       itemBuilder: (context, index) {
// //                         final student = _students[index];
// //                         final imageUrl = _buildImageUrl(student.image?.url);
// //                         final isSelected = index == _currentIndex;

// //                         return GestureDetector(
// //                           onTap: () => _goToStudentDetail(student),
// //                           child: Container(
// //                             margin: const EdgeInsets.symmetric(horizontal: 5),
// //                             child: Stack(
// //                               children: [
// //                                 // الصورة
// //                                 ClipRRect(
// //                                   borderRadius: BorderRadius.circular(12),
// //                                   child: Container(
// //                                     height: isMobile ? 180 : 220,
// //                                     width: isMobile ? 110 : 140,
// //                                     decoration: BoxDecoration(
// //                                       color: Colors.grey[800],
// //                                       borderRadius: BorderRadius.circular(12),
// //                                     ),
// //                                     child: imageUrl.isNotEmpty
// //                                         ? Image.network(
// //                                             imageUrl,
// //                                             fit: BoxFit.cover,
// //                                             errorBuilder:
// //                                                 (context, error, stackTrace) {
// //                                                   print(
// //                                                     "Failed to load: $imageUrl",
// //                                                   );
// //                                                   return _buildPlaceholder(
// //                                                     student.firstname ?? "طالب",
// //                                                   );
// //                                                 },
// //                                           )
// //                                         : _buildPlaceholder(
// //                                             student.firstname ?? "طالب",
// //                                           ),
// //                                   ),
// //                                 ),

// //                                 // التفاعل عند التوقف
// //                                 if (isSelected)
// //                                   Container(
// //                                     height: isMobile
// //                                         ? 180
// //                                         : 220, // نفس ارتفاع الصورة
// //                                     width: isMobile ? 110 : 140,
// //                                     decoration: BoxDecoration(
// //                                       borderRadius: BorderRadius.circular(12),
// //                                       color: Colors.black.withOpacity(0.6),
// //                                     ),
// //                                     child: Column(
// //                                       mainAxisAlignment:
// //                                           MainAxisAlignment.center,
// //                                       children: [
// //                                         Text(
// //                                           student.firstname ?? "طالب",
// //                                           style: TextStyle(
// //                                             fontSize: isMobile ? 14 : 16,
// //                                             fontWeight: FontWeight.bold,
// //                                             color: Colors.white,
// //                                           ),
// //                                           textAlign: TextAlign.center,
// //                                           maxLines: 2,
// //                                         ),
// //                                       ],
// //                                     ),
// //                                   ),
// //                               ],
// //                             ),
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             );
// //           },
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildPlaceholder(String name) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         gradient: LinearGradient(
// //           colors: [
// //             Color(0xff4f2349).withOpacity(0.7),
// //             Color(0xffa76433).withOpacity(0.7),
// //           ],
// //         ),
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Icon(Icons.person, color: Colors.white, size: 40),
// //           SizedBox(height: 8),
// //           Text(
// //             name,
// //             style: TextStyle(
// //               color: Colors.white,
// //               fontSize: 12,
// //               fontWeight: FontWeight.bold,
// //             ),
// //             textAlign: TextAlign.center,
// //             maxLines: 2,
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:prime_academy/core/helpers/constants.dart';
// import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
// import 'package:prime_academy/core/routing/app_routes.dart';
// import 'package:prime_academy/features/startScreen/data/models/student_response.dart';
// import 'package:prime_academy/features/startScreen/logic/start_screen_cubit.dart';
// import 'package:prime_academy/features/startScreen/logic/start_screen_state.dart';

// class StudentsSliderSection extends StatefulWidget {
//   const StudentsSliderSection({super.key});

//   @override
//   State<StudentsSliderSection> createState() => _StudentsSliderSectionState();
// }

// class _StudentsSliderSectionState extends State<StudentsSliderSection> {
//   late PageController _pageController;
//   Timer? _timer;
//   int _currentIndex = 0;
//   List<Student> _students = [];

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//     context.read<StartScreenCubit>().emitStartScreenState();
//   }

//   void _startTimer() {
//     _timer?.cancel();
//     if (_students.isEmpty) return;

//     _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
//       if (mounted && _pageController.hasClients) {
//         _currentIndex = (_currentIndex + 1) % _students.length;
//         _pageController.animateToPage(
//           _currentIndex,
//           duration: const Duration(seconds: 3),
//           curve: Curves.easeInOut,
//         );
//       }
//     });
//   }

//   void _stopTimer() {
//     _timer?.cancel();
//   }

//   String _buildImageUrl(String? imagePath) {
//     if (imagePath == null || imagePath.isEmpty) return "";
//     if (imagePath.startsWith('http')) return imagePath;

//     const String cdnPrefix = "https://cdn.primeacademy.education/primeacademy";
//     return imagePath.startsWith('/')
//         ? "$cdnPrefix$imagePath"
//         : "$cdnPrefix/$imagePath";
//   }

//   void _goToStudentDetail(dynamic student) {
//     _stopTimer();
//     Navigator.pushNamed(
//       context,
//       AppRoutes.studentDetail,
//       arguments: student.id,
//     ).then((_) {
//       _startTimer();
//     });
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     int itemsPerPage;
//     if (screenWidth < 600) {
//       itemsPerPage = 1;
//     } else if (screenWidth < 900) {
//       itemsPerPage = 2;
//     } else if (screenWidth < 1200) {
//       itemsPerPage = 3;
//     } else {
//       itemsPerPage = 4;
//     }

//     double pageHeight = screenHeight * 0.6;

//     // تحديث viewportFraction حسب عدد العناصر المرئية
//     _pageController = PageController(viewportFraction: 1 / itemsPerPage);

//     return BlocBuilder<StartScreenCubit, StartScreenState>(
//       builder: (context, state) {
//         return state.when(
//           initial: () => const SizedBox.shrink(),
//           loading: () => const Center(
//             child: CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(Color(0xffa76433)),
//             ),
//           ),
//           error: (error) => Center(
//             child: Text(
//               'خطأ في تحميل البيانات: $error',
//               style: const TextStyle(color: Colors.red),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           success: (studentsResponse) {
//             _students = studentsResponse.data ?? [];

//             // فلترة الطلاب الأوائل
//             _students.sort((a, b) => b.points.compareTo(a.points));

//             // خدي أول 10 فقط
//             _students = _students.take(10).toList();

//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               if (_timer == null && _students.isNotEmpty) {
//                 _startTimer();
//               }
//             });

//             if (_students.isEmpty) {
//               return Center(
//                 child: Text(
//                   'لا توجد بيانات طلاب',
//                   style: const TextStyle(color: Colors.white),
//                 ),
//               );
//             }
//             final studentsList = studentsResponse.data ?? [];
//             return Container(
//               padding: const EdgeInsets.symmetric(vertical: 50),
//               color: Mycolors.cardColor1,
//               child: Column(
//                 children: [
//                   // Container(
//                   //   padding: const EdgeInsets.all(3),
//                   //   margin: const EdgeInsets.only(bottom: 30),
//                   //   decoration: BoxDecoration(
//                   //     borderRadius: BorderRadius.circular(12),
//                   //     gradient: const LinearGradient(
//                   //       colors: [Color(0xffa76433), Color(0xff4f2349)],
//                   //     ),
//                   //   ),
//                   //   child: Container(
//                   //     padding: const EdgeInsets.symmetric(
//                   //       horizontal: 16,
//                   //       vertical: 10,
//                   //     ),
//                   //     decoration: BoxDecoration(
//                   //       borderRadius: BorderRadius.circular(12),
//                   //       color: Mycolors.darkblue,
//                   //     ),
//                   //     child: const Text(
//                   //       "طلاب برايم أكاديمي",
//                   //       style: TextStyle(
//                   //         fontSize: 20,
//                   //         // fontWeight: FontWeight.bold,
//                   //         color: Colors.white,
//                   //       ),
//                   //     ),
//                   //   ),
//                   // ),
//                   // GestureDetector(
//                   //   onTap: () {
//                   //     Navigator.pushNamed(
//                   //       context,
//                   //       AppRoutes.allStudentsPage,
//                   //       arguments: _students,
//                   //     );
//                   //   },
//                   GestureDetector(
//                     onTap: () {
//                       final studentsList = _students
//                           .map((e) => e as Student)
//                           .toList();
//                       if (studentsList.isNotEmpty) {
//                         Navigator.pushNamed(
//                           context,
//                           AppRoutes.allStudentsPage,
//                           arguments: studentsList,
//                         );
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text("الطلاب لم يتم تحميلهم بعد!"),
//                           ),
//                         );
//                       }
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(3),
//                       margin: const EdgeInsets.only(bottom: 30),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         gradient: const LinearGradient(
//                           colors: [Color(0xffa76433), Color(0xff4f2349)],
//                         ),
//                       ),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 10,
//                         ),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           color: Mycolors.darkblue,
//                         ),
//                         child: const Text(
//                           "طلاب برايم أكاديمي",
//                           style: TextStyle(fontSize: 20, color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ),

//                   SizedBox(
//                     height: pageHeight,
//                     child: PageView.builder(
//                       controller: _pageController,
//                       onPageChanged: (index) {
//                         setState(() {
//                           _currentIndex = index % _students.length;
//                         });
//                       },
//                       itemCount: _students.length,
//                       itemBuilder: (context, index) {
//                         final student = _students[index];
//                         final imageUrl = _buildImageUrl(student.image?.url);

//                         return GestureDetector(
//                           onTap: () => _goToStudentDetail(student),
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(horizontal: 16),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(12),
//                               child: imageUrl.isNotEmpty
//                                   ? Image.network(
//                                       imageUrl,
//                                       fit: BoxFit.cover,
//                                       height: pageHeight,
//                                       errorBuilder:
//                                           (context, error, stackTrace) =>
//                                               _buildPlaceholder(
//                                                 student.firstname ?? "طالب",
//                                               ),
//                                     )
//                                   : _buildPlaceholder(
//                                       student.firstname ?? "طالب",
//                                     ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildPlaceholder(String name) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             const Color(0xff4f2349).withOpacity(0.7),
//             const Color(0xffa76433).withOpacity(0.7),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.person, color: Colors.white, size: 40),
//           const SizedBox(height: 8),
//           Text(
//             name,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 12,
//               // fontWeight: FontWeight.bold,
//             ),
//             textAlign: TextAlign.center,
//             maxLines: 2,
//           ),
//         ],
//       ),
//     );
//   }
// // }
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
// import 'package:prime_academy/core/routing/app_routes.dart';
// import 'package:prime_academy/features/startScreen/data/models/student_response.dart';
// import 'package:prime_academy/features/startScreen/logic/start_screen_cubit.dart';
// import 'package:prime_academy/features/startScreen/logic/start_screen_state.dart';

// class StudentsSliderSection extends StatefulWidget {
//   const StudentsSliderSection({super.key});

//   @override
//   State<StudentsSliderSection> createState() => _StudentsSliderSectionState();
// }

// class _StudentsSliderSectionState extends State<StudentsSliderSection> {
//   late PageController _pageController;
//   Timer? _timer;
//   int _currentIndex = 0;
//   List<Student> _students = [];

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//     context.read<StartScreenCubit>().emitStartScreenState();
//   }

//   void _startTimer() {
//     _timer?.cancel();
//     if (_students.isEmpty) return;

//     _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
//       if (mounted && _pageController.hasClients) {
//         _currentIndex = (_currentIndex + 1) % _students.length;
//         _pageController.animateToPage(
//           _currentIndex,
//           duration: const Duration(milliseconds: 500),
//           curve: Curves.easeInOut,
//         );
//       }
//     });
//   }

//   void _stopTimer() {
//     _timer?.cancel();
//   }

//   String _buildImageUrl(String? imagePath) {
//     if (imagePath == null || imagePath.isEmpty) return "";
//     if (imagePath.startsWith('http')) return imagePath;

//     const String cdnPrefix = "https://cdn.primeacademy.education/primeacademy";
//     return imagePath.startsWith('/')
//         ? "$cdnPrefix$imagePath"
//         : "$cdnPrefix/$imagePath";
//   }

//   void _goToStudentDetail(Student student) {
//     _stopTimer();
//     Navigator.pushNamed(
//       context,
//       AppRoutes.studentDetail,
//       arguments: student.id,
//     ).then((_) => _startTimer());
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     int itemsPerPage;
//     if (screenWidth < 600) {
//       itemsPerPage = 1;
//     } else if (screenWidth < 900) {
//       itemsPerPage = 2;
//     } else if (screenWidth < 1200) {
//       itemsPerPage = 3;
//     } else {
//       itemsPerPage = 4;
//     }

//     double pageHeight = screenHeight * 0.6;
//     _pageController = PageController(viewportFraction: 1 / itemsPerPage);

//     return BlocBuilder<StartScreenCubit, StartScreenState>(
//       builder: (context, state) {
//         return state.when(
//           initial: () => const SizedBox.shrink(),
//           loading: () => const Center(
//             child: CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(Color(0xffa76433)),
//             ),
//           ),
//           error: (error) => Center(
//             child: Text(
//               'خطأ في تحميل البيانات: $error',
//               style: const TextStyle(color: Colors.red),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           success: (studentsResponse) {
//             // فلترة الـ data لضمان انها List<Student>
//             _students = (studentsResponse.data ?? [])
//                 .whereType<Student>()
//                 .toList();

//             _students.sort((a, b) => b.points.compareTo(a.points));
//             _students = _students.take(10).toList();

//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               if (_timer == null && _students.isNotEmpty) {
//                 _startTimer();
//               }
//             });

//             if (_students.isEmpty) {
//               return const Center(
//                 child: Text(
//                   'لا توجد بيانات طلاب',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               );
//             }

//             return Container(
//               padding: const EdgeInsets.symmetric(vertical: 50),
//               color: Mycolors.cardColor1,
//               child: Column(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       if (_students.isNotEmpty) {
//                         Navigator.pushNamed(
//                           context,
//                           AppRoutes.allStudentsPage,
//                           arguments: _students,
//                         );
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text("الطلاب لم يتم تحميلهم بعد!"),
//                           ),
//                         );
//                       }
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(3),
//                       margin: const EdgeInsets.only(bottom: 30),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         gradient: const LinearGradient(
//                           colors: [Color(0xffa76433), Color(0xff4f2349)],
//                         ),
//                       ),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 10,
//                         ),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           color: Mycolors.darkblue,
//                         ),
//                         child: const Text(
//                           "طلاب برايم أكاديمي",
//                           style: TextStyle(fontSize: 20, color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: pageHeight,
//                     child: PageView.builder(
//                       controller: _pageController,
//                       onPageChanged: (index) {
//                         setState(() {
//                           _currentIndex = index % _students.length;
//                         });
//                       },
//                       itemCount: _students.length,
//                       itemBuilder: (context, index) {
//                         final student = _students[index];
//                         final imageUrl = _buildImageUrl(student.image?.url);

//                         return GestureDetector(
//                           onTap: () => _goToStudentDetail(student),
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(horizontal: 16),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(12),
//                               child: imageUrl.isNotEmpty
//                                   ? Image.network(
//                                       imageUrl,
//                                       fit: BoxFit.cover,
//                                       height: pageHeight,
//                                       errorBuilder:
//                                           (context, error, stackTrace) =>
//                                               _buildPlaceholder(
//                                         student.firstname ?? "طالب",
//                                       ),
//                                     )
//                                   : _buildPlaceholder(
//                                       student.firstname ?? "طالب",
//                                     ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildPlaceholder(String name) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             const Color(0xff4f2349).withOpacity(0.7),
//             const Color(0xffa76433).withOpacity(0.7),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.person, color: Colors.white, size: 40),
//           const SizedBox(height: 8),
//           Text(
//             name,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 12,
//             ),
//             textAlign: TextAlign.center,
//             maxLines: 2,
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/core/routing/app_routes.dart';
import 'package:prime_academy/features/startScreen/data/models/student_response.dart';
import 'package:prime_academy/features/startScreen/logic/start_screen_cubit.dart';
import 'package:prime_academy/features/startScreen/logic/start_screen_state.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/all_students_page.dart';

class StudentsSliderSection extends StatefulWidget {
  const StudentsSliderSection({super.key});

  @override
  State<StudentsSliderSection> createState() => _StudentsSliderSectionState();
}

class _StudentsSliderSectionState extends State<StudentsSliderSection> {
  late PageController _pageController;
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    final cubit = context.read<StartScreenCubit>();
    cubit.emitSliderStudentsState(); // جلب آخر 8 طلاب
  }

  void _startTimer(List<Student> sliderStudents) {
    _timer?.cancel();
    if (sliderStudents.isEmpty) return;

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted && _pageController.hasClients) {
        _currentIndex = (_currentIndex + 1) % sliderStudents.length;
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopTimer() => _timer?.cancel();

  String _buildImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return "";
    if (imagePath.startsWith('http')) return imagePath;

    const String cdnPrefix = "https://cdn.primeacademy.education/primeacademy";
    return imagePath.startsWith('/')
        ? "$cdnPrefix$imagePath"
        : "$cdnPrefix/$imagePath";
  }

  void _goToStudentDetail(Student student) {
    _stopTimer();
    Navigator.pushNamed(
      context,
      AppRoutes.studentDetail,
      arguments: student.id,
    ).then((_) => _startTimer(context.read<StartScreenCubit>().sliderStudents));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  /// -------------------------------
  /// واجهة السلايدر كاملة
  /// -------------------------------
  Widget buildSliderUI(List<Student> sliderStudents) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50),
      color: Mycolors.cardColor1,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              final cubit = context.read<StartScreenCubit>();
              if (cubit.allStudents.isEmpty) {
                cubit.loadStudentsGradually();
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: cubit,
                    child: AllStudentsPage(),
                  ),
                ),
              );
            },
            child: buildStudentsButton(),
          ),

          const SizedBox(height: 20),

          /// السلايدر
          SizedBox(
            height: screenHeight * 0.6,
            child: PageView.builder(
              controller: _pageController,
              itemCount: sliderStudents.length,
              itemBuilder: (_, i) {
                final student = sliderStudents[i];
                final imageUrl = _buildImageUrl(student.image?.url);
                return buildSliderItem(student, imageUrl, screenHeight);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// TODO: هضعي هنا ال Widget الحقيقي
  Widget buildStudentsButton() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0xffa76433), Color(0xff4f2349)],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Mycolors.darkblue,
        ),
        child: const Text(
          "طلاب برايم أكاديمي",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  /// TODO: هنا كارت الطالب في السلايدر
  Widget buildSliderItem(Student student, String imageUrl, double height) {
    return GestureDetector(
      onTap: () => _goToStudentDetail(student),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  height: height,
                  errorBuilder: (_, __, ___) =>
                      _buildPlaceholder(student.firstname),
                )
              : _buildPlaceholder(student.firstname),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StartScreenCubit>();

    return BlocBuilder<StartScreenCubit, StartScreenState>(
      builder: (context, state) {
        final sliderStudents = cubit.sliderStudents;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_timer == null && sliderStudents.isNotEmpty) {
            _startTimer(sliderStudents);
          }
        });

        return state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color(0xffa76433)),
            ),
          ),
          error: (error) => Center(
            child: Text(
              'خطأ في تحميل البيانات: $error',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),

          success: (_) => buildSliderUI(sliderStudents),

          studentsBatchLoaded: (_) => buildSliderUI(sliderStudents),
        );
      },
    );
  }

  Widget _buildPlaceholder(String name) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xff4f2349).withOpacity(0.7),
            const Color(0xffa76433).withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, color: Colors.white, size: 40),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
