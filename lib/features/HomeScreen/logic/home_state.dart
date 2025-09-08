import 'package:equatable/equatable.dart';
import 'package:prime_academy/features/HomeScreen/data/models/CourseModel.dart';

abstract class CourseState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

class CourseLoaded extends CourseState {
  final List<Course> courses;

  CourseLoaded(this.courses);

  @override
  List<Object?> get props => [courses];
}

class CourseError extends CourseState {
  final String message;

  CourseError(this.message);

  @override
  List<Object?> get props => [message];
}
