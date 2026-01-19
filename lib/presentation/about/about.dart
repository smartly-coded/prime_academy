import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/presentation/widgets/splashWidgets/build_text_withoutImage.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1024;
    final isDesktop = width >= 1024;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: isDesktop ? 64 : (isTablet ? 48 : 32),
          horizontal: isMobile ? 16 : (isTablet ? 32 : 48),
        ),
        color: const Color(0xFF0f1217),
        child: Column(
          children: [
            // 1. Main Title "من نحن"
            _buildMainTitle(context, width),

            SizedBox(height: isDesktop ? 80 : (isTablet ? 60 : 48)),

            // 2. Text Content (كل المحتوى النصي)
            Container(
              constraints: BoxConstraints(
                maxWidth: isDesktop ? 1200 : double.infinity,
              ),
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 16),
              child: _buildTextContent(width, context),
            ),

            SizedBox(height: isDesktop ? 80 : (isTablet ? 60 : 48)),

            // 3. Image and Stats (الصورة والدوائر)
            Container(
              constraints: BoxConstraints(
                maxWidth: isDesktop ? 1200 : double.infinity,
              ),
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 16),
              child: _buildImageAndStats(width),
            ),

            SizedBox(height: isDesktop ? 64 : (isTablet ? 48 : 32)),
          ],
        ),
      ),
    );
  }

  // Main Title "من نحن"
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
        "من نحن",
        "",
        context,
        containerWidth: titleWidth,
        containerHeight: titleHeight,
        isBold: true,
        fontSize: titleFontSize,
      ),
    );
  }

  // Text Content Column
  Widget _buildTextContent(double width, BuildContext context) {
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1024;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end, // RTL
      children: [
        // "برايم أكاديمي" subtitle
        Text(
          "برايم أكاديـمي",
          style: TextStyle(
            fontSize: isMobile ? 18 : (isTablet ? 19 : 20),
            fontWeight: FontWeight.w600,
            color: const Color(0xFFff9933),
          ),
        ),

        SizedBox(height: isMobile ? 20 : 24),

        // "نبذة عنا" section
        _buildSectionHeader("نبذة عنا", context: context, width: width),

        SizedBox(height: isMobile ? 20 : 24),

        Text(
          "المنصات التعليميه كثيره ومتعدده ولكن في برايم اكاديمي نقدم محتوي مختلف تماما عن طريق اتباع افضل الطرق الحديثه في توصيل المعلومات واتباع انظمه الذكاء الاصطناعي التي تجذب الطلاب نحو المذاكره والتفوق والتطور",
          style: TextStyle(
            fontSize: isMobile ? 14 : 15,
            color: Colors.white,
            height: 1.5,
          ),
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
        ),

        SizedBox(height: isMobile ? 20 : 24),

        _buildSectionHeader(
          "انظمة برايم اكاديمي المبتكرة",
          fullWidth: true,
          centered: true,
          context: context,
          width: width,
        ),

        SizedBox(height: isMobile ? 20 : 24),

        // Feature Items
        _buildFeatureItem(
          number: 1,
          iconAsset: 'assets/icons/person_laptop.svg',
          title: "(1) نظام الدوري التعليمي",
          description:
              "وهو نظام يتيح للطلاب التنافس من خلال المعلومات الذين يكتسبونها من مُعلمين برايم اكاديمي وبالتالي تذداد ثقتهم في انفسهم ويُساعدهم هذا النظام علي التأقلم علي جو الامتحانات وكسر التوتر الذي يصاحبهم اثناء تواجدهم في اللجنه",
          width: width,
        ),

        SizedBox(height: isMobile ? 20 : 24),

        _buildFeatureItem(
          number: 2,
          iconAsset: 'assets/icons/camera.svg',
          title: "(2) الحصص المسجله واوراق العمل",
          description:
              "يقوم المعلم بتسجيل الحصه ووضعها علي بروفايل الطالب حتي يكون مرجعا له في أي وقت بالاضافه الي أوراق العمل الذي يبتكرها المعلم بأسلوبه السهل والبسيط حتي يساعد الطالب علي المذاكره بشكل بسيط وسهل ويراعي المعلم وضع كل أفكار الامتحانات في أوراق العمل حتي نضمن للطالب العلامه الكامل",
          width: width,
        ),

        SizedBox(height: isMobile ? 20 : 24),

        _buildFeatureItem(
          number: 3,
          iconAsset: 'assets/icons/person_mark.svg',
          title: "(3) نظام المتابعه المستمره",
          description:
              "يقوم المعلم بتصحيح الواجبات ومتابعه الطلاب عبر المنصه وجروب الواتساب الخاص بالمجموعه حتي يبقي المعلم مع الطالب في كل الأوقات وليس وقت الحصه فقط",
          width: width,
        ),

        SizedBox(height: isMobile ? 20 : 24),

        _buildFeatureItem(
          number: 4,
          iconAsset: 'assets/icons/notes.svg',
          title: "(4) الاداره والسيكرتاريه",
          description:
              "تتميز اداره وسيكرتاريه برايم اكاديمي بالتعاون الدائم والمستمر والرد علي جميع الاسأله في الحال وتسهيل أي عقبات لاولياء الأمور والطلاب",
          width: width,
        ),
      ],
    );
  }

  // Section Header with gradient border
  Widget _buildSectionHeader(
    String text, {
    bool fullWidth = false,
    bool centered = false,
    required BuildContext context,
    required double width,
  }) {
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1024;

    return buildTextWithBorder(
      text,
      "",
      context,
      containerWidth: fullWidth ? double.infinity : null,
      containerHeight: isMobile ? 48 : (isTablet ? 52 : 56),
      fontSize: isMobile ? 16 : (isTablet ? 18 : 20),
      isBold: false,
    );
  }

  // Feature Item
  Widget _buildFeatureItem({
    required int number,
    required String iconAsset,
    required String title,
    required String description,
    required double width,
  }) {
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1024;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Icon and Title Row
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: isMobile ? 16 : (isTablet ? 17 : 18),
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
            ),
            SizedBox(width: isMobile ? 8 : 12),
            // SVG Icon
            SvgPicture.asset(
              iconAsset,
              width: isMobile ? 22 : 25,
              height: isMobile ? 22 : 25,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),

        SizedBox(height: isMobile ? 8 : 12),

        // Description
        Text(
          description,
          style: TextStyle(
            fontSize: isMobile ? 14 : 15,
            color: Colors.white,
            height: 1.5,
          ),
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }

  // Image and Stats Column
  Widget _buildImageAndStats(double width) {
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
      imageWidth = 523;
      imageHeight = 443;
    }

    return Column(
      children: [
        // GIF Image
        Container(
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
        ),

        SizedBox(height: isMobile ? 32 : (isTablet ? 40 : 48)),

        // Stats Grid (2x2)
        Container(
          constraints: BoxConstraints(
            maxWidth: isMobile ? width * 0.9 : (isTablet ? 450 : 500),
          ),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: isMobile ? 16 : (isTablet ? 20 : 24),
            crossAxisSpacing: isMobile ? 16 : (isTablet ? 20 : 24),
            childAspectRatio: isMobile ? 1.0 : 0.9,
            children: [
              _buildStatCircle(
                iconAsset: 'assets/icons/person_with_cap.svg',
                label: "نتايج الطلاب",
                width: width,
              ),
              _buildStatCircle(
                iconAsset: 'assets/icons/person_laptop.svg',
                label: "كفاءة المعلمين",
                width: width,
              ),
              _buildStatCircle(
                iconAsset: 'assets/icons/chat_buble.svg',
                label: "مهارات التواصل",
                width: width,
              ),
              _buildStatCircle(
                iconAsset: 'assets/icons/multiple_user_settings.svg',
                label: "الالكفاءة الادارية",
                width: width,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Stat Circle with SVG-like border
  Widget _buildStatCircle({
    required String iconAsset,
    required String label,
    required double width,
  }) {
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1024;

    double circleSize = isMobile ? 110 : (isTablet ? 125 : 140);
    double innerCircleSize = circleSize - 10;
    double iconSize = isMobile ? 35 : (isTablet ? 40 : 45);
    double fontSize = isMobile ? 20 : (isTablet ? 22 : 24);
    double labelFontSize = isMobile ? 15 : (isTablet ? 16 : 18);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Circle with gradient border
        SizedBox(
          width: circleSize,
          height: circleSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle (gray)
              Container(
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.397),
                    width: isMobile ? 14 : 17,
                  ),
                ),
              ),

              // Gradient circle (full)
              Container(
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 0),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF9933), Color(0xFF450486)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: CustomPaint(
                  painter: _CirclePainter(strokeWidth: isMobile ? 12 : 15),
                ),
              ),

              // Inner content circle
              Container(
                width: innerCircleSize,
                height: innerCircleSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF222633),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      iconAsset,
                      width: iconSize,
                      height: iconSize,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(height: isMobile ? 2 : 4),
                    Text(
                      "100%",
                      style: TextStyle(fontSize: fontSize, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: isMobile ? 6 : 8),

        // Label
        SizedBox(
          width: circleSize,
          child: Text(
            label,
            style: TextStyle(fontSize: labelFontSize, color: Colors.white),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// Custom painter for gradient circle border
class _CirclePainter extends CustomPainter {
  final double strokeWidth;

  _CirclePainter({this.strokeWidth = 15});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFF9933), Color(0xFF450486)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
