import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/presentation/Modules/veiw/modulesPage.dart';

class CourseCard extends StatelessWidget {
  final String courseName;
  final int courseId;
  final bool isMobile;
  final String? image;
  final LoginResponse user;

  const CourseCard({
    super.key,
    required this.courseName,
    required this.isMobile,
    this.image,
    required this.courseId,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> gradientFlipped4 = ValueNotifier(false);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ModulesPage(
              courseId: courseId,
              courseName: courseName,
              user: user,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Mycolors.cardColor1,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ModulesPage(
                        courseId: courseId,
                        courseName: courseName,
                        user: user,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: isMobile ? 200 : 140,
                  decoration: BoxDecoration(
                    color: Mycolors.cardColor1,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: double.infinity,

                        child: (image != null && image!.isNotEmpty)
                            ? ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                child: Image.network(
                                  buildImageUrl(image),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                        child: Transform.scale(
                                          scale: 1.1,
                                          child: Image.asset(
                                            'assets/Gifs/englishcourse.gif',
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                            alignment: Alignment.center,
                                          ),
                                        ),
                                      ),
                                ),
                              )
                            : Center(
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFFFAA00,
                                    ).withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.menu_book,
                                    color: Color(0xFFFFAA00),
                                    size: 40,
                                  ),
                                ),
                              ),
                      ),

                      if (image != null && image!.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ValueListenableBuilder<bool>(
                        valueListenable: gradientFlipped4,
                        builder: (context, isFlipped, _) {
                          return GestureDetector(
                            onTap: () {
                              gradientFlipped4.value = !gradientFlipped4.value;

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ModulesPage(
                                    courseId: courseId,
                                    courseName: courseName,
                                    user: user,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: Mycolors.primary_color.colors,
                                  begin: isFlipped
                                      ? Alignment.bottomRight
                                      : Alignment.topLeft,
                                  end: isFlipped
                                      ? Alignment.topLeft
                                      : Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xffa76433,
                                    ).withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                courseName,
                                style: TextStyle(
                                  fontSize: isMobile ? 15 : 17,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ModulesPage(
                                courseId: courseId,
                                courseName: courseName,
                                user: user,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: Mycolors.primary_color.colors,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Mycolors.darkblue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 8),
                                Text(
                                  "الذهاب للدورة",
                                  style: TextStyle(
                                    fontSize: isMobile ? 14 : 16,
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة لتحويل المسار النسبي للرابط الكامل
  String buildImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return "";
    if (imagePath.startsWith('http')) return imagePath;

    const String cdnPrefix = "https://cdn.primeacademy.education/primeacademy";
    // تأكد إن فيه "/" واحد فقط بين الجزء الثابت والمسار
    final fixedPath = imagePath.startsWith('/') ? imagePath : '/$imagePath';
    return "$cdnPrefix$fixedPath";
  }
}
