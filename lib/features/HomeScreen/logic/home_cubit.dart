import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/features/HomeScreen/data/Repos/course_repository.dart';
import 'package:prime_academy/features/HomeScreen/logic/home_state.dart';

class CourseCubit extends Cubit<CourseState> {
  final CourseRepository repository;

  CourseCubit(this.repository) : super(CourseInitial());

  Future<void> loadUserCourses(int userId) async {
    try {
      emit(CourseLoading());
      final courses = await repository.getUserCourses(userId);
      emit(CourseLoaded(courses));
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }
}
