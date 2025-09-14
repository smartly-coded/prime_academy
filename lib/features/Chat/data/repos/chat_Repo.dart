import 'package:dio/dio.dart';
import 'package:prime_academy/core/networking/dio_factory.dart';
import 'package:prime_academy/features/Chat/data/models/chatModel.dart';

class ChatRepo {
  final Dio _dio = DioFactory.getDio();

  Future<MessageModel> sendMessage(int chatId, String text) async {
    final response = await _dio.post(
      '/chats/$chatId',
      data: {
        "message": text,
      },
    );
    return MessageModel.fromJson(response.data['schema']);
  }
}
