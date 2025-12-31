
import 'package:prime_academy/features/Chat/data/models/chatModel.dart';
import 'package:prime_academy/features/Chat/data/models/chat_info_model.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final ChatInfoModel chatInfo;
  final List<MessageModel> messages;

  ChatLoaded(this.chatInfo, this.messages);
}

class ChatError extends ChatState {
  final String error;
  ChatError(this.error);
}
