

// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:prime_academy/presentation/widgets/Chat_Widgets/media_file_record.dart';

// class RecordingManager {
//   final TickerProvider vsync;
//   final Function() onStateChanged;

//   bool _isRecording = false;
//   bool _isPaused = false;
//   int _recordingTime = 0;
//   Timer? _recordingTimer;
//   AnimationController? _pulseController;
//   Animation<double>? _pulseAnimation;
//   String? _currentRecordingPath;

//   RecordingManager({
//     required this.vsync,
//     required this.onStateChanged,
//   }) {
//     _pulseController = AnimationController(
//       vsync: vsync,
//       duration: const Duration(milliseconds: 1000),
//     );
//     _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
//       CurvedAnimation(parent: _pulseController!, curve: Curves.easeInOut),
//     );
//   }

//   bool get isRecording => _isRecording;
//   bool get isPaused => _isPaused;
//   int get recordingTime => _recordingTime;
//   Animation<double>? get pulseAnimation => _pulseAnimation;

//   String get formattedTime {
//     final minutes = (_recordingTime ~/ 60).toString().padLeft(2, '0');
//     final seconds = (_recordingTime % 60).toString().padLeft(2, '0');
//     return '$minutes:$seconds';
//   }

//   Future<void> startRecording() async {
//     _currentRecordingPath = await AudioRecorderManager.startRecording();

//     if (_currentRecordingPath == null) {
//       throw 'فشل في بدء التسجيل - تأكد من أذونات الميكروفون';
//     }

//     _isRecording = true;
//     _isPaused = false;
//     _recordingTime = 0;
//     onStateChanged();

//     _pulseController?.repeat(reverse: true);
//     _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (!_isPaused) {
//         _recordingTime++;
//         onStateChanged();
//       }
//     });
//   }

//   Future<void> togglePauseResume() async {
//     if (!_isRecording) return;

//     if (_isPaused) {
//       // Resume
//       _isPaused = false;
//       _pulseController?.repeat(reverse: true);
//       await AudioRecorderManager.resumeRecording();
//     } else {
//       // Pause
//       _isPaused = true;
//       _pulseController?.stop();
//       await AudioRecorderManager.pauseRecording();
//     }
//     onStateChanged();
//   }

//   Future<void> stopRecording() async {
//     _recordingTimer?.cancel();
//     _pulseController?.stop();

//     try {
//       if (_isRecording && _currentRecordingPath != null) {
//         await AudioRecorderManager.stopRecording(_currentRecordingPath);
//       }
//     } catch (e) {
//       print('Error stopping recording: $e');
//     }

//     _isRecording = false;
//     _isPaused = false;
//     onStateChanged();
//   }

//   Future<void> cancelRecording() async {
//     await stopRecording();

//     if (_currentRecordingPath != null) {
//       try {
//         final file = File(_currentRecordingPath!);
//         if (await file.exists()) {
//           await file.delete();
//         }
//       } catch (e) {
//         print('Error deleting recording: $e');
//       }
//     }

//     _recordingTime = 0;
//     _currentRecordingPath = null;
//     onStateChanged();
//   }

//   Future<String?> finishRecording() async {
//     await stopRecording();
//     final path = _currentRecordingPath;
//     _recordingTime = 0;
//     _currentRecordingPath = null;
//     onStateChanged();
//     return path;
//   }

//   void dispose() {
//     _recordingTimer?.cancel();
//     _pulseController?.dispose();
//   }
// }


import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:prime_academy/presentation/widgets/Chat_Widgets/media_file_record.dart';

class RecordingManager {
  final TickerProvider vsync;
  final Function() onStateChanged;

  bool _isRecording = false;
  bool _isPaused = false;
  int _recordingTime = 0;
  Timer? _recordingTimer;
  AnimationController? _pulseController;
  Animation<double>? _pulseAnimation;
  String? _currentRecordingPath;
  
  // Store real-time amplitude data during recording
  List<double> _recordingAmplitudes = [];
  Timer? _amplitudeTimer;

  RecordingManager({
    required this.vsync,
    required this.onStateChanged,
  }) {
    _pulseController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1000),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController!, curve: Curves.easeInOut),
    );
  }

  bool get isRecording => _isRecording;
  bool get isPaused => _isPaused;
  int get recordingTime => _recordingTime;
  Animation<double>? get pulseAnimation => _pulseAnimation;
  List<double> get recordingAmplitudes => _recordingAmplitudes;

  String get formattedTime {
    final minutes = (_recordingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (_recordingTime % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> startRecording() async {
    _currentRecordingPath = await AudioRecorderManager.startRecording();

    if (_currentRecordingPath == null) {
      throw 'فشل في بدء التسجيل - تأكد من أذونات الميكروفون';
    }

    _isRecording = true;
    _isPaused = false;
    _recordingTime = 0;
    _recordingAmplitudes.clear();
    onStateChanged();

    _pulseController?.repeat(reverse: true);
    
    // Timer for recording time
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        _recordingTime++;
        onStateChanged();
      }
    });
    
    // Timer to capture amplitude data (10 times per second)
    _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      if (!_isPaused && _isRecording) {
        try {
          // Get current amplitude from recorder
          final amplitude = await AudioRecorderManager.getCurrentAmplitude();
          _recordingAmplitudes.add(amplitude);
          onStateChanged();
        } catch (e) {
          print('Error getting amplitude: $e');
        }
      }
    });
  }

  Future<void> togglePauseResume() async {
    if (!_isRecording) return;

    if (_isPaused) {
      // Resume
      _isPaused = false;
      _pulseController?.repeat(reverse: true);
      await AudioRecorderManager.resumeRecording();
    } else {
      // Pause
      _isPaused = true;
      _pulseController?.stop();
      await AudioRecorderManager.pauseRecording();
    }
    onStateChanged();
  }

  Future<void> stopRecording() async {
    _recordingTimer?.cancel();
    _amplitudeTimer?.cancel();
    _pulseController?.stop();

    try {
      if (_isRecording && _currentRecordingPath != null) {
        await AudioRecorderManager.stopRecording(_currentRecordingPath);
      }
    } catch (e) {
      print('Error stopping recording: $e');
    }

    _isRecording = false;
    _isPaused = false;
    onStateChanged();
  }

  Future<void> cancelRecording() async {
    await stopRecording();

    if (_currentRecordingPath != null) {
      try {
        final file = File(_currentRecordingPath!);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        print('Error deleting recording: $e');
      }
    }

    _recordingTime = 0;
    _currentRecordingPath = null;
    _recordingAmplitudes.clear();
    onStateChanged();
  }

  // Future<Map<String, dynamic>?> finishRecording() async {
  //   await stopRecording();
    
  //   if (_currentRecordingPath == null) return null;
    
  //   final result = {
  //     'path': _currentRecordingPath,
  //     'amplitudes': List<double>.from(_recordingAmplitudes),
  //     'duration': _recordingTime,
  //   };
    
  //   _recordingTime = 0;
  //   _currentRecordingPath = null;
  //   _recordingAmplitudes.clear();
  //   onStateChanged();
    
  //   return result;
  // }
  Future<Map<String, dynamic>?> finishRecording() async {
  await stopRecording();

  if (_currentRecordingPath == null) return null;

  final amplitudes = List<double>.from(_recordingAmplitudes);
  final duration = _recordingTime;

  // ⭐ خزني amplitudes وduration في ملف JSON محلي بجانب الصوت
  try {
    final jsonFile = File(_currentRecordingPath!.replaceAll('.m4a', '.json'));
    await jsonFile.writeAsString(
      jsonEncode({
        'amplitudes': amplitudes,
        'duration': duration,
      }),
    );
  } catch (e) {
    print('Error saving local waveform data: $e');
  }

  final result = {
    'path': _currentRecordingPath,
    'amplitudes': amplitudes,
    'duration': duration,
  };

  _recordingTime = 0;
  _currentRecordingPath = null;
  _recordingAmplitudes.clear();
  onStateChanged();

  return result;
}


  void dispose() {
    _recordingTimer?.cancel();
    _amplitudeTimer?.cancel();
    _pulseController?.dispose();
  }
}