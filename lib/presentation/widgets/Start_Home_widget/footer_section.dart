import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prime_academy/core/Utils/validators.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/start_CommRequest/logic/CommRequest_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    ValueNotifier<bool> gradientFlipped3 = ValueNotifier(false);

    return Container(
      color: Mycolors.backgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: 44,
        horizontal: 24,
      ), // زاد 4px
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              Image.asset(
                'assets/images/footer-logo.webp',
                width: 154,
                height: 154,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 124,
                  height: 124,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 64,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Text(
                "مكان التعلم الشامل والتجربة التعليمية المميزة،\nنحن نلتزم بتوفير بيئة تعلم محفزة تمكّن الطلاب\nوتمنحهم الفرصة لتحقيق أهدافهم التعليمية والمهنية",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 18 : 20,
                  color: Colors.white70,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 34),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIcon(
                    FontAwesomeIcons.facebookF,
                    'Facebook',
                    'https://www.facebook.com/primeacademy.co',
                    Colors.white,
                    Colors.black,
                    24,
                  ),
                  const SizedBox(width: 19),
                  _buildSocialIcon(
                    FontAwesomeIcons.youtube,
                    'YouTube',
                    'https://www.youtube.com/channel/UCYvdLyU752m0ln637tW540Q',
                    Colors.black,
                    Colors.white,
                    32,
                  ),
                ],
              ),

              const SizedBox(height: 34),

              Text(
                "الكورسات",
                style: TextStyle(
                  fontSize: 24,
                  // fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Divider(
                color: Mycolors.orange,
                thickness: 2,
                indent: 104,
                endIndent: 104,
              ),
              const SizedBox(height: 19),
              Wrap(
                direction: Axis.vertical,
                spacing: 14,
                runSpacing: 14,
                children: [
                  _buildCourseItem("اللغة العربية"),
                  _buildCourseItem("اللغة الإنجليزية"),
                  _buildCourseItem("اللغة الألمانية"),
                  _buildCourseItem("لغات البرمجة"),
                ],
              ),

              const SizedBox(height: 34),

              Text(
                "المناهج",
                style: TextStyle(
                  fontSize: 24,
                  // fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Divider(
                color: Mycolors.orange,
                thickness: 2,
                indent: 104, // زاد 4px
                endIndent: 104, // زاد 4px
              ),
              const SizedBox(height: 19), // زاد 4px
              Wrap(
                direction: Axis.vertical,
                spacing: 14, // زاد 4px
                runSpacing: 14, // زاد 4px
                children: [
                  _buildCourseItem("تأسيس"),
                  _buildCourseItem("التعليم الابتدائي"),
                  _buildCourseItem("التعليم المتوسط"),
                  _buildCourseItem("التعليم الثانوي"),
                ],
              ),

              const SizedBox(height: 44), // زاد 4px

              BlocListener<CommRequestCubit, CommRequestState>(
                listener: (context, state) {
                  if (state is CommRequestSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("✅ تم إرسال الطلب بنجاح"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (state is CommRequestFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("❌ فشل إرسال الطلب: ${state.error}"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Column(
                  children: [
                    Text(
                      "ابقى على تواصل !",
                      style: TextStyle(
                        fontSize: 26, // زاد 4px
                        // fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Divider(
                      color: Mycolors.orange,
                      thickness: 2,
                      indent: 64, // زاد 4px
                      endIndent: 64, // زاد 4px
                    ),
                    const SizedBox(height: 14), // زاد 4px
                    Text(
                      "للحصول على حصص مجانية وامتنابعة اخر الأخبار\nادخل رقم هاتفك المحمول",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20, // زاد 4px
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24), // زاد 4px
                    Container(
                      width: isMobile ? width * 0.8 : width * 0.5,
                      decoration: BoxDecoration(
                        color: Mycolors.backgroundColor,
                        borderRadius: BorderRadius.circular(24), // زاد 4px
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: TextFormField(
                        controller: phoneController,
                        validator: Validators.validateKuwaitPhone,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Color.fromARGB(255, 229, 228, 228),
                            size: 28, // زاد 4px
                          ),
                          hintText: "رقم هاتفك المحمول",
                          hintStyle: TextStyle(
                            color: Color.fromARGB(255, 229, 228, 228),
                            fontSize: 18, // زاد 4px
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ), // زاد 4px
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18, // زاد 4px
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    const SizedBox(height: 19), // زاد 4px
                    // GestureDetector(
                    //   onTap: () {
                    //     final phone = phoneController.text.trim();
                    //     if (Validators.validateKuwaitPhone(phone) == null) {
                    //       context.read<CommRequestCubit>().sendRequest(phone);
                    //     } else {
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //         const SnackBar(
                    //           content: Text("❌ أدخل رقم هاتف صحيح"),
                    //         ),
                    //       );
                    //     }
                    //   },
                    //   child: Container(
                    //     padding: const EdgeInsets.all(4), // زاد 1px
                    //     decoration: BoxDecoration(
                    //       gradient:  LinearGradient(
                    //         colors:Mycolors.primary_color.colors,
                    //         begin: Alignment.topLeft,
                    //         end: Alignment.bottomRight,
                    //       ),
                    //       borderRadius: BorderRadius.circular(19),
                    //     ),
                    //     child: Container(
                    //       padding: const EdgeInsets.all(19),
                    //       decoration: BoxDecoration(
                    //         color: const Color.fromARGB(255, 28, 31, 48),
                    //         borderRadius: BorderRadius.circular(19),
                    //       ),
                    //       child:
                    //           BlocBuilder<CommRequestCubit, CommRequestState>(
                    //             builder: (context, state) {
                    //               if (state is CommRequestLoading) {
                    //                 return const Center(
                    //                   child: CircularProgressIndicator(
                    //                     color: Colors.white,
                    //                   ),
                    //                 );
                    //               }
                    //               return Text(
                    //                 "ارسال",
                    //                 style: TextStyle(
                    //                   color: Colors.white,
                    //                   fontSize: 20,
                    //                 ),
                    //               );
                    //             },
                    //           ),
                    //     ),
                    //   ),
                    // ),
                    ValueListenableBuilder<bool>(
                      valueListenable: gradientFlipped3,
                      builder: (context, isFlipped, _) {
                        return GestureDetector(
                          onTap: () {
                            gradientFlipped3.value = !gradientFlipped3.value;

                            final phone = phoneController.text.trim();
                            if (Validators.validateKuwaitPhone(phone) == null) {
                              context.read<CommRequestCubit>().sendRequest(
                                phone,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.white,
                                  content: Text(
                                    "❌ أدخل رقم هاتف كويتي صحيح",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: Mycolors.primary_color.colors,
                                begin: isFlipped
                                    ? Alignment.bottomRight
                                    : Alignment.topLeft,
                                end: isFlipped
                                    ? Alignment.topLeft
                                    : Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(13),
                              decoration: BoxDecoration(
                                color: Mycolors.cardColor1,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child:
                                  BlocBuilder<
                                    CommRequestCubit,
                                    CommRequestState
                                  >(
                                    builder: (context, state) {
                                      if (state is CommRequestLoading) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        );
                                      }
                                      return const Text(
                                        "ارسال",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      );
                                    },
                                  ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 34), // زاد 4px

              Text(
                "© 2025 PRIME ACADEMY. جميع الحقوق محفوظة",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 18, // زاد 4px
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(
    IconData icon,
    String tooltip,
    String url,
    Color container_color,
    Color icon_color,
    double size_icon,
  ) {
    return Container(
      width: 35, // زاد 4px
      height: 35, // زاد 4px

      decoration: BoxDecoration(color: container_color, shape: BoxShape.circle),
      child: Center(
        child: IconButton(
          icon: Icon(icon, color: icon_color, size: size_icon), // زاد 4px
          tooltip: tooltip,
          onPressed: () async {
            final uri = Uri.parse(url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              debugPrint('Could not launch $url');
            }
          },
        ),
      ),
    );
  }

  Widget _buildCourseItem(String text) {
    return Text(
      textAlign: TextAlign.end,
      text,
      style: const TextStyle(
        fontSize: 20, // زاد 4px
        color: Colors.white70,
      ),
    );
  }
}
