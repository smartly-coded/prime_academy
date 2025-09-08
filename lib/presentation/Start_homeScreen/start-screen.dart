import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
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
      backgroundColor: Mycolors.backgroundColor,
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
                  Positioned(
                    bottom: 10, // مسافة من تحت
                    right: 10, // مسافة من اليمين
                    child: SafeArea(child: TrophySection()),
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
