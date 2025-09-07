// import 'package:flutter/material.dart';
// import 'package:prime_academy/presentation/Home/veiw/homePage.dart';

// import 'package:prime_academy/presentation/widgets/splashWidgets/buildMobileLayout.dart';
// import 'package:prime_academy/presentation/widgets/splashWidgets/buildTabletLayout.dart';

// class StartScreen extends StatelessWidget {
//   const StartScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0XFF0f1217),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             LayoutBuilder(
//               builder: (context, constraints) {
//                 final isTablet = constraints.maxWidth > 600;
//                 final isMobile = constraints.maxWidth < 600;
//                 final isLandscape =
//                     constraints.maxWidth > constraints.maxHeight;

//                 final gifAsset = "lib/assets/Gifs/onboarding.gif";

//                 final mainTitle = "نافس و تعلم ";
//                 final subTitle =
//                     "برايم أكاديـمي رحلتك التعليمية الشاملة في الكويت";
//                 final image = "lib/assets/images/big-screen-cup.jpg";

//                 return Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: isMobile ? 16.0 : 10,
//                     vertical: isMobile ? 20.0 : 10,
//                   ),
//                   child: isMobile
//                       ? buildMobileLayout(
//                           constraints,
//                           isMobile,
//                           isTablet,
//                           isLandscape,
//                           gifAsset,
//                           mainTitle,
//                           subTitle,
//                           image,
//                           context,
//                         )
//                       : buildTabletLayout(
//                           constraints,
//                           isMobile,
//                           isTablet,
//                           isLandscape,
//                           gifAsset,
//                           mainTitle,
//                           subTitle,
//                           image,
//                           context,
//                         ),
//                 );
//               },
//             ),
//             Positioned(
//               top: 10,
//               right: 10,
//               child: TextButton(
//                 style: TextButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 4,
//                   ),
//                   minimumSize: Size.zero,
//                   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                   foregroundColor: Colors.white,
//                 ),
//                 onPressed: () {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (_) => const HomePage()),
//                   );
//                 },
//                 child: const Text(
//                   "تخطى",
//                   style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:prime_academy/presentation/widgets/Start_Home_widget/trophy_section.dart';

// class StartPage extends StatelessWidget {
//   const StartPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Positioned.fill(

//           child: Image.asset("assets/images/background.jpg", fit: BoxFit.cover),
//         ),
//         const SingleChildScrollView(
//           padding: EdgeInsets.all(20),
//           child: TrophySection(),
//         ),
//       ],
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:prime_academy/presentation/widgets/Start_Home_widget/trophy_section.dart';

// class StartPage extends StatelessWidget {
//   const StartPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0XFF0f1217),
//       body: Stack(
//         children: [
//           SizedBox.expand(
//             child: Image.asset(
//               "assets/images/background.jpg",
//               fit: BoxFit.cover,
//             ),
//           ),

//           const SafeArea(child: Column(children: [TrophySection()])),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/Feature_section.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/footer_section.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/student_opinion.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/students_grades.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/students_slider_section.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/trophy_section.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/video_section.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF0f1217),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      "assets/images/background.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: TrophySection(),
                    ),
                  ),
                ],
              ),
            ),

            const FeaturesSection(),

            const VideoSection(),
            const StudentsSliderSection(),
            const TestimonialsSection(),
            StudentsGreadesSection(),
            FooterSection(),
          ],
        ),
      ),
    );
  }
}
