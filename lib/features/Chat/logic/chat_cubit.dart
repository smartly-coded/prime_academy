
// import 'dart:io';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:prime_academy/core/networking/api_result.dart';
// import 'package:prime_academy/core/services/chat_eventsource.dart';
// import 'package:prime_academy/features/Chat/data/models/chatModel.dart';
// import 'package:prime_academy/features/Chat/data/models/chat_info_model.dart';
// import 'package:prime_academy/features/Chat/data/repos/chat_repo.dart';
// import 'package:prime_academy/features/Chat/logic/chat_state.dart';
// import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
// import 'package:prime_academy/features/CoursesModules/data/repo/modules_lessons_repo.dart'; // ⭐ إضافة

// class ChatCubit extends Cubit<ChatState> {
//   static ChatCubit? instance;
//   final ChatRepo chatRepo;
//   final ModulesLessonsRepo modulesLessonsRepo;
//   final int chatId;
//   int? moduleId;
//   int? courseId;
//   final LoginResponse user;

//   List<MessageModel> messages = [];
//   final SSEService _sseService = SSEService();

//   ChatCubit({
//     required this.chatRepo,
//     required this.modulesLessonsRepo,
//     required this.chatId,
//     this.moduleId,
//     this.courseId,
//     required this.user,
//   }) : super(ChatInitial()) {
//     instance = this;
//   }

//   Future<void> loadChat() async {
//     print('🟡 CHAT CUBIT REQUEST');
//     print('moduleId = $moduleId');
//     print('courseId = $courseId');

//     // ⭐ بدل ChatLoading، emit الـ ChatInfo فوراً عشان الشاشة تفتح
//     final chatInfo = ChatInfoModel.fromLoginResponse(user);
//     emit(ChatLoaded(chatInfo, [])); // قائمة فاضية في البداية

//     try {
//       // ⭐ جيب بيانات المعلم من modules endpoint
//       ChatInfoModel updatedChatInfo = chatInfo;
//       if (moduleId != null && courseId != null) {
//         try {
//           final moduleResult = await modulesLessonsRepo.getModuleLessons(
//             courseId!,
//             moduleId!,
//           );

//           moduleResult.when(
//             success: (moduleData) {
//               print('✅ MODULE DATA: $moduleData');

//               // اطبعي بيانات المعلم بالتحديد
//               print('👨‍🏫 TEACHER RAW: ${moduleData.teacher}');
//               print('👨‍🏫 TEACHER ID: ${moduleData.teacher?.id}');
//               print(
//                 '👨‍🏫 TEACHER FIRSTNAME: ${moduleData.teacher?.firstname}',
//               );
//               print('👨‍🏫 TEACHER LASTNAME: ${moduleData.teacher?.lastname}');
//               print('👨‍🏫 TEACHER IMAGE: ${moduleData.teacher?.image?.url}');

//               if (moduleData.teacher != null) {
//                 updatedChatInfo = chatInfo.copyWithTeacher(moduleData.teacher!);
//               } else {
//                 print('⚠️ teacher = null');
//               }
//             },
//             failure: (error) {
//               print(
//                 '❌ Failed to load teacher data: ${error.apiErrorModel.message}',
//               );
//             },
//           );

         
//         } catch (e) {
//           print('Error fetching teacher data: $e');
//           // استمر بدون بيانات المعلم
//         }
//       }
//       // ⭐ اعكس الرسائل بعد ما تجيبها
//       final fetchedMessages = await chatRepo.getMessages(chatId, page: 1);
//       messages = fetchedMessages.reversed.toList(); // عكس الترتيب هنا

//       emit(ChatLoaded(updatedChatInfo, List.from(messages)));

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
//       // ⭐ استخدم الـ chatInfo من الـ state الحالي
//       final currentState = state;
//       if (currentState is ChatLoaded) {
//         emit(ChatLoaded(currentState.chatInfo, List.from(messages)));
//       }
//     } catch (e) {
//       emit(ChatError(e.toString()));
//     }
//   }

//   void addMessage(MessageModel message) {
//     messages.add(message);
//     // ⭐ استخدم الـ chatInfo من الـ state الحالي
//     final currentState = state;
//     if (currentState is ChatLoaded) {
//       emit(ChatLoaded(currentState.chatInfo, List.from(messages)));
//     }
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
//       // ⭐ استخدم الـ chatInfo من الـ state الحالي
//       final currentState = state;
//       if (currentState is ChatLoaded) {
//         emit(ChatLoaded(currentState.chatInfo, List.from(messages)));
//       }
//     } catch (e) {
//       emit(ChatError(e.toString()));
//     }
//   }

//   Future<void> deleteMessage(int messageId) async {
//     try {
//       await chatRepo.deleteMessage(chatId, messageId);
//       messages.removeWhere((m) => m.id == messageId);
//       // ⭐ استخدم الـ chatInfo من الـ state الحالي
//       final currentState = state;
//       if (currentState is ChatLoaded) {
//         emit(ChatLoaded(currentState.chatInfo, List.from(messages)));
//       }
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
//       // ⭐ استخدم الـ chatInfo من الـ state الحالي
//       final currentState = state;
//       if (currentState is ChatLoaded) {
//         emit(ChatLoaded(currentState.chatInfo, List.from(messages)));
//       }
//     } catch (e) {
//       emit(ChatError(e.toString()));
//     }
//   }

//   void closeSSE() {
//     _sseService.disconnect();
//   }
// }import 'dart:io';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/networking/api_result.dart';
import 'package:prime_academy/core/services/chat_eventsource.dart';
import 'package:prime_academy/features/Chat/data/models/chatModel.dart';
import 'package:prime_academy/features/Chat/data/models/chat_info_model.dart';
import 'package:prime_academy/features/Chat/data/repos/chat_repo.dart';
import 'package:prime_academy/features/Chat/logic/chat_state.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/features/CoursesModules/data/repo/modules_lessons_repo.dart';
import 'package:prime_academy/services/TeacherCacheService.dart';

class ChatCubit extends Cubit<ChatState> {
  static ChatCubit? instance;
  final ChatRepo chatRepo;
  final ModulesLessonsRepo? modulesLessonsRepo; // ⭐ خليه optional
  final int chatId;
  int? moduleId;
  int? courseId;
  final LoginResponse user;

  List<MessageModel> messages = [];
  final SSEService _sseService = SSEService();

  ChatCubit({
    required this.chatRepo,
    this.modulesLessonsRepo,
    required this.chatId,
    this.moduleId,
    this.courseId,
    required this.user,
  }) : super(ChatInitial()) {
    instance = this;
  }

  Future<void> loadChat() async {
    print('🟡 CHAT CUBIT REQUEST');
    print('chatId = $chatId');
    print('moduleId = $moduleId');
    print('courseId = $courseId');

    final chatInfo = ChatInfoModel.fromLoginResponse(user);
    emit(ChatLoaded(chatInfo, []));

    try {
      ChatInfoModel updatedChatInfo = chatInfo;

      // ⭐ جرب تجيب بيانات المعلم من الكاش الأول
      final cachedTeacher = await TeacherCacheService.getTeacherData(chatId);

      if (cachedTeacher != null) {
        // لو موجودة في الكاش، استخدمها مباشرة
        print('✅ استخدام بيانات المعلم من الكاش');
        updatedChatInfo = chatInfo.copyWithTeacherData(
          teacherId: cachedTeacher['id'],
          teacherName: '${cachedTeacher['firstname']} ${cachedTeacher['lastname']}',
          teacherImageUrl: cachedTeacher['imageUrl'],
        );
      } else if (moduleId != null && courseId != null && modulesLessonsRepo != null) {
        // لو مش موجودة والمعلومات متوفرة، اجلبها من الـ API
        print('⚠️ جلب بيانات المعلم من الـ API');
        try {
          final moduleResult = await modulesLessonsRepo!.getModuleLessons(
            courseId!,
            moduleId!,
          );

          moduleResult.when(
            success: (moduleData) {
              if (moduleData.teacher != null) {
                final teacher = moduleData.teacher!;
                updatedChatInfo = chatInfo.copyWithTeacher(teacher);
                
                // ⭐ احفظ البيانات في الكاش للمرة الجاية
                TeacherCacheService.saveTeacherData(chatId, teacher);
              }
            },
            failure: (error) {
              print('❌ فشل جلب بيانات المعلم: ${error.apiErrorModel.message}');
            },
          );
        } catch (e) {
          print('❌ خطأ في جلب بيانات المعلم: $e');
        }
      } else {
        print('⚠️ لا توجد بيانات كافية لجلب معلومات المعلم');
      }

      // جلب الرسائل
      final fetchedMessages = await chatRepo.getMessages(chatId, page: 1);
      messages = fetchedMessages.reversed.toList();

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