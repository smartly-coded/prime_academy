// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:prime_academy/core/di/dependency_injection.dart';
// import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
// import 'package:prime_academy/features/start_CommRequest/logic/CommRequest_cubit.dart';
// import 'package:prime_academy/features/studentsTestimonals/logic/testimonal_cubit.dart';
// import 'package:prime_academy/presentation/widgets/Start_Home_widget/Feature_section.dart';
// import 'package:prime_academy/presentation/widgets/Start_Home_widget/footer_section.dart';
// import 'package:prime_academy/presentation/widgets/Start_Home_widget/student_opinion.dart';
// import 'package:prime_academy/presentation/widgets/Start_Home_widget/students_grades.dart';
// import 'package:prime_academy/presentation/widgets/Start_Home_widget/students_slider_section.dart';
// import 'package:prime_academy/presentation/widgets/Start_Home_widget/video_section.dart';
// import 'package:prime_academy/presentation/widgets/Start_Home_widget/VideoWithBackground.dart';

// class StartPage extends StatelessWidget {
//   const StartPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Mycolors.backgroundColor,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.5,
//               child: SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.5,
//                 child: VideoWithBackground(),
//               ),
//             ),

//             const FeaturesSection(),

//             const VideoSection(),
//             const StudentsSliderSection(),
//             BlocProvider(
//               create: (context) => getIt<TestimonalCubit>(),
//               child: const TestimonialsSection(),
//             ),

//             StudentsGreadesSection(),
//             BlocProvider(
//               create: (context) => CommRequestCubit(),
//               child: FooterSection(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prime_academy/core/di/dependency_injection.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/start_CommRequest/logic/CommRequest_cubit.dart';
import 'package:prime_academy/features/studentsTestimonals/logic/testimonal_cubit.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/Feature_section.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/footer_section.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/student_opinion.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/students_grades.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/students_slider_section.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/video_section.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/VideoWithBackground.dart';
import 'package:url_launcher/url_launcher.dart'; // ✅ مهم للواتساب

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  Future<void> openWhatsAppChat() async {
    const String phoneNumber = "96556651979";
    const String message = "Hello, I want to chat with you!";

    final Uri whatsappUrl = Uri.parse(
      "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}",
    );

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch WhatsApp";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mycolors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: VideoWithBackground(),
              ),
            ),

            const FeaturesSection(),

            const VideoSection(),
            const StudentsSliderSection(),
            BlocProvider(
              create: (context) => getIt<TestimonalCubit>(),
              child: const TestimonialsSection(),
            ),

            StudentsGreadesSection(),
            BlocProvider(
              create: (context) => CommRequestCubit(),
              child: FooterSection(),
            ),
          ],
        ),
      ),

      floatingActionButton: SizedBox(
        height: 40,
        width: 40,
        child: FloatingActionButton(
          onPressed: openWhatsAppChat,
          backgroundColor: Colors.white,
          shape: const CircleBorder(),
          child: const FaIcon(
            FontAwesomeIcons.whatsapp,
            color: Colors.green,
            size: 30,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
