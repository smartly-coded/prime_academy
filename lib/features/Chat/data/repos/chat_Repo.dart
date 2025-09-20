import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:prime_academy/core/networking/api_constants.dart';
import 'package:prime_academy/core/networking/dio_factory.dart';
import 'package:prime_academy/features/Chat/data/models/chatModel.dart';

class ChatRepo {
  final Dio _dio = DioFactory.getDio();

  Future<List<MessageModel>> getMessages(int chatId, {int page = 1}) async {
    final response = await _dio.get(
      '${ApiConstants.apiBaseUrl}chats/$chatId',
      queryParameters: {"page": page},
    );
    final data = response.data as List<dynamic>;
    return data.map((json) => MessageModel.fromJson(json)).toList();
  }

  Future<MessageModel> sendMessage(int chatId, String text) async {
    final response = await _dio.post(
      '${ApiConstants.apiBaseUrl}chats/$chatId',
      data: {"message": text},
    );
    return MessageModel.fromJson(response.data);
  }

  // إرسال ملف أو تسجيل صوتي
//  Future<MessageModel> sendMedia(int chatId, File file, {String? message} ) async {
//   final fileName = file.path.split('/').last;

//   FormData formData = FormData.fromMap({
//     "message": message ?? "", // 👈 لازم يكون موجود
//     "media": await MultipartFile.fromFile(file.path, filename: fileName),
//   });

//   final response = await _dio.post(
//     '${ApiConstants.apiBaseUrl}chats/$chatId',
//     data: formData,
//     options: Options(
//       headers: {"Content-Type": "multipart/form-data"},
//     ),
//   );

//   return MessageModel.fromJson(response.data);
// }


  Future<MessageModel> editMessage(int chatId, int messageId, String newText) async {
    final response = await _dio.patch(
      '${ApiConstants.apiBaseUrl}chats/$chatId/$messageId',
      data: {"message": newText},
    );
    return MessageModel.fromJson(response.data);
  }

  Future<void> deleteMessage(int chatId, int messageId) async {
    await _dio.delete('${ApiConstants.apiBaseUrl}chats/$chatId/$messageId');
  }

 
Future<Map<String, dynamic>> getPresignedUrl(String contentType) async {
  final response = await _dio.post(
    '${ApiConstants.apiBaseUrl}r2/get-presigned-upload-url',
    data: {"contentType": contentType},
  );
  return response.data; 
}

// 2. Upload file to presigned URL
Future<void> uploadToPresignedUrl(String url, File file, String mimeType) async {
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
    throw Exception("Failed to upload file. Status code: ${response.statusCode}");
  }
}

Future<MessageModel> sendMedia(int chatId, File file, {String? message}) async {
  final mimeType = lookupMimeType(file.path) ?? "application/octet-stream";
  final presigned = await getPresignedUrl(mimeType);

  // رفع الملف للـ R2
  await uploadToPresignedUrl(presigned['url'], file, mimeType);

  final now = DateTime.now().toIso8601String();

  // نولد id محلي int
  final localId = DateTime.now().millisecondsSinceEpoch;

  // بناء جسم الرسالة زي ما الـ API متوقع
  final response = await _dio.post(
    '${ApiConstants.apiBaseUrl}chats/$chatId',
    data: {
      "message": message ?? "",
      "media": {
        "id": localId, // 👈 int
        "url": presigned['url'].toString().split('?').first, // URL بدون query
        "filename": file.path.split('/').last,
        "mime_type": mimeType,
        "size": await file.length(),
        "created_at": now,
        "updated_at": now,
        "key": presigned['key'], // 👈 نخزن الـ key هنا عشان لو عاوزين delete
      }
    },
  );

  return MessageModel.fromJson(response.data);
}

}


