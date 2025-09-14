import 'package:equatable/equatable.dart';
import 'package:prime_academy/features/Chat/data/models/chatModel.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatSuccess extends ChatState {
  final List<MessageModel> messages;

  const ChatSuccess(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatError extends ChatState {
  final String error;

  const ChatError(this.error);

  @override
  List<Object?> get props => [error];
}
