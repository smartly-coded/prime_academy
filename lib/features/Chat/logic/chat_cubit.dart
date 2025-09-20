// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:prime_academy/features/Chat/data/models/chatModel.dart';
// import 'package:prime_academy/features/Chat/data/models/chat_info_model.dart';
// import 'package:prime_academy/features/Chat/data/repos/chat_Repo.dart';
// import 'package:prime_academy/features/Chat/logic/chat_state.dart';
// import 'package:prime_academy/features/authScreen/data/models/login_response.dart';

// class ChatCubit extends Cubit<ChatState> {
//   static ChatCubit? instance;

//   final ChatRepo chatRepo;
//   final int chatId;
//   final LoginResponse user;

//   List<MessageModel> messages = [];

//   ChatCubit(this.chatRepo, this.chatId, this.user) : super(ChatInitial()) {
//     instance = this;
//   }

//   Future<void> loadChat() async {
//     emit(ChatLoading());
//     try {
//       messages = await chatRepo.getMessages(chatId, page: 1);

//       // هنجهز ChatInfoModel من الـ user مباشرة
// final chatInfo = ChatInfoModel(
//   id: user.id ?? 0,
//   name: user.firstname ?? user.username ?? "طالب",
//   imageUrl: user.image?.url,
// );

//       emit(ChatLoaded(chatInfo, List.from(messages)));
//     } catch (e) {
//       emit(ChatError(e.toString()));
//     }
//   }

//   Future<void> sendMessage(String text) async {
//     if (text.trim().isEmpty) return;
//     try {
//       final message = await chatRepo.sendMessage(chatId, text);
//       messages.add(message);

//      final chatInfo = ChatInfoModel(
//   id: user.id ?? 0,
//   name: user.firstname ?? user.username ?? "طالب",
//   imageUrl: user.image?.url,
// );

//       emit(ChatLoaded(chatInfo, List.from(messages)));
//     } catch (e) {
//       emit(ChatError(e.toString()));
//     }
//   }
//   void addMessage(MessageModel message) {
//   messages.add(message);

//   final chatInfo = ChatInfoModel.fromLoginResponse(user);

//   emit(ChatLoaded(chatInfo, List.from(messages)));
// }

// Future<void> editMessage(int messageId, String newText) async {
//   try {
//     final updatedMessage =
//         await chatRepo.editMessage(chatId, messageId, newText);

//     // نعدل الميسج في الليست
//     final index = messages.indexWhere((m) => m.id == messageId);
//     if (index != -1) {
//       messages[index] = updatedMessage;
//     }

//     final chatInfo = ChatInfoModel(
//       id: user.id ?? 0,
//       name: user.firstname ?? user.username ?? "طالب",
//       imageUrl: user.image?.url,
//     );

//     emit(ChatLoaded(chatInfo, List.from(messages)));
//   } catch (e) {
//     emit(ChatError(e.toString()));
//   }
// }

// Future<void> deleteMessage(int messageId) async {
//   try {
//     await chatRepo.deleteMessage(chatId, messageId);

//     // نشيل الرسالة من الليست
//     messages.removeWhere((m) => m.id == messageId);

//     final chatInfo = ChatInfoModel(
//       id: user.id ?? 0,
//       name: user.firstname ?? user.username ?? "طالب",
//       imageUrl: user.image?.url,
//     );

//     emit(ChatLoaded(chatInfo, List.from(messages)));
//   } catch (e) {
//     emit(ChatError(e.toString()));
//   }
// }

// }

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/services/chat_eventsource.dart';
import 'package:prime_academy/features/Chat/data/models/chatModel.dart';
import 'package:prime_academy/features/Chat/data/models/chat_info_model.dart';
import 'package:prime_academy/features/Chat/data/repos/chat_repo.dart';
import 'package:prime_academy/features/Chat/logic/chat_state.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';

class ChatCubit extends Cubit<ChatState> {
  static ChatCubit? instance;

  final ChatRepo chatRepo;
  final int chatId;
  final LoginResponse user;

  List<MessageModel> messages = [];
  final SSEService _sseService = SSEService();

  ChatCubit(this.chatRepo, this.chatId, this.user) : super(ChatInitial()) {
    instance = this;
  }

  /// تحميل الرسائل القديمة + فتح الـ SSE
  Future<void> loadChat() async {
    emit(ChatLoading());
    try {
      // 1. هات الرسائل القديمة
      messages = await chatRepo.getMessages(chatId, page: 1);

      final chatInfo = ChatInfoModel.fromLoginResponse(user);

      emit(ChatLoaded(chatInfo, List.from(messages)));

      // 2. افتح SSE
      _sseService.connect(this);
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    try {
      final message = await chatRepo.sendMessage(chatId, text);
      messages.add(message);

      final chatInfo = ChatInfoModel.fromLoginResponse(user);
      emit(ChatLoaded(chatInfo, List.from(messages)));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void addMessage(MessageModel message) {
    messages.add(message);
    final chatInfo = ChatInfoModel.fromLoginResponse(user);
    emit(ChatLoaded(chatInfo, List.from(messages)));
  }

  Future<void> editMessage(int messageId, String newText) async {
    try {
      final updatedMessage = await chatRepo.editMessage(
        chatId,
        messageId,
        newText,
      );

      final index = messages.indexWhere((m) => m.id == messageId);
      if (index != -1) {
        messages[index] = updatedMessage;
      }

      final chatInfo = ChatInfoModel.fromLoginResponse(user);
      emit(ChatLoaded(chatInfo, List.from(messages)));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> deleteMessage(int messageId) async {
    try {
      await chatRepo.deleteMessage(chatId, messageId);
      messages.removeWhere((m) => m.id == messageId);

      final chatInfo = ChatInfoModel.fromLoginResponse(user);
      emit(ChatLoaded(chatInfo, List.from(messages)));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> sendMedia(File file, {String? message}) async {
    try {
      final msg = await chatRepo.sendMedia(chatId, file, message: message);
      messages.add(msg);

      final chatInfo = ChatInfoModel.fromLoginResponse(user);
      emit(ChatLoaded(chatInfo, List.from(messages)));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void closeSSE() {
    _sseService.disconnect();
  }
}
