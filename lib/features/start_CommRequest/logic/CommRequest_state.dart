part of 'CommRequest_cubit.dart';

abstract class CommRequestState {}

class CommRequestInitial extends CommRequestState {}

class CommRequestLoading extends CommRequestState {}

class CommRequestSuccess extends CommRequestState {}

class CommRequestFailure extends CommRequestState {
  final String error;
  CommRequestFailure(this.error);
}
