import 'package:freezed_annotation/freezed_annotation.dart';

part 'module_lessons_state.freezed.dart';

@freezed
class ModuleLessonsState<T> with _$ModuleLessonsState<T> {
  const factory ModuleLessonsState.initial() = _Initial;
  const factory ModuleLessonsState.loading() = Loading;
  const factory ModuleLessonsState.success(T data) = Success<T>;
  const factory ModuleLessonsState.error({required String error}) = Error;
}
