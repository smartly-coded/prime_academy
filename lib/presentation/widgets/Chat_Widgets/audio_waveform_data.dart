import 'dart:typed_data';
import 'dart:io';

class AudioWaveformData {
  final List<double> amplitudes;
  final Duration duration;

  AudioWaveformData({
    required this.amplitudes,
    required this.duration,
  });

  // Generate waveform from audio file
  static Future<AudioWaveformData> fromFile(File audioFile) async {
    try {
      // Read the audio file bytes
      final bytes = await audioFile.readAsBytes();
      
      // Extract amplitude data from audio bytes
      // This is a simplified extraction - for production, use FFT or audio analysis library
      final amplitudes = _extractAmplitudes(bytes, targetSamples: 100);
      
      // Estimate duration (you should get this from actual audio metadata)
      final duration = Duration(seconds: (bytes.length / 32000).round());
      
      return AudioWaveformData(
        amplitudes: amplitudes,
        duration: duration,
      );
    } catch (e) {
      print('Error extracting waveform: $e');
      // Return default waveform on error
      return AudioWaveformData(
        amplitudes: List.generate(100, (i) => 0.5),
        duration: Duration.zero,
      );
    }
  }

  static List<double> _extractAmplitudes(Uint8List bytes, {int targetSamples = 100}) {
    if (bytes.isEmpty) return List.generate(targetSamples, (i) => 0.5);
    
    final amplitudes = <double>[];
    final samplesPerBar = (bytes.length / targetSamples).ceil();
    
    for (int i = 0; i < targetSamples; i++) {
      final start = i * samplesPerBar;
      final end = (start + samplesPerBar).clamp(0, bytes.length);
      
      if (start >= bytes.length) {
        amplitudes.add(0.2);
        continue;
      }
      
      // Calculate average amplitude for this segment
      double sum = 0;
      int count = 0;
      
      for (int j = start; j < end && j < bytes.length; j++) {
        // Convert byte to amplitude (0.0 to 1.0)
        final amplitude = (bytes[j] - 128).abs() / 128.0;
        sum += amplitude;
        count++;
      }
      
      final avgAmplitude = count > 0 ? sum / count : 0.2;
      // Normalize and ensure minimum visibility
      amplitudes.add(avgAmplitude.clamp(0.15, 1.0));
    }
    
    return amplitudes;
  }

  Map<String, dynamic> toJson() {
    return {
      'amplitudes': amplitudes,
      'duration': duration.inSeconds,
    };
  }

  factory AudioWaveformData.fromJson(Map<String, dynamic> json) {
    return AudioWaveformData(
      amplitudes: List<double>.from(json['amplitudes'] ?? []),
      duration: Duration(seconds: json['duration'] ?? 0),
    );
  }
}