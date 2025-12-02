import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:prime_academy/features/startScreen/data/models/student_response.dart';

part 'start_screen_state.freezed.dart';

@freezed
class StartScreenState<T> with _$StartScreenState<T> {
  const factory StartScreenState.initial() = _Initial;
  const factory StartScreenState.loading() = Loading;
  const factory StartScreenState.success(T data) = Success<T>;
  const factory StartScreenState.error({required String error}) = Error;
const factory StartScreenState.studentsBatchLoaded(List<Student> students) = _StudentsBatchLoaded;

}
