import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/startScreen/logic/certificate_cubit.dart';

import 'package:prime_academy/features/startScreen/logic/start_screen_state.dart';

class StudentsGreadesSection extends StatefulWidget {
  const StudentsGreadesSection({super.key});

  @override
  State<StudentsGreadesSection> createState() => _StudentsGreadesSectionState();
}

class _StudentsGreadesSectionState extends State<StudentsGreadesSection> {
  late PageController _pageController;
  Timer? _timer;
  int _currentIndex = 0;
  List<dynamic> _certificates = [];

  static const String baseUrl =
      "https://cdn-dev.primeacademy.education/primeacademydev";

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.33);
    // تأكد من أن الـ method موجود في الـ cubit
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
          duration: const Duration(milliseconds: 500),
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

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return BlocBuilder<CertificateCubit, StartScreenState>(
      builder: (context, state) {
        // تحقق من نوع الاستجابة - هل هي شهادات أم طلاب؟
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
          success: (response) {
            // تحقق من نوع البيانات المسترجعة
            try {
              _certificates = response ?? [];

              // تسجيل للتديبغ
              print("Certificates loaded: ${_certificates.length}");
              if (_certificates.isNotEmpty) {
                print("First certificate: ${_certificates[0]}");
              }
            } catch (e) {
              print("Error parsing certificates: $e");
              return Center(
                child: Text(
                  'خطأ في تحليل بيانات الشهادات',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }

            // بدء التايمر بعد تحميل البيانات
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_timer == null && _certificates.isNotEmpty) {
                _startTimer();
              }
            });

            if (_certificates.isEmpty) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 50),
                color: const Color(0xFF1a1d24),
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

                  // الـ PageView
                  SizedBox(
                    height: isMobile ? 200 : 250,
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

                        // معالجة أفضل للبيانات
                        String imageUrl = "";
                        String studentName = "طالب";

                        try {
                          // جرب طرق مختلفة للوصول للصورة والاسم
                          imageUrl = _buildImageUrl(
                            cert?.image?.url ??
                                cert?.imageUrl ??
                                cert?['image']?['url'] ??
                                cert?['imageUrl'] ??
                                "",
                          );

                          studentName =
                              cert?.firstname ??
                              cert?.studentName ??
                              cert?.name ??
                              cert?['firstname'] ??
                              cert?['studentName'] ??
                              cert?['name'] ??
                              "طالب";
                        } catch (e) {
                          print("Error accessing certificate data: $e");
                        }

                        final isSelected = index == _currentIndex;

                        return GestureDetector(
                          onTap: () {
                            // يمكنك إضافة تفاعل هنا - مثل عرض الشهادة بحجم أكبر
                            _showCertificateDialog(
                              context,
                              cert,
                              imageUrl,
                              studentName,
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: Stack(
                              children: [
                                // صورة الشهادة
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
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Center(
                                                child: CircularProgressIndicator(
                                                  value:
                                                      loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            loadingProgress
                                                                .expectedTotalBytes!
                                                      : null,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(Color(0xffa76433)),
                                                ),
                                              );
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  print(
                                                    "Failed to load certificate image: $imageUrl",
                                                  );
                                                  return _buildPlaceholder(
                                                    studentName,
                                                  );
                                                },
                                          )
                                        : _buildPlaceholder(studentName),
                                  ),
                                ),

                                // Overlay باسم الطالب
                                if (isSelected)
                                  Container(
                                    height: isMobile ? 180 : 220,
                                    width: isMobile ? 110 : 140,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.school,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          studentName,
                                          style: TextStyle(
                                            fontSize: isMobile ? 14 : 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "اضغط للعرض",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
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

                  // النقاط المؤشرة
                  if (_certificates.length > 1) ...[
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _certificates.length.clamp(0, 5),
                        (index) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          width: _currentIndex == index ? 12.0 : 8.0,
                          height: _currentIndex == index ? 12.0 : 8.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentIndex == index
                                ? Color(0xffa76433)
                                : Colors.white.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                  ],
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
            const Color(0xff4f2349).withOpacity(0.7),
            const Color(0xffa76433).withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.school, color: Colors.white, size: 40),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
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

  void _showCertificateDialog(
    BuildContext context,
    dynamic cert,
    String imageUrl,
    String studentName,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF1a1d24),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "شهادة $studentName",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Container(
                height: 300,
                width: 250,
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholder(studentName),
                      )
                    : _buildPlaceholder(studentName),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "إغلاق",
                  style: TextStyle(color: Color(0xffa76433)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
