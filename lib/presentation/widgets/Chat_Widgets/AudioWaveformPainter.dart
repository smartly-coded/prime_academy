import 'package:flutter/material.dart';

class AudioWaveformPainter extends CustomPainter {
  final double progress;
  final List<double>? waveformData;

  AudioWaveformPainter({
    this.progress = 0.0,
    this.waveformData,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final middleY = size.height / 2;
    final barWidth = 2.5;
    final spacing = 3.0;
    final totalBars = (size.width / (barWidth + spacing)).floor();

    // Use actual waveform data if available
    final amplitudes = waveformData ?? List.generate(totalBars, (i) => 0.5);
    
    // Adjust amplitudes list to match totalBars
    final displayAmplitudes = _resampleAmplitudes(amplitudes, totalBars);

    for (int i = 0; i < totalBars; i++) {
      final x = i * (barWidth + spacing);
      final normalizedProgress = progress.clamp(0.0, 1.0);
      final barProgress = i / totalBars;
      
      // Determine if this bar has been played
      final isPlayed = barProgress <= normalizedProgress;
      
      // Get amplitude for this bar
      final amplitude = i < displayAmplitudes.length 
          ? displayAmplitudes[i].clamp(0.15, 1.0)
          : 0.3;
      
      final barHeight = size.height * amplitude;

      final paint = Paint()
        ..color = isPlayed ? Colors.blue : Colors.grey.withOpacity(0.5)
        ..strokeWidth = barWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(x, middleY - barHeight / 2),
        Offset(x, middleY + barHeight / 2),
        paint,
      );
    }
  }

  List<double> _resampleAmplitudes(List<double> source, int targetCount) {
    if (source.isEmpty) return List.generate(targetCount, (i) => 0.5);
    if (source.length == targetCount) return source;
    
    final result = <double>[];
    final ratio = source.length / targetCount;
    
    for (int i = 0; i < targetCount; i++) {
      final sourceIndex = (i * ratio).floor().clamp(0, source.length - 1);
      result.add(source[sourceIndex]);
    }
    
    return result;
  }

  @override
  bool shouldRepaint(AudioWaveformPainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.waveformData != waveformData;
  }
}