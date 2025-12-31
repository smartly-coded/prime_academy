import 'package:flutter/material.dart';

class LiveWaveformPainter extends CustomPainter {
  final List<double> amplitudes;
  final bool isPaused;
  
  LiveWaveformPainter({
    required this.amplitudes,
    this.isPaused = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (amplitudes.isEmpty) return;

    final paint = Paint()
      ..color = isPaused ? Colors.grey : Colors.blue
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final middleY = size.height / 2;
    final barWidth = 2.5;
    final spacing = 3.0;
    final totalBars = (size.width / (barWidth + spacing)).floor();

    // Take the last N amplitudes to fit the width
    final displayAmplitudes = amplitudes.length > totalBars
        ? amplitudes.sublist(amplitudes.length - totalBars)
        : amplitudes;

    for (int i = 0; i < displayAmplitudes.length; i++) {
      final x = i * (barWidth + spacing);
      
      // Use actual recorded amplitude
      final amplitude = displayAmplitudes[i].clamp(0.15, 1.0);
      final barHeight = size.height * amplitude;

      canvas.drawLine(
        Offset(x, middleY - barHeight / 2),
        Offset(x, middleY + barHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(LiveWaveformPainter oldDelegate) {
    return oldDelegate.amplitudes.length != amplitudes.length ||
           oldDelegate.isPaused != isPaused;
  }
}