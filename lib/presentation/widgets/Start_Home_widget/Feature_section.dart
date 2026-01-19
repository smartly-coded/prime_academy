import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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

            // ✅ Remove GridView and use Column/Wrap instead
            isMobile
                ? Column(
                    children: const [
                      FeatureCard(
                        icon: LucideIcons.bookOpen,
                        title: "دورات شاملة",
                        description:
                            "مكتبة دورات كاملة تغطي كل شي تحتاجه وتخليك دايم مستعد.",
                      ),
                      SizedBox(height: 28),
                      FeatureCard(
                        icon: LucideIcons.users,
                        title: "مدرسين خبرة",
                        description:
                            "راح تستفيد من خبرات مدرسين متمكنين يساعدونك توصل لأفضل مستوى.",
                      ),
                      SizedBox(height: 28),
                      FeatureCard(
                        icon: LucideIcons.award,
                        title: "اختبارات تفاعلية ممتعة",
                        description:
                            "اختبارات سهلة وممتعة تخلّيك تجهز حق الامتحانات بطريقة سريعة ومضمونة.",
                      ),
                      SizedBox(height: 28),
                      FeatureCard(
                        icon: LucideIcons.laptop,
                        title: "تعلم عن بُعد",
                        description:
                            "تقدر تدرس من أي مكان وأي وقت يناسبك، وانت قاعد ببيتك أو بأي مكان تحبه.",
                      ),
                    ],
                  )
                : Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      SizedBox(
                        width: (width - 48) / 2, // 2 columns with spacing
                        child: const FeatureCard(
                          icon: Icons.menu_book,
                          title: "دورات شاملة",
                          description:
                              "مكتبة دورات كاملة تغطي كل شي تحتاجه وتخليك دايم مستعد.",
                        ),
                      ),
                      SizedBox(
                        width: (width - 48) / 2,
                        child: const FeatureCard(
                          icon: Icons.person,
                          title: "مدرسين خبرة",
                          description:
                              "راح تستفيد من خبرات مدرسين متمكنين يساعدونك توصل لأفضل مستوى.",
                        ),
                      ),
                      SizedBox(
                        width: (width - 48) / 2,
                        child: const FeatureCard(
                          icon: Icons.assignment,
                          title: "اختبارات تفاعلية ممتعة",
                          description:
                              "اختبارات سهلة وممتعة تخلّيك تجهز حق الامتحانات بطريقة سريعة ومضمونة.",
                        ),
                      ),
                      SizedBox(
                        width: (width - 48) / 2,
                        child: const FeatureCard(
                          icon: Icons.computer,
                          title: "تعلم عن بُعد",
                          description:
                              "تقدر تدرس من أي مكان وأي وقت يناسبك، وانت قاعد ببيتك أو بأي مكان تحبه.",
                        ),
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
    return GestureDetector(
      onTap: _onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 12,
            sigmaY: 12,
          ), // backdrop-filter: blur(12px)
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            transform: Matrix4.translationValues(0, _translateY, 0),
            padding: const EdgeInsets.all(32), // 32px padding
            decoration: BoxDecoration(
              color: Color(0xFF1e222a), // oklab white with 0.05 opacity
              borderRadius: BorderRadius.circular(16), // 16px
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  blurRadius: 15,
                  spreadRadius: -3,
                  offset: Offset(0, 10),
                ),
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  blurRadius: 6,
                  spreadRadius: -4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon
                Icon(
                  widget.icon,
                  color: const Color(0xFFFF9933), // rgb(255, 153, 51) - #f93
                  size: 48, // 48px
                ),
                const SizedBox(height: 16), // gap-4 = 16px
                // Title
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18, // 18px
                    fontWeight: FontWeight.w600, // 600
                    color: Colors.white, // rgb(255, 255, 255)
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16), // gap-4 = 16px
                // Description
                Text(
                  widget.description,
                  style: TextStyle(
                    fontSize: 14, // 14px
                    color: Colors.white.withOpacity(0.9), // opacity: 0.9
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
