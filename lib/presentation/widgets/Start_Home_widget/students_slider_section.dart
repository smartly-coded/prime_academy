import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/startScreen/logic/start_screen_cubit.dart';
import 'package:prime_academy/features/startScreen/logic/start_screen_state.dart';

class StudentsSliderSection extends StatefulWidget {
  const StudentsSliderSection({super.key});

  @override
  State<StudentsSliderSection> createState() => _StudentsSliderSectionState();
}

class _StudentsSliderSectionState extends State<StudentsSliderSection> {
  late PageController _pageController;
  Timer? _timer;
  int _currentIndex = 0;
  List<dynamic> _students = [];

  static const String baseUrl =
      "https://cdn-dev.primeacademy.education/primeacademydev";

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.33);
    context.read<StartScreenCubit>().emitStartScreenState();
  }

  void _startTimer() {
    _timer?.cancel();
    if (_students.isEmpty) return;

    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (mounted && _pageController.hasClients) {
        // الانتقال للعنصر التالي
        _currentIndex = (_currentIndex + 1) % _students.length;

        _pageController.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: 500),
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

    if (imagePath.startsWith('http')) {
      return imagePath;
    }

    return imagePath.startsWith('/')
        ? baseUrl + imagePath
        : baseUrl + '/' + imagePath;
  }

  void _goToStudentDetail(dynamic student) {
    // إيقاف التايمر مؤقتاً
    _stopTimer();

    // الانتقال للصفحة
    Navigator.pushNamed(context, '/student-detail', arguments: student).then((
      _,
    ) {
      // إعادة تشغيل التايمر عند الرجوع
      _startTimer();
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
    final isMobile = MediaQuery.of(context).size.width < 600;

    return BlocBuilder<StartScreenCubit, StartScreenState>(
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
              'خطأ في تحميل البيانات: $error',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
          success: (studentsResponse) {
            _students = studentsResponse.data ?? [];

            // بدء التايمر فقط عند النجاح
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_timer == null && _students.isNotEmpty) {
                _startTimer();
              }
            });

            if (_students.isEmpty) {
              return Center(
                child: Text(
                  'لا توجد بيانات طلاب',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 50),
              color: const Color(0xFF1a1d24),
              child: Column(
                children: [
                  // العنوان
                  Container(
                    padding: const EdgeInsets.all(3),
                    margin: const EdgeInsets.only(bottom: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Color(0xffa76433), Color(0xff4f2349)],
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Mycolors.darkblue,
                      ),
                      child: const Text(
                        "طلاب برايم أكاديمي",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // الـ PageView
                  SizedBox(
                    height: isMobile ? 200 : 250,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index % _students.length;
                        });
                      },
                      itemCount: _students.length,
                      itemBuilder: (context, index) {
                        final student = _students[index];
                        final imageUrl = _buildImageUrl(student.image?.url);
                        final isSelected = index == _currentIndex;

                        return GestureDetector(
                          onTap: () => _goToStudentDetail(student),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: Stack(
                              children: [
                                // الصورة
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    height: isMobile ? 180 : 220,
                                    width: isMobile ? 110 : 140,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[800],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: imageUrl.isNotEmpty
                                        ? Image.network(
                                            imageUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  print(
                                                    "Failed to load: $imageUrl",
                                                  );
                                                  return _buildPlaceholder(
                                                    student.firstname ?? "طالب",
                                                  );
                                                },
                                          )
                                        : _buildPlaceholder(
                                            student.firstname ?? "طالب",
                                          ),
                                  ),
                                ),

                                // التفاعل عند التوقف
                                if (isSelected)
                                  Container(
                                    height: isMobile
                                        ? 180
                                        : 220, // نفس ارتفاع الصورة
                                    width: isMobile ? 110 : 140,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          student.firstname ?? "طالب",
                                          style: TextStyle(
                                            fontSize: isMobile ? 14 : 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
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

  Widget _buildPlaceholder(String name) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff4f2349).withOpacity(0.7),
            Color(0xffa76433).withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, color: Colors.white, size: 40),
          SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
