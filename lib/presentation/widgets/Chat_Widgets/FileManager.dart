import 'dart:io';
import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FileManager {
  final Dio _dio = Dio();

  String buildImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return "";
    if (imagePath.startsWith('https://') || imagePath.startsWith('http://')) {
      return imagePath;
    }

    if (imagePath.startsWith('file://')) {
      imagePath = imagePath.substring(7);
    }
    if (imagePath.startsWith('file:')) {
      imagePath = imagePath.substring(5);
    }

    const String baseUrl = 'https://cdn.primeacademy.education/primeacademy';

    return imagePath.startsWith('/')
        ? '$baseUrl$imagePath'
        : '$baseUrl/$imagePath';
  }

  bool isValidUrl(String url) {
    if (url.isEmpty) return false;
    try {
      final uri = Uri.tryParse(url);
      return uri != null &&
          uri.hasAbsolutePath &&
          (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  bool canOpenInBrowser(String url) {
    final lowerUrl = url.toLowerCase();
    return lowerUrl.contains('.pdf') ||
        lowerUrl.contains('.jpg') ||
        lowerUrl.contains('.jpeg') ||
        lowerUrl.contains('.png') ||
        lowerUrl.contains('.gif');
  }

  Future<void> openInBrowser(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'لا يمكن فتح الرابط';
    }
  }

  // Future<Directory?> getDownloadDirectory() async {
  //   if (Platform.isAndroid) {
  //     List<String> possiblePaths = [
  //       '/storage/emulated/0/Download',
  //       '/storage/emulated/0/Downloads',
  //     ];

  //     for (String path in possiblePaths) {
  //       Directory dir = Directory(path);
  //       if (dir.existsSync()) {
  //         return dir;
  //       }
  //     }

  //     return await getExternalStorageDirectory();
  //   } else {
  //     return await getApplicationDocumentsDirectory();
  //   }
  // }
Future<Directory?> getDownloadDirectory() async {
  if (Platform.isAndroid) {
    
    return await getExternalStorageDirectory();
  } else {
    return await getApplicationDocumentsDirectory();
  }
}

  String getFileNameFromUrl(String url) {
    String fileName = url.split('/').last;
    if (!fileName.contains('.')) {
      fileName += '.file';
    }
    return fileName;
  }

  Future<String> downloadFile(
    String url,
    String? filename,
  ) async {
    Directory? directory = await getDownloadDirectory();
    if (directory == null) {
      throw 'لا يمكن الوصول إلى مجلد التحميل';
    }

    String fileName = filename ?? getFileNameFromUrl(url);
    String filePath = '${directory.path}/$fileName';

    File file = File(filePath);
    if (file.existsSync()) {
      return filePath;
    }

    await _dio.download(url, filePath);
    return filePath;
  }

  Future<ResultType> openLocalFile(String filePath) async {
    final result = await OpenFilex.open(filePath);
    return result.type;
  }
//   Future<ResultType> openLocalFile(String filePath) async {
//   print('📂 Trying to open file at: $filePath');

//   final file = File(filePath);
//   print('📦 File exists: ${file.existsSync()}');
//   print('📏 File size: ${file.existsSync() ? file.lengthSync() : 0} bytes');

//   final result = await OpenFilex.open(filePath);
//   print('📱 OpenFilex result: ${result.type}');

//   return result.type;
// }

}