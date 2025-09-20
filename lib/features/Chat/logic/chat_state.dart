// import 'package:equatable/equatable.dart';
// import 'package:prime_academy/features/Chat/data/models/chatModel.dart';

// abstract class ChatState extends Equatable {
//   const ChatState();

//   @override
//   List<Object?> get props => [];
// }

// class ChatInitial extends ChatState {}

// class ChatLoading extends ChatState {}

// class ChatSuccess extends ChatState {
//   final List<MessageModel> messages;

//   const ChatSuccess(this.messages);

//   @override
//   List<Object?> get props => [messages];
// }

// class ChatError extends ChatState {
//   final String error;

//   const ChatError(this.error);

//   @override
//   List<Object?> get props => [error];
// }


// chat_state.dart
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
