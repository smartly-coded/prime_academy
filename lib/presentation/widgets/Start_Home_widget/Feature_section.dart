// import 'package:flutter/material.dart';
// import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
// import 'package:prime_academy/presentation/widgets/splashWidgets/build_text_withoutImage.dart';

// class FeaturesSection extends StatelessWidget {
//   const FeaturesSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final isMobile = width < 600;

//     return Container(
//       color: Mycolors.backgroundColor,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             buildTextWithBorder(
//               "ابدأ بالتعلم مع برايم أكاديمي",
//               "",
//               context,
//               containerWidth: isMobile ? width * 0.8 : width * 0.5,
//             ),

//             const SizedBox(height: 30),

//             GridView.count(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               crossAxisCount: isMobile ? 1 : 2,
//               crossAxisSpacing: 16,
//               mainAxisSpacing: 16,
//               childAspectRatio: isMobile ? 1.8 : 1.4,
//               children: const [
//                 FeatureCard(
//                   icon: Icons.menu_book,
//                   title: "دورات شاملة",
//                   description:
//                       "مكتبة دورات كاملة تغطي كل شي تحتاجه وتخليك دايم مستعد.",
//                 ),
//                 FeatureCard(
//                   icon: Icons.person,
//                   title: "مدرسين خبرة",
//                   description:
//                       "راح تستفيد من خبرات مدرسين متمكنين يساعدونك توصل لأفضل مستوى.",
//                 ),
//                 FeatureCard(
//                   icon: Icons.assignment,
//                   title: "اختبارات تفاعلية ممتعة",
//                   description:
//                       "اختبارات سهلة وممتعة تخلّيك تجهز حق الامتحانات بطريقة سريعة ومضمونة.",
//                 ),
//                 FeatureCard(
//                   icon: Icons.computer,
//                   title: "تعلم عن بُعد",
//                   description:
//                       "تقدر تدرس من أي مكان وأي وقت يناسبك، وانت قاعد ببيتك أو بأي مكان تحبه.",
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FeatureCard extends StatefulWidget {
//   final IconData icon;
//   final String title;
//   final String description;

//   const FeatureCard({
//     super.key,
//     required this.icon,
//     required this.title,
//     required this.description,
//   });

//   @override
//   State<FeatureCard> createState() => _FeatureCardState();
// }

// class _FeatureCardState extends State<FeatureCard> {
//   double _translateY = 0;

//   void _onTap() async {
//     setState(() => _translateY = -8); // يطلع لفوق شوية
//     await Future.delayed(const Duration(milliseconds: 120));
//     setState(() => _translateY = 0); // يرجع تاني
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final bool isTablet = width >= 600;

//     return GestureDetector(
//       onTap: _onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 180),
//         curve: Curves.easeOut,
//         transform: Matrix4.translationValues(0, _translateY, 0),
//         height: isTablet ? 70 : null,
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Mycolors.cardColor,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 10,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Icon(widget.icon, color: Colors.orange, size: 40),
//             const SizedBox(height: 12),
//             Text(
//               widget.title,
//               style: const TextStyle(fontSize: 18, color: Colors.white),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 8),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               child: Text(
//                 widget.description,
//                 style: const TextStyle(fontSize: 15, color: Colors.white70),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:ui';

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

            // ✅ Remove GridView and use Column/Wrap instead
            isMobile
                ? Column(
                    children: const [
                      FeatureCard(
                        icon: Icons.menu_book,
                        title: "دورات شاملة",
                        description:
                            "مكتبة دورات كاملة تغطي كل شي تحتاجه وتخليك دايم مستعد.",
                      ),
                      SizedBox(height: 28),
                      FeatureCard(
                        icon: Icons.person,
                        title: "مدرسين خبرة",
                        description:
                            "راح تستفيد من خبرات مدرسين متمكنين يساعدونك توصل لأفضل مستوى.",
                      ),
                      SizedBox(height: 28),
                      FeatureCard(
                        icon: Icons.assignment,
                        title: "اختبارات تفاعلية ممتعة",
                        description:
                            "اختبارات سهلة وممتعة تخلّيك تجهز حق الامتحانات بطريقة سريعة ومضمونة.",
                      ),
                      SizedBox(height: 28),
                      FeatureCard(
                        icon: Icons.computer,
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
