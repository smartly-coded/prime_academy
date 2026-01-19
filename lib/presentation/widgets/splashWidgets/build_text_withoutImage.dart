import 'dart:ui';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/build_text.dart';

class GradientBorderPainter extends CustomPainter {
  final Color startColor;
  final Color endColor;
  final double borderWidth;
  final double borderRadius;
  final double gradientRadiusMultiplier;
  final bool isFlipped;

  GradientBorderPainter({
    required this.startColor,
    required this.endColor,
    this.borderWidth = 2.0,
    this.borderRadius = 12.0,
    this.gradientRadiusMultiplier = 1.6,
    this.isFlipped = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) return;

    final double diagonal = math.sqrt(
      math.pow(size.width, 2) + math.pow(size.height, 2),
    );

    final RRect borderRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    if (!isFlipped) {
      final Shader orangeGradientBL = ui.Gradient.radial(
        Offset(0, size.height), 
        diagonal * 1.7, 
        [
          startColor.withOpacity(1.0), // Full orange at center
          startColor.withOpacity(0.8), // Strong orange
          startColor.withOpacity(0.5), // Medium orange
          startColor.withOpacity(0.25), // Weak orange
          startColor.withOpacity(0.1), // Very weak orange
          startColor.withOpacity(0.0),
        ],
        [0.0, 0.15, 0.35, 0.55, 0.75, 1.0],
      );

      canvas.drawRRect(
        borderRect,
        Paint()
          ..shader = orangeGradientBL
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );

      final Shader purpleGradientTR = ui.Gradient.radial(
        Offset(size.width, 0), 
        diagonal * 0.85,
        [
          endColor.withOpacity(1.0),
          endColor.withOpacity(0.75),
          endColor.withOpacity(0.5),
          endColor.withOpacity(0.25),
          endColor.withOpacity(0.0),
        ],
        [0.0, 0.25, 0.5, 0.75, 1.0],
      );

      canvas.drawRRect(
        borderRect,
        Paint()
          ..shader = purpleGradientTR
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..blendMode = BlendMode.plus, 
      );

      final Shader purpleGradientTL = ui.Gradient.radial(
        Offset(0, 0), 
        diagonal * 0.7,
        [
          endColor.withOpacity(1.0),
          endColor.withOpacity(0.5),
          endColor.withOpacity(0.3),
          endColor.withOpacity(0.15),
          endColor.withOpacity(0.0),
        ],
        [0.0, 0.5, 0.5, 0.75, 1.0],
      );

      canvas.drawRRect(
        borderRect,
        Paint()
          ..shader = purpleGradientTL
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..blendMode = BlendMode.plus,
      );

      final Shader purpleGradientBR = ui.Gradient.radial(
        Offset(size.width, size.height), 
        diagonal * 0.75,
        [
          endColor.withOpacity(0.5),
          endColor.withOpacity(0.5),
          endColor.withOpacity(0.3),
          endColor.withOpacity(0.15),
          endColor.withOpacity(0.0),
        ],
        [0.0, 0.3, 0.5, 0.75, 1.0],
      );

      canvas.drawRRect(
        borderRect,
        Paint()
          ..shader = purpleGradientBR
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..blendMode = BlendMode.plus,
      );
    } else {

      final Shader purpleGradientBL = ui.Gradient.radial(
        Offset(0, size.height),
        diagonal * 1.2,
        [
          endColor.withOpacity(1.0),
          endColor.withOpacity(0.8),
          endColor.withOpacity(0.5),
          endColor.withOpacity(0.25),
          endColor.withOpacity(0.1),
          endColor.withOpacity(0.0),
        ],
        [0.0, 0.15, 0.35, 0.55, 0.75, 1.0],
      );

      canvas.drawRRect(
        borderRect,
        Paint()
          ..shader = purpleGradientBL
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );

      final Shader orangeGradientTR = ui.Gradient.radial(
        Offset(size.width, 0),
        diagonal * 0.85,
        [
          startColor.withOpacity(0.8),
          startColor.withOpacity(0.65),
          startColor.withOpacity(0.45),
          startColor.withOpacity(0.25),
          startColor.withOpacity(0.0),
        ],
        [0.0, 0.25, 0.5, 0.75, 1.0],
      );

      canvas.drawRRect(
        borderRect,
        Paint()
          ..shader = orangeGradientTR
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..blendMode = BlendMode.plus,
      );

      final Shader orangeGradientTL = ui.Gradient.radial(
        Offset(0, 0),
        diagonal * 0.7,
        [
          startColor.withOpacity(0.7),
          startColor.withOpacity(0.5),
          startColor.withOpacity(0.3),
          startColor.withOpacity(0.15),
          startColor.withOpacity(0.0),
        ],
        [0.0, 0.3, 0.5, 0.75, 1.0],
      );

      canvas.drawRRect(
        borderRect,
        Paint()
          ..shader = orangeGradientTL
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..blendMode = BlendMode.plus,
      );

      final Shader orangeGradientBR = ui.Gradient.radial(
        Offset(size.width, size.height),
        diagonal * 0.75,
        [
          startColor.withOpacity(0.7),
          startColor.withOpacity(0.5),
          startColor.withOpacity(0.3),
          startColor.withOpacity(0.15),
          startColor.withOpacity(0.0),
        ],
        [0.0, 0.3, 0.5, 0.75, 1.0],
      );

      canvas.drawRRect(
        borderRect,
        Paint()
          ..shader = orangeGradientBR
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..blendMode = BlendMode.plus,
      );
    }

   
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant GradientBorderPainter oldDelegate) {
    return oldDelegate.startColor != startColor ||
        oldDelegate.endColor != endColor ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.gradientRadiusMultiplier != gradientRadiusMultiplier ||
        oldDelegate.isFlipped != isFlipped;
  }
}

Widget buildTextWithBorder(
  String mainTitle,
  String subTitle,
  BuildContext context, {
  double? containerWidth,
  double? containerHeight,
  bool? isBold,
  double? fontSize,
}) {
  double defaultWidth =
      containerWidth ?? MediaQuery.of(context).size.width * 0.5;
  final gradientFlipped = ValueNotifier<bool>(false);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Align(
        alignment: Alignment.center,
        child: ValueListenableBuilder<bool>(
          valueListenable: gradientFlipped,
          builder: (context, isFlipped, _) {
            return GestureDetector(
              onTap: () {
                gradientFlipped.value = !gradientFlipped.value;
              },
              child: SizedBox(
                width: defaultWidth,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final height = containerHeight ?? 54.0;

                    return Container(
                      width: width,
                      height: height,
                      child: CustomPaint(
                        size: Size(width, height),
                        painter: GradientBorderPainter(
                          startColor: const Color(0xFFFF9933),
                          endColor: const Color(0xFF450486), 
                          borderWidth: 2.0,
                          borderRadius: 12.0,
                          gradientRadiusMultiplier: 1.6,
                          isFlipped: isFlipped,
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 11,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF222633),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              mainTitle,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize:
                                    fontSize ?? _getResponsiveFontSize(context),
                                fontWeight: (isBold ?? false)
                                    ? FontWeight.normal
                                    : FontWeight.w500,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 10),
      RichText(
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        text: TextSpan(
          children: [
            TextSpan(
              text: subTitle,
              style: TextStyle(
                fontSize: getResponsiveFontSize(context, fontSize: 17),
                color: Colors.white,
                fontFamily: 'Bahij',
                height: 1.3,
              ),
            ),
            const TextSpan(text: " "),
          ],
        ),
      ),
      const SizedBox(height: 24),
    ],
  );
}

double _getResponsiveFontSize(BuildContext context) {
  final width = MediaQuery.of(context).size.width;

  if (width < 640) return 20;

  if (width >= 600 && width < 768) return 18;

  
  if (width >= 768 && width < 1024) return 22;

  
  return 36;
}
