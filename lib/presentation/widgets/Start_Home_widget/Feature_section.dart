import 'package:flutter/material.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Container(
      color: const Color.fromARGB(255, 45, 42, 70),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
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
                  color: const Color(0XFF0f1217),
                ),

                child: const Text(
                  "ابدأ بالتعلم مع برايم أكاديمي",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isMobile ? 2 : 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: isMobile
                  ? 0.75
                  : 1, // ✅ يخلي الكارت أطول شوية على الموبايل
              children: const [
                FeatureCard(
                  icon: Icons.menu_book,
                  title: "دورات شاملة",
                  description:
                      "مكتبة دورات كاملة تغطي كل شي تحتاجه وتخليك دايم مستعد.",
                ),
                FeatureCard(
                  icon: Icons.person,
                  title: "مدرسين خبرة",
                  description:
                      "راح تستفيد من خبرات مدرسين متمكنين يساعدونك توصل لأفضل مستوى.",
                ),

                FeatureCard(
                  icon: Icons.assignment,
                  title: "اختبارات تفاعلية ممتعة",
                  description:
                      "اختبارات سهلة وممتعة تخلّيك تجهز حق الامتحانات بطريقة سريعة ومضمونة.",
                ),

                FeatureCard(
                  icon: Icons.computer,
                  title: "تعلم عن بُعد",
                  description:
                      "تقدر تدرس من أي مكان وأي وقت يناسبك، وانت قاعد ببيتك أو بأي مكان تحبه.",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0f1217),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.orange, size: 40),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontFamily: 'Cairo',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
