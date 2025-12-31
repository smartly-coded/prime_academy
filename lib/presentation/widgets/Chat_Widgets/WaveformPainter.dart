// // import 'package:flutter/material.dart';
// // import 'dart:math' as math;

// // class WaveformPainter extends CustomPainter {
// //   final bool isPaused;

// //   WaveformPainter({this.isPaused = false});

// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     final paint = Paint()
// //       ..color = isPaused ? Colors.grey : Colors.blue
// //       ..strokeWidth = 2.5
// //       ..strokeCap = StrokeCap.round;

// //     final middleY = size.height / 2;
// //     final barWidth = 3.0;
// //     final spacing = 4.0;
// //     final totalBars = (size.width / (barWidth + spacing)).floor();

// //     // Use random with fixed seed for consistent pattern
// //     final random = math.Random(123);

// //     for (int i = 0; i < totalBars; i++) {
// //       final x = i * (barWidth + spacing);

// //       // Create more natural-looking waveform
// //       final sineWave = math.sin(i * 0.4) * 0.35;
// //       final cosWave = math.cos(i * 0.2) * 0.25;
// //       final randomNoise = random.nextDouble() * 0.4;

// //       final heightFactor = ((sineWave + cosWave + randomNoise) / 2 + 0.5)
// //           .clamp(0.2, 1.0);

// //       final barHeight = size.height * heightFactor;

// //       canvas.drawLine(
// //         Offset(x, middleY - barHeight / 2),
// //         Offset(x, middleY + barHeight / 2),
// //         paint,
// //       );
// //     }
// //   }

// //   @override
// //   bool shouldRepaint(WaveformPainter oldDelegate) {
// //     return oldDelegate.isPaused != isPaused;
// //   }
// // }

import 'package:flutter/material.dart';
import 'dart:math' as math;

// class WaveformPainter extends CustomPainter {
//   final bool isPaused;

//   WaveformPainter({this.isPaused = false});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = isPaused ? Colors.grey : Colors.blue
//       ..strokeWidth = 2.5
//       ..strokeCap = StrokeCap.round;

//     final middleY = size.height / 2;
//     final barWidth = 3.0;
//     final spacing = 4.0;
//     final totalBars = (size.width / (barWidth + spacing)).floor();

//     // Use random with fixed seed for consistent pattern
//     final random = math.Random(123);

//     for (int i = 0; i < totalBars; i++) {
//       final x = i * (barWidth + spacing);

//       // Create more natural-looking waveform
//       final sineWave = math.sin(i * 0.4) * 0.35;
//       final cosWave = math.cos(i * 0.2) * 0.25;
//       final randomNoise = random.nextDouble() * 0.4;

//       final heightFactor = ((sineWave + cosWave + randomNoise) / 2 + 0.5)
//           .clamp(0.2, 1.0);

//       final barHeight = size.height * heightFactor;

//       canvas.drawLine(
//         Offset(x, middleY - barHeight / 2),
//         Offset(x, middleY + barHeight / 2),
//         paint,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(WaveformPainter oldDelegate) {
//     return oldDelegate.isPaused != isPaused;
//   }
// }



class WaveformPainter extends CustomPainter {
  final List<double> amplitudes;
  final double progress;

  WaveformPainter({
    required this.amplitudes,
    this.progress = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (amplitudes.isEmpty) return;

    final playedPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final unPlayedPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final middleY = size.height / 2;
    final barWidth = 3.0;
    final spacing = 4.0;
    final maxBars = (size.width / (barWidth + spacing)).floor();

    final visible = amplitudes.length > maxBars
        ? amplitudes.sublist(amplitudes.length - maxBars)
        : amplitudes;

    for (int i = 0; i < visible.length; i++) {
      final x = i * (barWidth + spacing);
      final height = visible[i] * size.height;
      final paint =
          (i / visible.length) <= progress ? playedPaint : unPlayedPaint;

      canvas.drawLine(
        Offset(x, middleY - height / 2),
        Offset(x, middleY + height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) {
    return oldDelegate.amplitudes != amplitudes ||
        oldDelegate.progress != progress;
  }
}
