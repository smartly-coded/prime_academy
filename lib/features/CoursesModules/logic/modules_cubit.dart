// modules_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/features/CoursesModules/data/models/courses_model.dart';
import 'package:prime_academy/features/CoursesModules/data/repo/modules_repository.dart';


part 'modules_state.dart';

class ModulesCubit extends Cubit<ModulesState> {
  final ModulesRepository repository;

  ModulesCubit(this.repository) : super(ModulesInitial());

  Future<void> loadModules(int courseId, {String? token}) async {
    emit(ModulesLoading());
    try {
      final course = await repository.fetchCourseModules(courseId,);
      emit(ModulesLoaded(course));
    } catch (e) {
      emit(ModulesError(e.toString()));
    }
  }
}
