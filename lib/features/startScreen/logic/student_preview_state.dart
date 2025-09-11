import 'package:freezed_annotation/freezed_annotation.dart';

part 'student_preview_state.freezed.dart';

@freezed
class StudentPreviewState<T> with _$StudentPreviewState<T> {
  const factory StudentPreviewState.initial() = _Initial;
  const factory StudentPreviewState.loading() = Loading;
  const factory StudentPreviewState.success(T data) = Success<T>;
  const factory StudentPreviewState.error({required String error}) = Error;
}
