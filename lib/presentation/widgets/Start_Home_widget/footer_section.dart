import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Container(
      color: const Color(0xFF0f1217),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/footer-logo.webp',
                width: 150,
                height: 150,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "مكان التعلم الشامل والتجربة التعليمية المميزة،\nنحن نلتزم بتوفير بيئة تعلم محفزة تمكّن الطلاب\nوتمنحهم الفرصة لتحقيق أهدافهم التعليمية والمهنية",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  color: Colors.white70,
                  fontFamily: 'Cairo',
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIcon(Icons.facebook, 'Facebook'),
                  const SizedBox(width: 15),
                  _buildSocialIcon(Icons.chat, 'WhatsApp'),
                  const SizedBox(width: 15),
                  _buildSocialIcon(Icons.camera_alt, 'Instagram'),
                  const SizedBox(width: 15),
                  _buildSocialIcon(Icons.play_arrow, 'YouTube'),
                ],
              ),

              const SizedBox(height: 30),

              Text(
                "الكورسات",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 15),
              Wrap(
                direction: Axis.vertical,

                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildCourseItem("اللغة العربية"),
                  _buildCourseItem("اللغة الإنجليزية"),
                  _buildCourseItem("اللغة الألمانية"),
                  _buildCourseItem("لغات البرمجة"),
                ],
              ),

              const SizedBox(height: 30),

              Text(
                "المناهج",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 15),
              Wrap(
                direction: Axis.vertical,
                spacing: 10,

                runSpacing: 10,
                children: [
                  _buildCourseItem("تأسيس"),
                  _buildCourseItem("التعليم الابتدائي"),
                  _buildCourseItem("التعليم المتوسط"),
                  _buildCourseItem("التعليم الثانوي"),
                ],
              ),

              const SizedBox(height: 40),

              Column(
                children: [
                  Text(
                    "ابقى على تواصل !",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "للحصول على حصص مجانية وامتنابعة اخر الأخبار\nادخل رقم هاتفك المحمول",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'Cairo',
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: isMobile ? width * 0.8 : width * 0.5,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 22, 22, 22),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.phone,
                          color: Color.fromARGB(255, 229, 228, 228),
                        ),
                        hintText: "رقم هاتفك المحمول",
                        hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 229, 228, 228),
                          fontFamily: 'Cairo',
                        ),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Cairo',
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  const SizedBox(height: 15),

                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xffa76433), Color(0xff4f2349)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),

                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 28, 31, 48),
                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: Text(
                        "ارسال",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Text(
                "© 2025 PRIME ACADEMY. جميع الحقوق محفوظة",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String tooltip) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF2a2d34),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 24),
        onPressed: () {},
        tooltip: tooltip,
      ),
    );
  }

  Widget _buildCourseItem(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.white70,
        fontFamily: 'Cairo',
      ),
    );
  }
}
