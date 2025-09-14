import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/features/Chat/data/models/chatModel.dart';
import 'package:prime_academy/features/Chat/logic/chat_state.dart';
import 'package:prime_academy/features/chat/data/repos/chat_repo.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepo chatRepo;
  final int chatId; 

  ChatCubit(this.chatRepo, this.chatId) : super(ChatInitial());

  List<MessageModel> _messages = [];

  void sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    emit(ChatLoading());
    try {
      final message = await chatRepo.sendMessage(chatId, text);
      _messages.add(message);
      emit(ChatSuccess(List.from(_messages)));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}
