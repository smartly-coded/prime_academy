import 'dart:async';
import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';

class TestimonialsSection extends StatefulWidget {
  const TestimonialsSection({super.key});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection> {
  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;

  final List<Testimonial> _testimonials = [
    Testimonial(
      percentage: "100%",
      comment: "فنرج سلسي ويسيرة شكوا كثير",
      studentName: "Khadija Altamady",
      studentImage: "assets/images/student_image.png",
    ),
    Testimonial(
      percentage: "95%",
      comment: "jx3 cjitao asqitalig lxs cjitao aaalal!",
      studentName: "Louloua Nabil",
      studentImage: "assets/images/student_image.png",
    ),
    Testimonial(
      percentage: "98%",
      comment: "تجربة رائعة ومفيدة جداً",
      studentName: "أحمد محمد",
      studentImage: "assets/images/student_image.png",
    ),
    Testimonial(
      percentage: "100%",
      comment: "أفضل منصة تعليمية استخدمتها",
      studentName: "سارة عبد الله",
      studentImage: "assets/images/student_image.png",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_pageController.hasClients) {
        _currentPage++;
        if (_currentPage >= _testimonials.length) {
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
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      color: const Color(0xFF1a1d24),
      child: Column(
        children: [
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Mycolors.darkblue,
              ),
              child: const Text(
                "ماذا قالوا عنا الطلاب",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: Colors.white,
                ),
              ),
            ),
          ),

          SizedBox(
            height: isMobile ? 240 : 280,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _testimonials.length,
              itemBuilder: (context, index) {
                final testimonial = _testimonials[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 15),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0f1217),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ClipOval(
                        child: Image.asset(
                          testimonial.studentImage,
                          width: isMobile ? 40 : 50,
                          height: isMobile ? 40 : 50,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Expanded(
                        child: Center(
                          child: Text(
                            testimonial.comment,
                            style: TextStyle(
                              fontSize: isMobile ? 14 : 16,
                              color: Colors.white,
                              fontFamily: 'Cairo',
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          testimonial.studentName,
                          style: TextStyle(
                            fontSize: isMobile ? 13 : 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Testimonial {
  final String percentage;
  final String comment;
  final String studentName;
  final String studentImage;

  Testimonial({
    required this.percentage,
    required this.comment,
    required this.studentName,
    required this.studentImage,
  });
}
