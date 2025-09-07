import 'dart:async';
import 'package:flutter/material.dart';

class StudentsGreadesSection extends StatefulWidget {
  const StudentsGreadesSection({super.key});

  @override
  State<StudentsGreadesSection> createState() => _StudentsGreadesSectionState();
}

class _StudentsGreadesSectionState extends State<StudentsGreadesSection> {
  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;

  final List<Student> students = [
    Student(name: "أحمد محمد", imagegrade: "assets/images/imagegrade.jpeg"),
    Student(name: "سارة عبد الله", imagegrade: "assets/images/imagegrade.jpeg"),
    Student(name: "علي حسن", imagegrade: "assets/images/imagegrade.jpeg"),
    Student(name: "فاطمة إبراهيم", imagegrade: "assets/images/imagegrade.jpeg"),
    Student(name: "يوسف محمود", imagegrade: "assets/images/imagegrade.jpeg"),
    Student(name: "لمى أحمد", imagegrade: "assets/images/imagegrade.jpeg"),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.33,
      initialPage: students.length * 1000,
    );
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
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
      padding: const EdgeInsets.symmetric(vertical: 50),
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
                color: const Color(0XFF0f1217),
              ),
              child: const Text(
                "شهادات الطلاب",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const Text(
            "للعام الحالي",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: isMobile ? 200 : 250,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                final student = students[index % students.length];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: GestureDetector(
                    onTap: () {
                      if (_timer.isActive) {
                        _timer.cancel();
                      } else {
                        _startAutoPlay();
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            student.imagegrade,
                            fit: BoxFit.cover,
                            height: isMobile ? 180 : 220,
                            width: isMobile ? 110 : 140,
                          ),
                        ),

                        if (_currentPage % students.length ==
                            index % students.length)
                          AnimatedOpacity(
                            opacity: _timer.isActive ? 0.0 : 1.0,
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              height: isMobile ? 180 : 220,
                              width: isMobile ? 110 : 140,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.black.withOpacity(0.7),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    student.name,
                                    style: TextStyle(
                                      fontSize: isMobile ? 14 : 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Cairo',
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
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
  }
}

class Student {
  final String name;
  final String imagegrade;

  Student({required this.name, required this.imagegrade});
}
