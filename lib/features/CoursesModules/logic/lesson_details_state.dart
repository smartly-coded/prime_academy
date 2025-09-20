import 'package:freezed_annotation/freezed_annotation.dart';

part 'lesson_details_state.freezed.dart';

@freezed
class LessonDetailsState<T> with _$LessonDetailsState<T> {
  const factory LessonDetailsState.initial() = _Initial;
  const factory LessonDetailsState.loading() = Loading;
  const factory LessonDetailsState.success(T data) = Success<T>;
  const factory LessonDetailsState.error({required String error}) = Error;
}
