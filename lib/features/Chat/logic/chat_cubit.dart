// import 'dart:io';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:prime_academy/core/services/chat_eventsource.dart';
// import 'package:prime_academy/features/Chat/data/models/chatModel.dart';
// import 'package:prime_academy/features/Chat/data/models/chat_info_model.dart';
// import 'package:prime_academy/features/Chat/data/repos/chat_repo.dart';
// import 'package:prime_academy/features/Chat/logic/chat_state.dart';
// import 'package:prime_academy/features/authScreen/data/models/login_response.dart';

// class ChatCubit extends Cubit<ChatState> {
//   static ChatCubit? instance;

//   final ChatRepo chatRepo;
//   final int chatId;
//   final LoginResponse user;
//   //int? courseId;
//   List<MessageModel> messages = [];
//   final SSEService _sseService = SSEService();

//   ChatCubit(this.chatRepo, this.chatId, this.user) : super(ChatInitial()) {
//     instance = this;
//   }

//   Future<void> loadChat() async {
//     emit(ChatLoading());
//     try {
//       messages = await chatRepo.getMessages(chatId, page: 1);

//       final chatInfo = ChatInfoModel.fromLoginResponse(user);

//       emit(ChatLoaded(chatInfo, List.from(messages)));

//       _sseService.connect(this);
//     } catch (e) {
//       emit(ChatError(e.toString()));
//     }
//   }

//   Future<void> sendMessage(String text) async {
//     if (text.trim().isEmpty) return;
//     try {
//       final message = await chatRepo.sendMessage(chatId, text);
//       messages.add(message);

//       final chatInfo = ChatInfoModel.fromLoginResponse(user);
//       emit(ChatLoaded(chatInfo, List.from(messages)));
//     } catch (e) {
//       emit(ChatError(e.toString()));
//     }
//   }

//   void addMessage(MessageModel message) {
//     messages.add(message);
//     final chatInfo = ChatInfoModel.fromLoginResponse(user);
//     emit(ChatLoaded(chatInfo, List.from(messages)));
//   }

//   Future<void> editMessage(int messageId, String newText) async {
//     try {
//       final updatedMessage = await chatRepo.editMessage(
//         chatId,
//         messageId,
//         newText,
//       );

//       final index = messages.indexWhere((m) => m.id == messageId);
//       if (index != -1) {
//         messages[index] = updatedMessage;
//       }

//       final chatInfo = ChatInfoModel.fromLoginResponse(user);
//       emit(ChatLoaded(chatInfo, List.from(messages)));
//     } catch (e) {
//       emit(ChatError(e.toString()));
//     }
//   }

//   Future<void> deleteMessage(int messageId) async {
//     try {
//       await chatRepo.deleteMessage(chatId, messageId);
//       messages.removeWhere((m) => m.id == messageId);

//       final chatInfo = ChatInfoModel.fromLoginResponse(user);
//       emit(ChatLoaded(chatInfo, List.from(messages)));
//     } catch (e) {
//       emit(ChatError(e.toString()));
//     }
//   }

// Future<void> sendMedia(
//   File file, {
//   String? message,
//   List<double>? amplitudes,
//   int? duration,
// }) async {
//   try {
//     final msg = await chatRepo.sendMedia(
//       chatId,
//       file,
//       message: message,
//       amplitudes: amplitudes,
//       duration: duration,
//     );
//     messages.add(msg);

//     final chatInfo = ChatInfoModel.fromLoginResponse(user);
//     emit(ChatLoaded(chatInfo, List.from(messages)));
//   } catch (e) {
//     emit(ChatError(e.toString()));
//   }
// }

//   void closeSSE() {
//     _sseService.disconnect();
//   }
// }

// import 'dart:io';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:prime_academy/core/services/chat_eventsource.dart';
// import 'package:prime_academy/features/Chat/data/models/chatModel.dart';
// import 'package:prime_academy/features/Chat/data/models/chat_info_model.dart';
// import 'package:prime_academy/features/Chat/data/repos/chat_repo.dart';
// import 'package:prime_academy/features/Chat/logic/chat_state.dart';
// import 'package:prime_academy/features/authScreen/data/models/login_response.dart';

// class ChatCubit extends Cubit<ChatState> {
//   static ChatCubit? instance;
//   final ChatRepo chatRepo;
//   final int chatId;
//   final LoginResponse user;

//   List<MessageModel> messages = [];
//   final SSEService _sseService = SSEService();

//   ChatCubit(this.chatRepo, this.chatId, this.user) : super(ChatInitial()) {
//     instance = this;
//   }

//   Future<void> loadChat() async {
//     // ⭐ بدل ChatLoading، emit الـ ChatInfo فوراً عشان الشاشة تفتح
//     final chatInfo = ChatInfoModel.fromLoginResponse(user);
//     emit(ChatLoaded(chatInfo, [])); // قائمة فاضية في البداية

//     try {
//       // ⭐ اعكس الرسائل بعد ما تجيبها
//       final fetchedMessages = await chatRepo.getMessages(chatId, page: 1);
//       messages = fetchedMessages.reversed.toList(); // عكس الترتيب هنا

//       emit(ChatLoaded(chatInfo, List.from(messages)));

//       _sseService.connect(this);
//     } catch (e) {
//       emit(ChatError(e.toString()));
//     }
//   }

//   Future<void> sendMessage(String text) async {
//     if (text.trim().isEmpty) return;
//     try {
//       final message = await chatRepo.sendMessage(chatId, text);
//       messages.add(message);
//       final chatInfo = ChatInfoModel.fromLoginResponse(user);
//       emit(ChatLoaded(chatInfo, List.from(messages)));
//     } catch (e) {
//       emit(ChatError(e.toString()));
//     }
//   }

//   void addMessage(MessageModel message) {
//     messages.add(message);
//     final chatInfo = ChatInfoModel.fromLoginResponse(user);
//     emit(ChatLoaded(chatInfo, List.from(messages)));
//   }

//   Future<void> editMessage(int messageId, String newText) async {
//     try {
//       final updatedMessage = await chatRepo.editMessage(
//         chatId,
//         messageId,
//         newText,
//       );
//       final index = messages.indexWhere((m) => m.id == messageId);
//       if (index != -1) {
//         messages[index] = updatedMessage;
//       }
//       final chatInfo = ChatInfoModel.fromLoginResponse(user);
//       emit(ChatLoaded(chatInfo, List.from(messages)));
//     } catch (e) {
//       emit(ChatError(e.toString()));
//     }
//   }

//   Future<void> deleteMessage(int messageId) async {
//     try {
//       await chatRepo.deleteMessage(chatId, messageId);
//       messages.removeWhere((m) => m.id == messageId);
//       final chatInfo = ChatInfoModel.fromLoginResponse(user);
//       emit(ChatLoaded(chatInfo, List.from(messages)));
//     } catch (e) {
//       emit(ChatError(e.toString()));
//     }
//   }

//   Future<void> sendMedia(
//     File file, {
//     String? message,
//     List<double>? amplitudes,
//     int? duration,
//   }) async {
//     try {
//       final msg = await chatRepo.sendMedia(
//         chatId,
//         file,
//         message: message,
//         amplitudes: amplitudes,
//         duration: duration,
//       );
//       messages.add(msg);
//       final chatInfo = ChatInfoModel.fromLoginResponse(user);
//       emit(ChatLoaded(chatInfo, List.from(messages)));
//     } catch (e) {
//       emit(ChatError(e.toString()));
//     }
//   }

//   void closeSSE() {
//     _sseService.disconnect();
//   }
// }

import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/networking/api_result.dart';
import 'package:prime_academy/core/services/chat_eventsource.dart';
import 'package:prime_academy/features/Chat/data/models/chatModel.dart';
import 'package:prime_academy/features/Chat/data/models/chat_info_model.dart';
import 'package:prime_academy/features/Chat/data/repos/chat_repo.dart';
import 'package:prime_academy/features/Chat/logic/chat_state.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/features/CoursesModules/data/repo/modules_lessons_repo.dart'; // ⭐ إضافة

class ChatCubit extends Cubit<ChatState> {
   static ChatCubit? instance;
  final ChatRepo chatRepo;
  final ModulesLessonsRepo modulesLessonsRepo; 
  final int chatId;
  final int moduleId; 
  final int courseId; 
  final LoginResponse user;

  List<MessageModel> messages = [];
  final SSEService _sseService = SSEService();

  ChatCubit( { 
    required this.chatRepo,
    required this.modulesLessonsRepo,
    required this.chatId,
    required this.moduleId,
    required this.courseId,
    required this.user,
  }) : super(ChatInitial()) {
     instance = this;
  }

  Future<void> loadChat() async {
    print('🟡 CHAT CUBIT REQUEST');
print('moduleId = $moduleId');
print('courseId = $courseId');

    // ⭐ بدل ChatLoading، emit الـ ChatInfo فوراً عشان الشاشة تفتح
    final chatInfo = ChatInfoModel.fromLoginResponse(user);
    emit(ChatLoaded(chatInfo, [])); // قائمة فاضية في البداية

    try {
      // ⭐ جيب بيانات المعلم من modules endpoint
      ChatInfoModel updatedChatInfo = chatInfo;

      try {
        final moduleResult = await modulesLessonsRepo.getModuleLessons(
  courseId, moduleId,
 
);

moduleResult.when(
  success: (moduleData) {
    print('✅ MODULE DATA: $moduleData');

    // اطبعي بيانات المعلم بالتحديد
    print('👨‍🏫 TEACHER RAW: ${moduleData.teacher}');
    print('👨‍🏫 TEACHER ID: ${moduleData.teacher?.id}');
    print('👨‍🏫 TEACHER FIRSTNAME: ${moduleData.teacher?.firstname}');
    print('👨‍🏫 TEACHER LASTNAME: ${moduleData.teacher?.lastname}');
    print('👨‍🏫 TEACHER IMAGE: ${moduleData.teacher?.image?.url}');

    if (moduleData.teacher != null) {
      updatedChatInfo = chatInfo.copyWithTeacher(moduleData.teacher!);
    } else {
      print('⚠️ teacher = null');
    }
  },
  failure: (error) {
    print(
      '❌ Failed to load teacher data: ${error.apiErrorModel.message}',
    );
  },
);

        // final moduleResult = await modulesLessonsRepo.getModuleLessons(
        //   moduleId,
        //   courseId,
        // );

        // moduleResult.when(
        //   success: (moduleData) {
        //     // ⭐ أضف بيانات المعلم للـ chatInfo
        //     updatedChatInfo = chatInfo.copyWithTeacher(moduleData.teacher);
        //   },
        //   failure: (error) {
        //     print(
        //       'Failed to load teacher data: ${error.apiErrorModel.message}',
        //     );
        //     // استمر بدون بيانات المعلم
        //   },
        // );
      } catch (e) {
        print('Error fetching teacher data: $e');
        // استمر بدون بيانات المعلم
      }

      // ⭐ اعكس الرسائل بعد ما تجيبها
      final fetchedMessages = await chatRepo.getMessages(chatId, page: 1);
      messages = fetchedMessages.reversed.toList(); // عكس الترتيب هنا

      emit(ChatLoaded(updatedChatInfo, List.from(messages)));

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
      // ⭐ استخدم الـ chatInfo من الـ state الحالي
      final currentState = state;
      if (currentState is ChatLoaded) {
        emit(ChatLoaded(currentState.chatInfo, List.from(messages)));
      }
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void addMessage(MessageModel message) {
    messages.add(message);
    // ⭐ استخدم الـ chatInfo من الـ state الحالي
    final currentState = state;
    if (currentState is ChatLoaded) {
      emit(ChatLoaded(currentState.chatInfo, List.from(messages)));
    }
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
      // ⭐ استخدم الـ chatInfo من الـ state الحالي
      final currentState = state;
      if (currentState is ChatLoaded) {
        emit(ChatLoaded(currentState.chatInfo, List.from(messages)));
      }
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> deleteMessage(int messageId) async {
    try {
      await chatRepo.deleteMessage(chatId, messageId);
      messages.removeWhere((m) => m.id == messageId);
      // ⭐ استخدم الـ chatInfo من الـ state الحالي
      final currentState = state;
      if (currentState is ChatLoaded) {
        emit(ChatLoaded(currentState.chatInfo, List.from(messages)));
      }
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> sendMedia(
    File file, {
    String? message,
    List<double>? amplitudes,
    int? duration,
  }) async {
    try {
      final msg = await chatRepo.sendMedia(
        chatId,
        file,
        message: message,
        amplitudes: amplitudes,
        duration: duration,
      );
      messages.add(msg);
      // ⭐ استخدم الـ chatInfo من الـ state الحالي
      final currentState = state;
      if (currentState is ChatLoaded) {
        emit(ChatLoaded(currentState.chatInfo, List.from(messages)));
      }
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void closeSSE() {
    _sseService.disconnect();
  }
}
