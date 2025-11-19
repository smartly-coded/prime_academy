import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    return Container(
      color: Mycolors.backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 44, horizontal: 24), // زاد 4px
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              Image.asset(
                'assets/images/footer-logo.webp',
                width: 154, // زاد 4px
                height: 154, // زاد 4px
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 124, // زاد 4px
                  height: 124, // زاد 4px
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 64, // زاد 4px
                  ),
                ),
              ),

              const SizedBox(height: 14), // زاد 4px

              Text(
                "مكان التعلم الشامل والتجربة التعليمية المميزة،\nنحن نلتزم بتوفير بيئة تعلم محفزة تمكّن الطلاب\nوتمنحهم الفرصة لتحقيق أهدافهم التعليمية والمهنية",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 18 : 20, // زاد 4px
                  color: Colors.white70,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 34), // زاد 4px

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIcon(Icons.facebook, 'Facebook','https://www.facebook.com/primeacademy.co'),
                  const SizedBox(width: 19), // زاد 4px
                  _buildSocialIcon(Icons.play_arrow, 'YouTube','https://www.youtube.com/channel/UCYvdLyU752m0ln637tW540Q'),
                ],
              ),

              const SizedBox(height: 34), // زاد 4px

              Text(
                "الكورسات",
                style: TextStyle(
                  fontSize: 24, // زاد 4px
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
                  _buildCourseItem("اللغة العربية"),
                  _buildCourseItem("اللغة الإنجليزية"),
                  _buildCourseItem("اللغة الألمانية"),
                  _buildCourseItem("لغات البرمجة"),
                ],
              ),

              const SizedBox(height: 34), // زاد 4px

              Text(
                "المناهج",
                style: TextStyle(
                  fontSize: 24, // زاد 4px
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
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18), // زاد 4px
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18, // زاد 4px
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    const SizedBox(height: 19), // زاد 4px

                    GestureDetector(
                      onTap: () {
                        final phone = phoneController.text.trim();
                        if (Validators.validateKuwaitPhone(phone) == null) {
                          context.read<CommRequestCubit>().sendRequest(phone);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("❌ أدخل رقم هاتف صحيح"),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4), // زاد 1px
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xffa76433), Color(0xff4f2349)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(19), // زاد 4px
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(19), // زاد 4px
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 28, 31, 48),
                            borderRadius: BorderRadius.circular(19), // زاد 4px
                          ),
                          child:
                              BlocBuilder<CommRequestCubit, CommRequestState>(
                                builder: (context, state) {
                                  if (state is CommRequestLoading) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    );
                                  }
                                  return Text(
                                    "ارسال",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22, // زاد 4px
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                        ),
                      ),
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

 Widget _buildSocialIcon(IconData icon, String tooltip, String url) {
  return Container(
    width: 54, // زاد 4px
    height: 54, // زاد 4px
    decoration: const BoxDecoration(
      color: Color.fromARGB(0, 42, 45, 52),
      shape: BoxShape.circle,
    ),
    child: IconButton(
      icon: Icon(icon, color: Colors.white, size: 28), // زاد 4px
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