import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:prime_academy/core/networking/api_constants.dart';
import 'package:prime_academy/core/networking/dio_factory.dart';
import 'package:prime_academy/features/Chat/data/models/chatModel.dart';

class ChatRepo {
  final Dio _dio = DioFactory.getDio();

  /// 1- Get Messages
  Future<List<MessageModel>> getMessages(int chatId, {int page = 1}) async {
    final response = await _dio.get(
      '${ApiConstants.apiBaseUrl}chats/$chatId',
      queryParameters: {"page": page},
    );
    final data = response.data as List<dynamic>;
    return data.map((json) => MessageModel.fromJson(json)).toList();
  }

  /// 2- Send Text Message
  Future<MessageModel> sendMessage(int chatId, String text) async {
    final response = await _dio.post(
      '${ApiConstants.apiBaseUrl}chats/$chatId',
      data: {"message": text},
    );
    return MessageModel.fromJson(response.data);
  }

  /// 3- Edit Message
  Future<MessageModel> editMessage(
    int chatId,
    int messageId,
    String newText,
  ) async {
    final response = await _dio.patch(
      '${ApiConstants.apiBaseUrl}chats/$chatId/$messageId',
      data: {"message": newText},
    );
    return MessageModel.fromJson(response.data);
  }

  /// 4- Delete Message
  Future<void> deleteMessage(int chatId, int messageId) async {
    await _dio.delete('${ApiConstants.apiBaseUrl}chats/$chatId/$messageId');
  }

  /// 5- Get Presigned Upload URL
  Future<Map<String, dynamic>> getPresignedUrl(String contentType) async {
    final response = await _dio.post(
      '${ApiConstants.apiBaseUrl}r2/get-presigned-upload-url',
      data: {"contentType": contentType},
    );
    return response.data; // { "url": "...", "key": "..." }
  }

  /// 6- Upload File To Presigned URL
  Future<void> uploadToPresignedUrl(
    String url,
    File file,
    String mimeType,
  ) async {
    final length = await file.length();

    final response = await Dio().put(
      url,
      data: file.openRead(),
      options: Options(
        headers: {
          Headers.contentTypeHeader: mimeType,
          Headers.contentLengthHeader: length,
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to upload file. Status code: ${response.statusCode}",
      );
    }
  }



  /// 7- Send Media Message (Image/Video/Audio)
  Future<MessageModel> sendMedia(
    int chatId,
    File file, {
    String? message,
  }) async {
    // تحديد MIME type بناءً على امتداد الملف
    String mimeType = _getMimeTypeForFile(file);

    // Step 1: Get presigned URL & key from backend
    final presigned = await getPresignedUrl(mimeType);
    final url = presigned['url'];
    final key = presigned['key'];

    // Step 2: Upload file to R2
    await uploadToPresignedUrl(url, file, mimeType);

    // Step 3: Build payload exactly as backend schema
    final response = await _dio.post(
      '${ApiConstants.apiBaseUrl}chats/$chatId',
      data: {
        "message": message ?? "",
        "media": {
          "key": key,
          "name": file.path.split('/').last,
          "mime_type": mimeType,
          "size": await file.length(),
        },
      },
    );


    return MessageModel.fromJson(response.data);
  }

  /// دالة مساعدة لتحديد MIME type الصحيح
  String _getMimeTypeForFile(File file) {
    final extension = file.path.toLowerCase().split('.').last;

    switch (extension) {
      // ملفات صوتية
      case 'webm':
        return 'audio/webm;codecs=opus'; // النوع المطلوب للسيرفر
      case 'aac':
        return 'audio/aac';
      case 'm4a':
        return 'audio/webm;codecs=opus';
      case 'mp3':
        return 'audio/mpeg';
      case 'wav':
        return 'audio/wav';
      case 'ogg':
        return 'audio/ogg';

      // ملفات صور
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';

      // ملفات فيديو
      case 'mp4':
        return 'video/mp4';
      case 'avi':
        return 'video/avi';
      case 'mov':
        return 'video/quicktime';
      case 'mkv':
        return 'video/x-matroska';

      // ملفات مستندات
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'txt':
        return 'text/plain';

      // افتراضي
      default:
        // استخدام lookupMimeType كخيار احتياطي
        return lookupMimeType(file.path) ?? 'application/octet-stream';
    }
  }
}
