import 'package:freezed_annotation/freezed_annotation.dart';

part 'start_screen_state.freezed.dart';

@freezed
class StartScreenState<T> with _$StartScreenState<T> {
  const factory StartScreenState.initial() = _Initial;
  const factory StartScreenState.loading() = Loading;
  const factory StartScreenState.success(T data) = Success<T>;
  const factory StartScreenState.error({required String error}) = Error;
}
