import 'package:freezed_annotation/freezed_annotation.dart';

part 'testimonal_state.freezed.dart';

@freezed
class TestimonalState<T> with _$TestimonalState<T> {
  const factory TestimonalState.initial() = _Initial;
  const factory TestimonalState.loading() = Loading;
  const factory TestimonalState.success(T data) = Success<T>;
  const factory TestimonalState.error({required String error}) = Error;
}
