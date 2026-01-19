import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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
final formKey = GlobalKey<FormState>();
ValueNotifier<bool> hasError = ValueNotifier(false);
    return Container(
      color: Mycolors.backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              // Logo - Updated size to match web (200×66)
              Image.asset(
                'assets/images/footer-logo.webp',
                width: 190,
                height: 64,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 200,
                  height: 66,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Description - Updated line height to 1.3
              Text(
                "مكان التعلم الشامل والتجربة\n التعليمية المميزة، نحن نلتزم\n بتوفير بيئة تعلم محفزة تمكِّن \nالطلاب وتمنحهم الفرصة لتحقيق\n أهدافهم التعليمية والمهنية",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  color: const Color.fromARGB(
                    255,
                    207,
                    207,
                    207,
                  ), // text-text color
                  height: 1.3, // Reduced from 1.6
                ),
              ),

              const SizedBox(height: 24),

              // "Follow us" header - ADDED (was missing)
              const Text(
                "تابعنا على",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600, // font-semibold
                  color: Mycolors.orange, // text-secondary
                ),
              ),

              const SizedBox(height: 12),

              // Social Icons Row - Updated with all 5 icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIcon(
                    FontAwesomeIcons.xTwitter,
                    'X (Twitter)',
                    'https://twitter.com/primeacademy', // Update with actual URL if available
                    Colors.black,
                    Colors.white,
                    24,
                  ),
                  const SizedBox(width: 16),
                  _buildSocialIcon(
                    FontAwesomeIcons.youtube,
                    'YouTube',
                    'https://www.youtube.com/channel/UCYvdLyU752m0ln637tW540Q',
                    Colors.black,
                    Colors.white,
                    30,
                  ),
                  const SizedBox(width: 16),
                  _buildSocialIcon(
                    FontAwesomeIcons.tiktok,
                    'TikTok',
                    'https://www.tiktok.com/@primeacademy4tiktok',
                    Colors.black,
                    Colors.white,
                    26,
                  ),
                  const SizedBox(width: 16),

                  _buildSocialIcon(
                    FontAwesomeIcons.instagram,
                    'Instagram',
                    'https://www.instagram.com/primeacademy4insta/',
                    Colors.black,
                    Colors.white,
                    28,
                  ),

                  const SizedBox(width: 16),
                  _buildSocialIcon(
                    FontAwesomeIcons.facebookF,
                    'Facebook',
                    'https://www.facebook.com/primeacademy.co',
                    Colors.white,
                    Colors.black,
                    24,
                  ),
                ],
              ),

              
              const SizedBox(height: 32),

              const Text(
                "الكورسات",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600, 
                  color: Colors.white,
                ),
              ),
              const Divider(
                color: Mycolors.orange,
                thickness: 2,
                indent: 100,
                endIndent: 100,
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildCourseItem("اللغة العربية"),
                  const SizedBox(height: 16),
                  _buildCourseItem("اللغة الإنجليزية"),
                  const SizedBox(height: 16),
                  _buildCourseItem("اللغة الألمانية"),
                  const SizedBox(height: 16),
                  _buildCourseItem("لغات البرمجة"),
                ],
              ),

              const SizedBox(height: 32),

              // Curricula Section - Fixed to use Column with center alignment
              const Text(
                "المناهج",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600, // Added font-semibold
                  color: Colors.white,
                ),
              ),
              const Divider(
                color: Mycolors.orange,
                thickness: 2,
                indent: 120,
                endIndent: 120,
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildCourseItem("تأسيس"),
                  const SizedBox(height: 16),
                  _buildCourseItem("التعليم الابتدائي"),
                  const SizedBox(height: 16),
                  _buildCourseItem("التعليم المتوسط"),
                  const SizedBox(height: 16),
                  _buildCourseItem("التعليم الثانوي"),
                ],
              ),

              const SizedBox(height: 40),

              // Contact Form Section
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
                    const Text(
                      "! ابقى على تواصل",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600, // Added font-semibold
                        color: Colors.white,
                      ),
                    ),
                    const Divider(
                      color: Mycolors.orange,
                      thickness: 2,
                      indent: 60,
                      endIndent: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "للحصول على حصص مجانية \nولمتابعة اخر الاخبار ادخل رقم\n هاتفك المحمول",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 16 : 18,
                        color: Colors.white,
                        height: 1.3, 
                      ),
                    ),
                    const SizedBox(height: 24),

                    Container(
                      width: isMobile ? width * 0.55 : width * 0.65,
                      height: width * 0.08,
                      decoration: BoxDecoration(
                        color: Mycolors.backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Color(0xFFECEEF0),
                          width: 1.6,
                        ),
                      ),
                      child: TextFormField(
                        controller: phoneController,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        validator: Validators.validateKuwaitPhone,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(
                            FontAwesomeIcons.phoneFlip,
                            color: Color(0xFFB0B3BA),
                            size: 18,
                          ),
                          hintText: "رقم هاتفك المحمول",
                          hintStyle: TextStyle(
                            color: Color(0xFFB0B3BA),
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          
                          isDense: true, 
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Submit Button - Kept as requested (DO NOT CHANGE)
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
                                    ? Alignment.bottomLeft
                                    : Alignment.topRight,
                                end: isFlipped
                                    ? Alignment.topRight
                                    : Alignment.bottomLeft,
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

              const SizedBox(height: 32),
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
    Color containerColor,
    Color iconColor,
    double iconSize,
  ) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          debugPrint('Could not launch $url');
        }
      },
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          width: 35,
          height: 35,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: containerColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: FaIcon(icon, color: iconColor, size: iconSize),
          ),
        ),
      ),
    );
  }

  // NEW: Store button widget
  Widget _buildStoreButton(String assetPath, String url) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          debugPrint('Could not launch $url');
        }
      },
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 300),
        child: Image.asset(
          assetPath,
          height: 40,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'Download',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseItem(String text) {
    return Text(
      text,
      textAlign: TextAlign.center, // FIXED: Changed from end to center
      style: const TextStyle(fontSize: 18, color: Colors.white),
    );
  }
}
