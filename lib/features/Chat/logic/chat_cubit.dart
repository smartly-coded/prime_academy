import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/networking/api_result.dart';
import 'package:prime_academy/core/services/unified_sse_service.dart';
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
  final ModulesLessonsRepo? modulesLessonsRepo;
  final int chatId;
  int? moduleId;
  int? courseId;
  final LoginResponse user;

  List<MessageModel> messages = [];
  final UnifiedSSEService _sseService = UnifiedSSEService();

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

      // Try to get teacher data from cache first
      final cachedTeacher = await TeacherCacheService.getTeacherData(chatId);

      if (cachedTeacher != null) {
        print('✅ Using cached teacher data');
        updatedChatInfo = chatInfo.copyWithTeacherData(
          teacherId: cachedTeacher['id'],
          teacherName: '${cachedTeacher['firstname']} ${cachedTeacher['lastname']}',
          teacherImageUrl: cachedTeacher['imageUrl'],
        );
      } else if (moduleId != null && courseId != null && modulesLessonsRepo != null) {
        print('⚠️ Fetching teacher data from API');
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
                
                // Save to cache for next time
                TeacherCacheService.saveTeacherData(chatId, teacher);
              }
            },
            failure: (error) {
              print('❌ Failed to fetch teacher data: ${error.apiErrorModel.message}');
            },
          );
        } catch (e) {
          print('❌ Error fetching teacher data: $e');
        }
      } else {
        print('⚠️ Not enough data to fetch teacher info');
      }

      // Fetch messages
      final fetchedMessages = await chatRepo.getMessages(chatId, page: 1);
      messages = fetchedMessages.reversed.toList();

      emit(ChatLoaded(updatedChatInfo, List.from(messages)));
      
      // ✅ Register this chat with the unified SSE service
      _sseService.registerChatCubit(this);
      
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

  @override
  Future<void> close() {
    // ✅ Unregister from SSE service when chat is closed
    _sseService.unregisterChatCubit();
    return super.close();
  }
}