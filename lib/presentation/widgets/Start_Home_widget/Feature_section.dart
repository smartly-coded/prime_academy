import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/presentation/widgets/splashWidgets/build_text_withoutImage.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Container(
      color: Mycolors.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildTextWithBorder("ابدأ بالتعلم مع برايم أكاديمي", "", context),

            const SizedBox(height: 30),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isMobile ? 1 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: isMobile ? 2 : 1,
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
          color: Mycolors.cardColor,
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
            ),
          ],
        ),
      ),
    );
  }
}
