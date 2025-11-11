// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:prime_academy/core/helpers/constants.dart';
// import 'package:prime_academy/features/profileScreen/data/models/student_profile_response.dart';
// import 'package:prime_academy/features/profileScreen/logic/profile_cubit.dart';
// import 'package:prime_academy/features/profileScreen/logic/profile_state.dart';
// import 'package:prime_academy/presentation/widgets/homeWidgets/empty_state.dart';
// import 'package:prime_academy/core/helpers/themeing/app_colors.dart';

// class RewardBox extends StatelessWidget {
//   final bool isMobile;

//   const RewardBox({super.key, required this.isMobile});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         padding: const EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           color: Mycolors.cardColor1,
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: BlocBuilder<ProfileCubit, ProfileState>(
//           builder: (context, state) {
//             return state.when(
//               initial: () => const SizedBox(),
//               loading: () => const Center(child: CircularProgressIndicator()),
//               error: (error) =>
//                   EmptyState(message: "خطأ: $error", isMobile: isMobile),
//               success: (data) {
//                 final profile = data as StudentProfileResponse;
//                 final trophies = profile.trophies ?? [];

//                 if (trophies.isEmpty) {
//                   return EmptyState(
//                     message: "لا توجد جوائز",
//                     isMobile: isMobile,
//                   );
//                 }

//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Center(
//                       child: Container(
//                         padding: const EdgeInsets.all(4),
//                         decoration: BoxDecoration(
//                           color: Mycolors.grey,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Container(
//                           height: isMobile ? 100 : 150,
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 24,
//                             vertical: 12,
//                           ),
//                           decoration: BoxDecoration(
//                             gradient: const LinearGradient(
//                               colors: [Color(0xff3D57E9), Color(0xffff9933)],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.3),
//                                 spreadRadius: 1,
//                                 blurRadius: 8,
//                                 offset: const Offset(0, 3),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Icon(
//                                 Icons.emoji_events,
//                                 color: Colors.amber,
//                                 size: 30,
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 "عدد الجوائز : ${trophies.length}",
//                                 style: TextStyle(
//                                   fontSize: isMobile ? 20 : 24,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                   fontFamily: 'Cairo',
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),

//                     GridView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: isMobile ? 2 : 3,
//                         crossAxisSpacing: 12,
//                         mainAxisSpacing: 12,
//                         childAspectRatio: 0.85,
//                       ),
//                       itemCount: trophies.length,
//                       itemBuilder: (context, index) {
//                         final trophy = trophies[index];
//                         final imageUrl = _buildImageUrl(trophy.image?.url);

//                         return Container(
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF3a3d44),
//                             borderRadius: BorderRadius.circular(15),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.2),
//                                 spreadRadius: 1,
//                                 blurRadius: 5,
//                                 offset: const Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               children: [
//                                 Expanded(
//                                   flex: 3,
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(12),
//                                     child: Container(
//                                       width: double.infinity,
//                                       decoration: BoxDecoration(
//                                         color: Colors.grey[800],
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                       child: imageUrl.isNotEmpty
//                                           ? Image.network(
//                                               imageUrl,
//                                               fit: BoxFit.cover,
//                                               errorBuilder:
//                                                   (
//                                                     context,
//                                                     error,
//                                                     stackTrace,
//                                                   ) => const Icon(
//                                                     Icons.broken_image,
//                                                     color: Colors.red,
//                                                     size: 30,
//                                                   ),
//                                             )
//                                           : const Icon(
//                                               Icons.image_not_supported,
//                                               color: Colors.white54,
//                                               size: 30,
//                                             ),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Expanded(
//                                   flex: 1,
//                                   child: Center(
//                                     child: Text(
//                                       trophy.name ?? "بدون اسم",
//                                       textAlign: TextAlign.center,
//                                       maxLines: 2,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                         fontSize: isMobile ? 12 : 14,
//                                         color: Colors.white,
//                                         fontFamily: 'Cairo',
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
// String _buildImageUrl(String? imagePath) {
//   if (imagePath == null || imagePath.isEmpty) return "";

//   if (imagePath.startsWith('http')) return imagePath;

//   // إذا الصور مخزّنة على CDN فرعي
//   const String cdnPrefix = "https://cdn.primeacademy.education/primeacademy";

//   return imagePath.startsWith('/')
//       ? "$cdnPrefix$imagePath"
//       : "$cdnPrefix/$imagePath";
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/helpers/constants.dart';
import 'package:prime_academy/features/profileScreen/data/models/student_profile_response.dart';
import 'package:prime_academy/features/profileScreen/logic/profile_cubit.dart';
import 'package:prime_academy/features/profileScreen/logic/profile_state.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/empty_state.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';

class RewardBox extends StatefulWidget {
  final bool isMobile;

  const RewardBox({super.key, required this.isMobile});

  @override
  State<RewardBox> createState() => _RewardBoxState();
}

class _RewardBoxState extends State<RewardBox> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.7);
  }

  void _startAutoScroll(int itemCount) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_pageController.hasClients) {
        _currentPage++;
        if (_currentPage >= itemCount) _currentPage = 0;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Mycolors.cardColor1,
          borderRadius: BorderRadius.circular(20),
        ),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox(),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error) =>
                  EmptyState(message: "خطأ: $error", isMobile: widget.isMobile),
              success: (data) {
                final profile = data as StudentProfileResponse;
                final trophies = profile.trophies ?? [];

                if (trophies.isEmpty) {
                  return EmptyState(
                    message: "لا توجد جوائز",
                    isMobile: widget.isMobile,
                  );
                }

                // Start auto scroll
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _startAutoScroll(trophies.length);
                });

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // الجزء العلوي: عدد الجوائز
                    Container(
                      height: widget.isMobile ? 120 : 150,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xff3D57E9), Color(0xffff9933)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.emoji_events,
                            color: Colors.amber,
                            size: 30,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "عدد الجوائز : ${trophies.length}",
                            style: TextStyle(
                              fontSize: widget.isMobile ? 20 : 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // الجزء السفلي: slider الجوائز
                    SizedBox(
                      height: widget.isMobile ? 180 : 200,
                      child: PageView.builder(
                        controller: _pageController,
                        scrollDirection: Axis.horizontal,
                        itemCount: trophies.length,
                        itemBuilder: (context, index) {
                          final trophy = trophies[index];
                          final imageUrl = _buildImageUrl(trophy.image?.url);

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: imageUrl.isNotEmpty
                                        ? Image.network(
                                            imageUrl,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            errorBuilder: (_, __, ___) =>
                                                const Icon(
                                                  Icons.broken_image,
                                                  size: 50,
                                                  color: Colors.red,
                                                ),
                                          )
                                        : const Icon(
                                            Icons.image_not_supported,
                                            size: 50,
                                            color: Colors.white54,
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    trophy.name ?? "بدون اسم",
                                    style: TextStyle(
                                      color: Mycolors.gold,
                                      fontFamily: 'Cairo',
                                      fontWeight: FontWeight.bold,
                                      fontSize: widget.isMobile ? 14 : 16,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _buildImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return "";

    if (imagePath.startsWith('http')) return imagePath;

    const String cdnPrefix = "https://cdn.primeacademy.education/primeacademy";
    return imagePath.startsWith('/')
        ? "$cdnPrefix$imagePath"
        : "$cdnPrefix/$imagePath";
  }
}
