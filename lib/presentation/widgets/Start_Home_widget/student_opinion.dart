import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/studentsTestimonals/data/models/students_testimonals_response.dart';
import 'package:prime_academy/features/studentsTestimonals/logic/testimonal_cubit.dart';
import 'package:prime_academy/features/studentsTestimonals/logic/testimonal_state.dart';

class TestimonialsSection extends StatefulWidget {
  const TestimonialsSection({super.key});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    context.read<TestimonalCubit>().getStudentTestimonals();
  }

  void _startAutoPlay(int itemCount) {
    _timer?.cancel();

    if (itemCount <= 1) return;

    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_pageController.hasClients) {
        _currentPage++;
        if (_currentPage >= itemCount) {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  String buildImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return "";
    if (imagePath.startsWith('http')) return imagePath;

    const String cdnPrefix = "https://cdn.primeacademy.education/primeacademy";
    return imagePath.startsWith('/')
        ? "$cdnPrefix$imagePath"
        : "$cdnPrefix/$imagePath";
  }

  Widget _buildUserImage(
    StudentTestimonalsResponse testimonial,
    bool isMobile,
  ) {
    final size = isMobile ? 70.0 : 90.0;

    if (testimonial.image?.url != null && testimonial.image!.url!.isNotEmpty) {
      final fullImageUrl = buildImageUrl(testimonial.image!.url);

      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.network(
            fullImageUrl,
            width: size,
            height: size,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xff4f2349), Color(0xffa76433)],
                  ),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 1.5,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return _buildDefaultAvatar(testimonial.name, size, isMobile);
            },
          ),
        ),
      );
    }

    return _buildDefaultAvatar(testimonial.name, size, isMobile);
  }

  Widget _buildDefaultAvatar(String name, double size, bool isMobile) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xff4f2349), Color(0xffa76433)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'P',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 16 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTestimonialCard(
    StudentTestimonalsResponse testimonial,
    bool isMobile,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isMobile ? 50 : 80),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0f1217),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: isMobile ? 20 : 25),

              Expanded(
                child: Center(
                  child: Text(
                    testimonial.content,
                    style: TextStyle(
                      fontSize: isMobile ? 20 : 25,
                      color: Colors.white,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    testimonial.name,
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ],
          ),

          Positioned(
            top: -50,
            left: 10,
            child: _buildUserImage(testimonial, isMobile),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 200, // تصغير الارتفاع
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 12),
            Text(
              'جاري تحميل آراء الطلاب...',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return SizedBox(
      height: 200, // تصغير الارتفاع
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 36),
            SizedBox(height: 12),
            Text(
              'خطأ في تحميل التقييمات',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              error,
              style: TextStyle(color: Colors.white70, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                context.read<TestimonalCubit>().getStudentTestimonals();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                'إعادة المحاولة',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 200, // تصغير الارتفاع
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rate_review_outlined, color: Colors.white54, size: 40),
            SizedBox(height: 12),
            Text(
              'لا توجد تقييمات متاحة حالياً',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'كن أول من يقيم الكورسات!',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    ValueNotifier<bool> gradientFlipped = ValueNotifier(false);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      color: const Color(0xFF1a1d24),
      child: Column(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: gradientFlipped,
            builder: (context, isFlipped, _) {
              return GestureDetector(
                onTap: () {
                  gradientFlipped.value = !gradientFlipped.value;
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  margin: const EdgeInsets.only(bottom: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: Mycolors.primary_color.colors,
                      begin: isFlipped
                          ? Alignment.topLeft
                          : Alignment.bottomRight,
                      end: isFlipped
                          ? Alignment.bottomRight
                          : Alignment.topLeft,
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
                      "ماذا قالوا عنا الطلاب",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: isMobile ? 100 : 200),
          // المحتوى الأساسي
          BlocBuilder<TestimonalCubit, TestimonalState>(
            builder: (context, state) {
              return state.when(
                initial: () => _buildLoadingState(),
                loading: () => _buildLoadingState(),
                success: (data) {
                  if (data is List<StudentTestimonalsResponse>) {
                    if (data.isEmpty) {
                      return _buildEmptyState();
                    }

                    // فلترة التقييمات المرئية فقط
                    final visibleTestimonials = data
                        .where((t) => t.viewable)
                        .toList();

                    if (visibleTestimonials.isEmpty) {
                      return _buildEmptyState();
                    }

                    // تشغيل الـ auto play
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _startAutoPlay(visibleTestimonials.length);
                    });

                    return SizedBox(
                      height: isMobile ? 250 : 350,
                      child: OverflowBox(
                        maxHeight: isMobile ? 300 : 390,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: visibleTestimonials.length,
                          clipBehavior: Clip.none, // مهم للصورة الطالعة
                          itemBuilder: (context, index) {
                            final testimonial = visibleTestimonials[index];
                            return _buildTestimonialCard(testimonial, isMobile);
                          },
                        ),
                      ),
                    );
                  }

                  // لو الـ data مش List<StudentTestimonalsResponse>
                  return _buildEmptyState();
                },
                error: (error) => _buildErrorState(error),
              );
            },
          ),
        ],
      ),
    );
  }
}
