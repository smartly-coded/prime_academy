// media_file_record.dart
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecorderManager {
  static final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  static bool _isRecorderInitialized = false;
  static bool _isRecording = false;

  // فحص وطلب أذونات الميكروفون
  static Future<bool> checkAndRequestPermissions() async {
    try {
      // فحص إذن الميكروفون
      var microphoneStatus = await Permission.microphone.status;

      if (microphoneStatus.isDenied) {
        microphoneStatus = await Permission.microphone.request();
      }

      if (microphoneStatus.isPermanentlyDenied) {
        // توجيه المستخدم لفتح الإعدادات
        await openAppSettings();
        return false;
      }

      return microphoneStatus.isGranted;
    } catch (e) {
      print('خطأ في فحص الأذونات: $e');
      return false;
    }
  }

  // تهيئة المُسجل مع معالجة أخطاء شاملة
  static Future<bool> initRecorder() async {
    try {
      if (_isRecorderInitialized) return true;

      // فحص الأذونات أولاً
      if (!await checkAndRequestPermissions()) {
        throw 'لم يتم منح إذن الميكروفون';
      }

      // تهيئة المسجل
      await _recorder.openRecorder();

      await _recorder.setSubscriptionDuration(
        const Duration(milliseconds: 500),
      );

      _isRecorderInitialized = true;
      print('تم تهيئة المسجل بنجاح');
      return true;
    } catch (e) {
      print('خطأ في تهيئة المُسجل: $e');
      _isRecorderInitialized = false;
      return false;
    }
  }

  // بدء التسجيل مع خيارات متعددة
  static Future<String?> startRecording() async {
    try {
      // تهيئة المُسجل إذا لم يكن مُهيأ
      if (!await initRecorder()) {
        throw 'فشل في تهيئة المُسجل';
      }

      // التأكد من أن المسجل ليس يسجل بالفعل
      if (_isRecording) {
        await stopRecording(null);
      }

      final dir = await getTemporaryDirectory();

      // جرب تنسيقات مختلفة حسب المنصة والدعم المتاح
      String? path;
      Codec? codec;

      // الخيار الأول: WebM (المطلوب)
      try {
        path =
            '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.webm';
        codec = Codec.opusWebM;

        await _recorder.startRecorder(toFile: path, codec: codec);
        _isRecording = true;
        print('بدء التسجيل بـ WebM: $path');
        return path;
      } catch (e) {
        print('فشل التسجيل بـ WebM: $e');
      }

      // الخيار الثالث: MP4 (احتياطي آخر)
      try {
        path = '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        codec = Codec.aacMP4;

        await _recorder.startRecorder(toFile: path, codec: codec);
        _isRecording = true;
        print('بدء التسجيل بـ MP4: $path');
        return path;
      } catch (e) {
        print('فشل التسجيل بـ MP4: $e');
      }

      // إذا فشلت جميع الخيارات
      throw 'فشل في بدء التسجيل بجميع التنسيقات المدعومة';
    } catch (e) {
      print('خطأ في بدء التسجيل: $e');
      _isRecording = false;
      return null;
    }
  }

  // إيقاف التسجيل
  static Future<File?> stopRecording(String? path) async {
    try {
      if (!_isRecording) return null;

      await _recorder.stopRecorder();
      _isRecording = false;

      if (path != null) {
        final file = File(path);
        if (await file.exists()) {
          final fileSize = await file.length();
          print('تم حفظ التسجيل: $path (الحجم: $fileSize بايت)');

          // إذا كان الملف صغير جداً، قد يكون فارغ
          if (fileSize < 1000) {
            print('تحذير: حجم الملف صغير جداً، قد يكون التسجيل فارغ');
          }

          return file;
        } else {
          print('الملف غير موجود: $path');
        }
      }
      return null;
    } catch (e) {
      print('خطأ في إيقاف التسجيل: $e');
      _isRecording = false;
      return null;
    }
  }

  // حالة التسجيل
  static bool get isRecording => _isRecording;

  // فحص حالة المسجل
  static bool get isInitialized => _isRecorderInitialized;

  // تحرير الموارد
  static Future<void> dispose() async {
    try {
      if (_isRecording) {
        await _recorder.stopRecorder();
        _isRecording = false;
      }
      if (_isRecorderInitialized) {
        await _recorder.closeRecorder();
        _isRecorderInitialized = false;
      }
    } catch (e) {
      print('خطأ في تحرير موارد التسجيل: $e');
    }
  }

  // إعادة تعيين المسجل
  static Future<void> reset() async {
    await dispose();
    _isRecorderInitialized = false;
    _isRecording = false;
  }
}

// واجهة تسجيل محسنة مع تشخيص الأخطاء
class RecordingDialog extends StatefulWidget {
  const RecordingDialog({Key? key}) : super(key: key);

  @override
  State<RecordingDialog> createState() => _RecordingDialogState();
}

class _RecordingDialogState extends State<RecordingDialog> {
  bool _isRecording = false;
  bool _hasError = false;
  bool _isInitializing = true;
  String? _recordingPath;
  int _recordingTime = 0;
  String _statusMessage = 'جاري فحص الأذونات...';
  String? _errorDetails;

  @override
  void initState() {
    super.initState();
    _initializeAndStart();
  }

  @override
  void dispose() {
    if (_isRecording && _recordingPath != null) {
      AudioRecorderManager.stopRecording(_recordingPath);
    }
    super.dispose();
  }

  Future<void> _initializeAndStart() async {
    try {
      setState(() {
        _statusMessage = 'جاري فحص أذونات الميكروفون...';
        _isInitializing = true;
        _hasError = false;
      });

      // فحص الأذونات
      bool hasPermission =
          await AudioRecorderManager.checkAndRequestPermissions();
      if (!hasPermission) {
        setState(() {
          _hasError = true;
          _statusMessage = 'مطلوب إذن الميكروفون';
          _errorDetails = 'اذهب إلى الإعدادات وفعل إذن الميكروفون للتطبيق';
          _isInitializing = false;
        });
        return;
      }

      setState(() {
        _statusMessage = 'جاري تهيئة المسجل...';
      });

      // تهيئة المسجل
      bool initialized = await AudioRecorderManager.initRecorder();
      if (!initialized) {
        setState(() {
          _hasError = true;
          _statusMessage = 'فشل في تهيئة المسجل';
          _errorDetails = 'تأكد من أن الجهاز يدعم التسجيل الصوتي';
          _isInitializing = false;
        });
        return;
      }

      setState(() {
        _statusMessage = 'جاري بدء التسجيل...';
      });

      // بدء التسجيل
      _recordingPath = await AudioRecorderManager.startRecording();

      if (_recordingPath != null) {
        setState(() {
          _isRecording = true;
          _isInitializing = false;
          _statusMessage = 'جاري التسجيل...';
        });
        _startTimer();
      } else {
        setState(() {
          _hasError = true;
          _isInitializing = false;
          _statusMessage = 'فشل في بدء التسجيل';
          _errorDetails = 'جرب إعادة تشغيل التطبيق أو فحص إعدادات الصوت';
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isInitializing = false;
        _statusMessage = 'خطأ غير متوقع';
        _errorDetails = e.toString();
      });
    }
  }

  void _startTimer() {
    if (_isRecording) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted && _isRecording) {
          setState(() {
            _recordingTime++;
          });
          _startTimer();
        }
      });
    }
  }

  Future<void> _stopRecording() async {
    try {
      if (_recordingPath != null) {
        setState(() {
          _statusMessage = 'جاري حفظ التسجيل...';
        });

        final file = await AudioRecorderManager.stopRecording(_recordingPath);
        setState(() {
          _isRecording = false;
        });

        if (file != null) {
          // التحقق من حجم الملف
          final fileSize = await file.length();
          if (fileSize > 1000) {
            // أكثر من 1KB
            Navigator.pop(context, file);
          } else {
            setState(() {
              _hasError = true;
              _statusMessage = 'التسجيل فارغ أو تالف';
              _errorDetails = 'حجم الملف صغير جداً ($fileSize بايت)';
            });
          }
        } else {
          setState(() {
            _hasError = true;
            _statusMessage = 'فشل في حفظ التسجيل';
          });
        }
      } else {
        Navigator.pop(context, null);
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _statusMessage = 'خطأ في إيقاف التسجيل';
        _errorDetails = e.toString();
      });
    }
  }

  String get _formattedTime {
    final minutes = (_recordingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (_recordingTime % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xff1c2128),
      title: const Text(
        'تسجيل صوتي',
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _hasError
                ? Icons.error
                : _isInitializing
                ? Icons.settings
                : _isRecording
                ? Icons.mic
                : Icons.mic_off,
            color: _hasError
                ? Colors.red
                : _isInitializing
                ? Colors.orange
                : _isRecording
                ? Colors.red
                : Colors.grey,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            _isRecording ? _formattedTime : '00:00',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _statusMessage,
            style: TextStyle(color: _hasError ? Colors.red : Colors.grey),
            textAlign: TextAlign.center,
          ),
          if (_errorDetails != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _errorDetails!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          if (_isRecording && !_hasError)
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'تنسيق ذكي (WebM/AAC/MP4)',
                style: TextStyle(color: Colors.green, fontSize: 12),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_isRecording) {
              AudioRecorderManager.stopRecording(_recordingPath);
            }
            Navigator.pop(context, null);
          },
          child: const Text(
            'إلغاء',
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
        if (_isRecording && !_hasError)
          TextButton(
            onPressed: _stopRecording,
            child: const Text(
              'إيقاف وإرسال',
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
          ),
        if (_hasError)
          TextButton(
            onPressed: () {
              setState(() {
                _hasError = false;
                _recordingTime = 0;
                _errorDetails = null;
              });
              _initializeAndStart();
            },
            child: const Text(
              'إعادة محاولة',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
        if (_hasError && _statusMessage.contains('إذن'))
          TextButton(
            onPressed: () async {
              await openAppSettings();
            },
            child: const Text(
              'فتح الإعدادات',
              style: TextStyle(color: Colors.orange, fontSize: 16),
            ),
          ),
      ],
    );
  }
}

// باقي الدوال كما هي
Future<File?> pickFile() async {
  try {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  } catch (e) {
    print('خطأ في اختيار الملف: $e');
    return null;
  }
}

Future<File?> recordAudio() async {
  try {
    String? path = await AudioRecorderManager.startRecording();
    if (path == null) {
      throw 'فشل في بدء التسجيل - تأكد من أذونات الميكروفون في الإعدادات';
    }

    await Future.delayed(const Duration(seconds: 5));
    return await AudioRecorderManager.stopRecording(path);
  } catch (e) {
    print('خطأ في recordAudio: $e');
    return null;
  }
}

Future<File?> showRecordingDialog(BuildContext context) async {
  return await showDialog<File?>(
    context: context,
    barrierDismissible: false,
    builder: (context) => const RecordingDialog(),
  );
}

class AudioRecorderDisposer {
  static Future<void> disposeAll() async {
    await AudioRecorderManager.dispose();
  }
}
