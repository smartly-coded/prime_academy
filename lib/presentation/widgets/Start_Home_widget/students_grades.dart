import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/startScreen/data/models/certificate_response.dart';
import 'package:prime_academy/features/startScreen/logic/certificate_cubit.dart';
import 'package:prime_academy/features/startScreen/logic/start_screen_state.dart';
import 'package:prime_academy/presentation/widgets/splashWidgets/build_text_withoutImage.dart';

class StudentsGreadesSection extends StatefulWidget {
  const StudentsGreadesSection({super.key});

  @override
  State<StudentsGreadesSection> createState() => _StudentsGreadesSectionState();
}

class _StudentsGreadesSectionState extends State<StudentsGreadesSection> {
  late PageController _pageController;
  Timer? _timer;
  int _currentIndex = 0;
  List<CertificateResponse> _certificates = []; // ✅ Changed from List<dynamic>

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    context.read<CertificateCubit>().emitCertificateState();
  }

  void _startTimer() {
    _timer?.cancel();
    if (_certificates.isEmpty) return;

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted && _pageController.hasClients) {
        _currentIndex = (_currentIndex + 1) % _certificates.length;
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(seconds: 3),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  String _buildImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return "";
    if (imagePath.startsWith('http')) return imagePath;

    const String cdnPrefix = "https://cdn.primeacademy.education/primeacademy";
    return imagePath.startsWith('/')
        ? "$cdnPrefix$imagePath"
        : "$cdnPrefix/$imagePath";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    ValueNotifier<bool> gradientFlipped2 = ValueNotifier(false);

    int itemsPerPage;
    if (screenWidth < 600) {
      itemsPerPage = 1;
    } else if (screenWidth < 900) {
      itemsPerPage = 2;
    } else if (screenWidth < 1200) {
      itemsPerPage = 3;
    } else {
      itemsPerPage = 4;
    }

    double pageHeight;
    if (screenHeight < 600) {
      pageHeight = screenHeight * 0.9;
    } else if (screenHeight < 800) {
      pageHeight = screenHeight * 0.7;
    } else if (screenHeight < 1000) {
      pageHeight = screenHeight * 0.6;
    } else {
      pageHeight = screenHeight * 0.5;
    }

    _pageController = PageController(viewportFraction: 1 / itemsPerPage);

    return BlocBuilder<CertificateCubit, StartScreenState>(
      builder: (context, state) {
        return state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xffa76433)),
            ),
          ),
          error: (error) => Center(
            child: Text(
              'خطأ في تحميل الشهادات: $error',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
          studentsBatchLoaded: (students) {
            return SizedBox.shrink();
          },
          success: (response) {
            try {
              // ✅ Fixed: Properly cast to List<CertificateResponse>
              _certificates = (response ?? []).cast<CertificateResponse>();
            } catch (e) {
              print("Error parsing certificates: $e");
              return Center(
                child: Text(
                  'خطأ في تحليل بيانات الشهادات',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_timer == null && _certificates.isNotEmpty) {
                _startTimer();
              }
            });

            if (_certificates.isEmpty) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 50),
                color: Mycolors.cardColor1,
                child: const Center(
                  child: Column(
                    children: [
                      Icon(Icons.school, size: 60, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'لا توجد شهادات متاحة',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 50),
              color: const Color(0xFF1a1d24),
              child: Column(
                children: [
                  // العنوان
                  ValueListenableBuilder<bool>(
                    valueListenable: gradientFlipped2,
                    builder: (context, isFlipped, _) {
                      return GestureDetector(
                        onTap: () {
                          gradientFlipped2.value = !gradientFlipped2.value;
                        },
                        child: buildTextWithBorder(
                     mainTitle:      "شهادات طلابنا ",
                      subTitle:     "",
                          
                          containerWidth: 200,
                        ),
                        // child: Container(
                        //   padding: const EdgeInsets.all(3),
                        //   margin: const EdgeInsets.only(bottom: 30),
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(12),
                        //     gradient: LinearGradient(
                        //       colors: Mycolors.primary_color.colors,
                        //       begin: isFlipped
                        //           ? Alignment.topLeft
                        //           : Alignment.bottomRight,
                        //       end: isFlipped
                        //           ? Alignment.bottomRight
                        //           : Alignment.topLeft,
                        //     ),
                        //   ),
                        //   child: Container(
                        //     padding: const EdgeInsets.symmetric(
                        //       horizontal: 16,
                        //       vertical: 10,
                        //     ),
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(12),
                        //       color: Mycolors.darkblue,
                        //     ),
                        //     child: const Text(
                        //       "شهادات طلابنا ",
                        //       style: TextStyle(
                        //         fontSize: 24,
                        //         color: Colors.white,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      );
                    },
                  ),

                  Text(
                    '  للعام الحالي ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // الـ PageView
                  SizedBox(
                    height: pageHeight,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index % _certificates.length;
                        });
                      },
                      itemCount: _certificates.length,
                      itemBuilder: (context, index) {
                        final cert = _certificates[index];

                        String imageUrl = "";
                        String studentName = "طالب";

                        try {
                          // ✅ Fixed: Use proper object property access
                          imageUrl = _buildImageUrl(cert.image.url);

                          // ✅ Fixed: Check properties in order of preference
                          studentName =
                              cert.firstname ??
                              cert.studentName ??
                              cert.name ??
                              cert.lastname ??
                              "طالب";

                          // If firstname exists and lastname exists, combine them
                          if (cert.firstname != null && cert.lastname != null) {
                            studentName = "${cert.firstname} ${cert.lastname}";
                          }
                        } catch (e) {
                          print("Error accessing certificate data: $e");
                        }

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: imageUrl.isNotEmpty
                                ? Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: pageHeight,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Container(
                                            height: pageHeight,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: Mycolors
                                                    .primary_color
                                                    .colors,
                                              ),
                                            ),
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Color(0xffa76433)),
                                              ),
                                            ),
                                          );
                                        },
                                    errorBuilder: (context, error, stackTrace) {
                                      print(
                                        "Failed to load certificate image: $imageUrl",
                                      );
                                      return _buildPlaceholder(
                                        studentName,
                                        pageHeight,
                                      );
                                    },
                                  )
                                : _buildPlaceholder(studentName, pageHeight),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPlaceholder(String name, double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xff4f2349).withOpacity(0.7),
            const Color(0xffa76433).withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school, color: Colors.white, size: height * 0.15),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: height * 0.05,
                // fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
