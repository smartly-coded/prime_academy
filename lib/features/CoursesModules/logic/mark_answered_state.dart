import 'package:freezed_annotation/freezed_annotation.dart';

part 'mark_answered_state.freezed.dart';

@freezed
class MarkAnsweredState<T> with _$MarkAnsweredState<T> {
  const factory MarkAnsweredState.initial() = _Initial;
  const factory MarkAnsweredState.loading() = Loading;
  const factory MarkAnsweredState.success(T data) = Success<T>;
  const factory MarkAnsweredState.error({required String error}) = Error;
}
