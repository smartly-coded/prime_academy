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
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildTextWithBorder(
              "ابدأ بالتعلم مع برايم أكاديمي",
              "",
              context,
              containerWidth: isMobile ? width * 0.8 : width * 0.5,
            ),

            const SizedBox(height: 30),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isMobile ? 1 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: isMobile ? 1.8 : 1.4,
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

class FeatureCard extends StatefulWidget {
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
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  double _translateY = 0;

  void _onTap() async {
    setState(() => _translateY = -8); // يطلع لفوق شوية
    await Future.delayed(const Duration(milliseconds: 120));
    setState(() => _translateY = 0); // يرجع تاني
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isTablet = width >= 600;

    return GestureDetector(
      onTap: _onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _translateY, 0),
        height: isTablet ? 70 : null,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Mycolors.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(widget.icon, color: Colors.orange, size: 40),
            const SizedBox(height: 12),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                widget.description,
                style: const TextStyle(fontSize: 15, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
