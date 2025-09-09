import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_state.freezed.dart';

@freezed
class ProfileState<T> with _$ProfileState<T> {
  const factory ProfileState.initial() = _Initial;
  const factory ProfileState.loading() = Loading;
  const factory ProfileState.success(T data) = Success<T>;
  const factory ProfileState.error({required String error}) = Error;
}

//abstract class CourseState extends Equatable {
//  @override
//  List<Object?> get props => [];
//}
//
//class CourseInitial extends CourseState {}
//
//class CourseLoading extends CourseState {}
//
//class CourseLoaded extends CourseState {
//  final List<Course> courses;
//
//  CourseLoaded(this.courses);
//
//  @override
//  List<Object?> get props => [courses];
//}
//
//class CourseError extends CourseState {
//  final String message;
//
//  CourseError(this.message);
//
//  @override
//  List<Object?> get props => [message];
//}
