import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFF0f1217),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0f1217),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "مرحبا",
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    color: Colors.white70,
                    fontFamily: 'Cairo',
                  ),
                ),
                Text(
                  "Student User",
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),

            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xffa76433), Color(0xff4f2349)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0f1217),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.logout, color: Colors.white, size: 18),
                    const SizedBox(width: 5),
                    Text(
                      "تسجيل الخروج",
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        color: Colors.white,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: isMobile ? 15 : width * 0.1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("الدورات المنتسب بها"),
            const SizedBox(height: 15),

            GridView.count(
              crossAxisCount: isMobile ? 1 : 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: isMobile ? 1.5 : 1.8,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                _buildCourseCard(
                  title: "الدورة الأولى",
                  progress: 75,
                  isMobile: isMobile,
                ),
                _buildCourseCard(
                  title: "الدورة الثانية",
                  progress: 40,
                  isMobile: isMobile,
                ),
              ],
            ),

            const SizedBox(height: 30),

            _buildSectionTitle("الدورات المقترحة"),
            const SizedBox(height: 15),

            GridView.count(
              crossAxisCount: isMobile ? 1 : 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: isMobile ? 1.5 : 1.8,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                _buildSuggestedCourseCard(
                  title: "الدورة المقترحة 1",
                  isMobile: isMobile,
                ),
                _buildSuggestedCourseCard(
                  title: "الدورة المقترحة 2",
                  isMobile: isMobile,
                ),
              ],
            ),

            const SizedBox(height: 30),

            _buildSectionTitle("تصنيف الطالب"),
            const SizedBox(height: 15),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1a1d24),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  Text(
                    "متفوق",
                    style: TextStyle(
                      fontSize: isMobile ? 20 : 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "أنت من الطلاب المتفوقين في المنصة. استمر في الأداء الجيد!",
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 16,
                      color: Colors.white70,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xffa76433), Color(0xff4f2349)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF0f1217),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseCard({
    required String title,
    required int progress,
    required bool isMobile,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1d24),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isMobile ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 15),

          // شريط التقدم
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Stack(
              children: [
                Container(
                  width: (progress / 100) * (isMobile ? 250 : 300),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xffa76433), Color(0xff4f2349)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "$progress% مكتمل",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 20),

          // زر الذهاب للدورة
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xffa76433), Color(0xff4f2349)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0f1217),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "الذهاب للدورة",
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedCourseCard({
    required String title,
    required bool isMobile,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1d24),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        image: const DecorationImage(
          image: AssetImage(
            "assets/images/course_bg.png",
          ), // يمكن استبدالها بصورة خلفية
          fit: BoxFit.cover,
          opacity: 0.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isMobile ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "دورة مقترحة بناءً على أدائك وتقدمك في المنصة",
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              color: Colors.white70,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 20),

          // زر عرض التفاصيل
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xffa76433), Color(0xff4f2349)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0f1217),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "عرض التفاصيل",
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
