import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/presentation/widgets/splashWidgets/build_text_withoutImage.dart';

class GifSection extends StatefulWidget {
  final String title;
  final String subtitle;
  final String gifPath;
  final String smallIconPath;

  /// جديد: width اختياري للـ title container
  final double? titleWidth;
  final Color? backgroundColor;
  final double overlapOffset;

  const GifSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.gifPath,
    required this.smallIconPath,
    this.titleWidth,
    this.backgroundColor,
    this.overlapOffset = 0,
  });

  @override
  State<GifSection> createState() => _GifSectionState();
}

class _GifSectionState extends State<GifSection>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<Offset>? _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.05, 0.08),
      end: const Offset(-0.05, -0.08),
    ).animate(CurvedAnimation(parent: _controller!, curve: Curves.easeInOut));

    _controller!.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale = (width / 400).clamp(0.7, 1.6);

    return Transform.translate(
      offset: Offset(0, -widget.overlapOffset),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 45 * scale),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          color: widget.backgroundColor ?? Mycolors.cardColor1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// العنوان
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 35 * scale,
                vertical: 12,
              ),
              child: buildTextWithBorder(
                widget.title,
                "",
                context,
                containerWidth: widget.titleWidth ?? width * 0.5,
              ),
            ),

            /// subtitle + animated icon
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5 * scale),
              child: Directionality(
                textDirection: TextDirection.rtl, // دايمًا من اليمين
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 26 * scale,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(text: widget.subtitle),
                      WidgetSpan(child: SizedBox(width: 6 * scale)),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: SlideTransition(
                          position: _offsetAnimation!,
                          child: Image.asset(
                            widget.smallIconPath,
                            width: 45 * scale,
                            height: 45 * scale,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20 * scale),

            /// GIF
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: width < 600 ? 16 : 80 * scale,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16 * scale),
                boxShadow: [
                  BoxShadow(
                    color: widget.backgroundColor ?? Mycolors.cardColor1,
                    blurRadius: 10 * scale,
                    offset: Offset(0, 4 * scale),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16 * scale),
                child: Image.asset(widget.gifPath, fit: BoxFit.cover),
              ),
            ),

            SizedBox(height: 10 * scale),
          ],
        ),
      ),
    );
  }
}
