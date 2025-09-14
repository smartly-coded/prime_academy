import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/start_CommRequest/logic/CommRequest_cubit.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/Feature_section.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/footer_section.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/student_opinion.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/students_grades.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/students_slider_section.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/video_section.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/VideoWithBackground.dart';
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
               child:  
               
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: VideoWithBackground(),
                ),

            ),

            const FeaturesSection(),

            const VideoSection(),
            const StudentsSliderSection(),
            const TestimonialsSection(),
            StudentsGreadesSection(),
           BlocProvider(
  create: (context) => CommRequestCubit(),
  child: FooterSection(),
),

          ],
        ),
      ),
    );
  }
}
