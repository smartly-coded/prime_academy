import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prime_academy/core/Utils/validators.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/contact_us/data/models/inquery_model.dart';
import 'package:prime_academy/features/contact_us/logic/inquery_cubit.dart';
import 'package:prime_academy/features/contact_us/logic/inquiry_state.dart';
import 'package:prime_academy/presentation/widgets/splashWidgets/build_text_withoutImage.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  ContactUsPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1024;
    final isDesktop = width >= 1024;

    return BlocConsumer<ContactUsCubit, ContactUsState>(
      listener: (context, state) {
        if (state is ContactUsSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تم إرسال الرسالة بنجاح ✅")),
          );
          _nameController.clear();
          _phoneController.clear();
          _messageController.clear();
        } else if (state is ContactUsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("فشل الإرسال: ${state.message}")),
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: isDesktop ? 96 : (isTablet ? 64 : 48),
              horizontal: isMobile ? 16 : (isTablet ? 32 : 48),
            ),
            color: const Color(0xFF0f1217),
            child: Column(
              children: [
                // Main Title "تواصل معنا"
                _buildMainTitle(context, width),

                SizedBox(height: isDesktop ? 64 : (isTablet ? 48 : 40)),

                // "لديك أي أسئلة؟" and description
                _buildHeaderSection(width),

                SizedBox(height: isDesktop ? 64 : (isTablet ? 48 : 40)),

                // Form and Image Grid
                Container(
                  constraints: BoxConstraints(
                    maxWidth: isDesktop ? 1200 : double.infinity,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 16),
                  child: isDesktop
                      ? Row(
                          // Desktop: GIF على اليمين، Form على الشمال
                          crossAxisAlignment: CrossAxisAlignment.start,
                          textDirection: TextDirection.rtl, // ✅ RTL
                          children: [
                            // GIF على اليمين
                            Expanded(flex: 5, child: _buildGifImage(width)),
                            const SizedBox(width: 48),
                            // Form على الشمال
                            Expanded(
                              flex: 6,
                              child: _buildForm(context, state, width),
                            ),
                          ],
                        )
                      : Column(
                          // Mobile/Tablet: Stacked
                          children: [
                            _buildGifImage(width),
                            SizedBox(height: isTablet ? 40 : 32),
                            _buildForm(context, state, width),
                          ],
                        ),
                ),

                SizedBox(height: isDesktop ? 80 : (isTablet ? 64 : 48)),

                // Social Media Section
                _buildSocialSection(width),
              ],
            ),
          ),
        );
      },
    );
  }

  // Main Title "تواصل معنا"
  Widget _buildMainTitle(BuildContext context, double width) {
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1024;

    double titleWidth;
    double titleHeight;
    double titleFontSize;

    if (isMobile) {
      titleWidth = width * 0.85;
      titleHeight = 100;
      titleFontSize = 28;
    } else if (isTablet) {
      titleWidth = width * 0.6;
      titleHeight = 120;
      titleFontSize = 36;
    } else {
      titleWidth = width * 0.4;
      titleHeight = 140;
      titleFontSize = 48;
    }

    return Center(
      child: buildTextWithBorder(
        "تواصل معنا",
        "",
        context,
        containerWidth: titleWidth,
        containerHeight: titleHeight,
        isBold: true,
        fontSize: titleFontSize,
      ),
    );
  }

  // Header Section (Question + Description)
  Widget _buildHeaderSection(double width) {
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1024;

    return Column(
      children: [
        Text(
          "لديك أي أسئلة ؟",
          style: TextStyle(
            fontSize: isMobile ? 22 : (isTablet ? 28 : 32),
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isMobile ? 12 : 16),
        Container(
          width: isMobile ? width * 0.9 : (isTablet ? 500 : 650),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "نحن هنا لدعمك والإجابة على جميع استفساراتك واحتياجاتك التعليمية. لا تتردد في الاتصال بنا للحصول على المساعدة وتقديم ملاحظاتك",
            style: TextStyle(
              fontSize: isMobile ? 15 : (isTablet ? 16 : 17),
              color: Colors.white,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
        ),
      ],
    );
  }

  // Form
  Widget _buildForm(BuildContext context, ContactUsState state, double width) {
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1024;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Name and Phone Row
          isMobile
              ? Column(
                  children: [
                    _buildInputField(
                      controller: _nameController,
                      placeholder: "اسمك بالكامل",
                      icon: Icons.person,
                      validator: Validators.validateFullName,
                      width: width,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller: _phoneController,
                      placeholder: "رقم هاتفك المحمول",
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: Validators.validateKuwaitPhone,
                      width: width,
                    ),
                  ],
                )
              : Row(
                  textDirection: TextDirection.rtl, // ✅ RTL
                  children: [
                    Expanded(
                      child: _buildInputField(
                        controller: _nameController,
                        placeholder: "اسمك بالكامل",
                        icon: Icons.person,
                        validator: Validators.validateFullName,
                        width: width,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInputField(
                        controller: _phoneController,
                        placeholder: "رقم هاتفك المحمول",
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: Validators.validateKuwaitPhone,
                        width: width,
                      ),
                    ),
                  ],
                ),

          SizedBox(height: isTablet ? 20 : 16),

          // Message Field
          _buildTextareaField(
            controller: _messageController,
            placeholder: "اكتب رسالتك",
            validator: Validators.validateMessage,
            width: width,
          ),

          SizedBox(height: isTablet ? 28 : 24),

          // Send Button
          _buildSendButton(context, state, width),
        ],
      ),
    );
  }

  // Input Field with Icon
  Widget _buildInputField({
    required TextEditingController controller,
    required String placeholder,
    required IconData icon,
    required double width,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1024;

    return Container(
      height: isMobile ? 50 : (isTablet ? 54 : 58),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 1.6),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 12),
              child: Icon(
                icon,
                size: isMobile ? 18 : 20,
                color: const Color(0xFF9CA3AF),
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: placeholder,
                  hintTextDirection: TextDirection.rtl,
                  hintStyle: TextStyle(
                    color: const Color(0xFF6B7280),
                    fontSize: isMobile ? 13 : 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 8 : 12,
                    vertical: isMobile ? 12 : 16,
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 13 : 14,
                ),
                validator: validator,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Textarea Field
  Widget _buildTextareaField({
    required TextEditingController controller,
    required String placeholder,
    required double width,
    String? Function(String?)? validator,
  }) {
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1024;

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                right: isMobile ? 10 : 12,
                left: isMobile ? 10 : 12,
                top: isMobile ? 16 : 20,
              ),
              child: Icon(
                Icons.send,
                size: isMobile ? 18 : 20,
                color: const Color(0xFF9CA3AF),
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: controller,
                maxLines: isMobile ? 4 : 5,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: placeholder,
                  hintTextDirection: TextDirection.rtl,
                  hintStyle: TextStyle(
                    color: const Color(0xFF6B7280),
                    fontSize: isMobile ? 13 : 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 8 : 12,
                    vertical: isMobile ? 12 : 16,
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 13 : 14,
                ),
                validator: validator,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Send Button
  Widget _buildSendButton(
    BuildContext context,
    ContactUsState state,
    double width,
  ) {
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1024;

    return GestureDetector(
      onTap: state is ContactUsLoading
          ? null
          : () {
              if (_formKey.currentState?.validate() ?? false) {
                final request = InquiryRequest(
                  fullname: _nameController.text.trim(),
                  phoneNumber: _phoneController.text.trim(),
                  content: _messageController.text.trim(),
                );
                context.read<ContactUsCubit>().sendInquiry(request);
              }
            },
      child: state is ContactUsLoading
          ? Container(
              height: isMobile ? 50 : (isTablet ? 54 : 58),
              decoration: BoxDecoration(
                color: const Color(0xFF222633),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFF9933), width: 2),
              ),
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              ),
            )
          : buildTextWithBorder(
              "إرسال",
              "",
              context,
              containerWidth: double.infinity,
              containerHeight: isMobile ? 50 : (isTablet ? 54 : 58),
              fontSize: isMobile ? 18 : (isTablet ? 20 : 22),
              isBold: true,
            ),
    );
  }

  // GIF Image
  Widget _buildGifImage(double width) {
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1024;

    double imageWidth;
    double imageHeight;

    if (isMobile) {
      imageWidth = width * 0.7;
      imageHeight = imageWidth * 0.84; // maintain aspect ratio
    } else if (isTablet) {
      imageWidth = width * 0.7;
      imageHeight = imageWidth * 0.84;
    } else {
      imageWidth = 500;
      imageHeight = 420;
    }

    return Container(
      width: imageWidth * 1.5,
      height: imageHeight,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          "https://cdn.primeacademy.education/primeacademy/uploads/All-About-Me-Story-Book-Video-in-Peach-Dark-Blue-Orange-Illustrative-Style.gif",
          width: imageWidth,
          height: imageHeight,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFF222633),
              child: const Center(
                child: Icon(Icons.image, size: 50, color: Colors.white38),
              ),
            );
          },
        ),
      ),
    );
  }

  // Social Media Section
  Widget _buildSocialSection(double width) {
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1024;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: isMobile ? double.infinity : (isTablet ? 700 : 900),
      ),
      margin: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 16),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9933), Color(0xFF450486)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF060709),
            blurRadius: 15,
            offset: const Offset(7, 7),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : (isTablet ? 40 : 50),
          vertical: isMobile ? 32 : (isTablet ? 40 : 50),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF222633),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Text(
              "او راسلنا عبر مواقع التواصل الاجتماعي",
              style: TextStyle(
                fontSize: isMobile ? 16 : (isTablet ? 20 : 24),
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: isMobile ? 24 : 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIcon(
                  FontAwesomeIcons.whatsapp,
                  Colors.green,
                  'https://api.whatsapp.com/send/?phone=96556651979',
                  width,
                ),
                SizedBox(width: isMobile ? 12 : 16),
                _buildSocialIcon(
                  FontAwesomeIcons.instagram,
                  null,
                  'https://www.instagram.com/primeacademy4insta/',
                  width,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFF58529),
                      Color(0xFFE1306C),
                      Color(0xFF5B51D8),
                    ],
                  ),
                ),
                SizedBox(width: isMobile ? 12 : 16),
                _buildSocialIcon(
                  FontAwesomeIcons.facebookF,
                  const Color(0xFF1877F2),
                  'https://www.facebook.com/primeacademy.co',
                  width,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Social Icon Button
  Widget _buildSocialIcon(
    IconData icon,
    Color? backgroundColor,
    String url,
    double width, {
    Gradient? gradient,
  }) {
    final isMobile = width < 768;
    final iconSize = isMobile ? 40.0 : 45.0;
    final iconInnerSize = isMobile ? 26.0 : 30.0;

    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Container(
        width: iconSize,
        height: iconSize,
        decoration: BoxDecoration(
          color: backgroundColor,
          gradient: gradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (backgroundColor ?? Colors.purple).withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: FaIcon(icon, color: Colors.white, size: iconInnerSize),
        ),
      ),
    );
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      print('Could not launch $urlString');
    }
  }
}
