// media_file_record.dart
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

final recorder = FlutterSoundRecorder();

// اختيار الملفات
Future<File?> pickFile() async {
  final result = await FilePicker.platform.pickFiles();
  if (result != null && result.files.single.path != null) {
    return File(result.files.single.path!);
  }
  return null;
}

// بدء التسجيل
Future<String?> startRecording() async {
  final dir = await getTemporaryDirectory();
  final path =
      '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';

  await recorder.openRecorder();
  await recorder.startRecorder(toFile: path);

  return path;
}

// إيقاف التسجيل
Future<File?> stopRecording(String? path) async {
  if (path == null) return null;
  await recorder.stopRecorder();
  return File(path);
}

// دالة recordAudio الجاهزة عشان تستخدمها في ChatScreen
Future<File?> recordAudio() async {
  String? path = await startRecording();

  // هنا محتاج يضغط المستخدم مرة تانية أو نعمل UI يتحكم
  // لكن بشكل مبسط هنوقف التسجيل بعد 5 ثواني كمثال
  await Future.delayed(const Duration(seconds: 5));

  return await stopRecording(path);
}
