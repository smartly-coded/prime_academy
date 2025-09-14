import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/networking/api_result.dart';
import 'package:prime_academy/features/CoursesModules/data/repo/modules_lessons_repo.dart';
import 'package:prime_academy/features/CoursesModules/logic/module_lessons_state.dart';

class ModuleLessonsCubit extends Cubit<ModuleLessonsState> {
  final ModulesLessonsRepo _modulesLessonsRepo;

  ModuleLessonsCubit(this._modulesLessonsRepo)
    : super(ModuleLessonsState.initial());

  void emitModuleLessonsStates(int moduleId, int courseId) async {
    emit(const ModuleLessonsState.loading());
    final response = await _modulesLessonsRepo.getModuleLessons(
      moduleId,
      courseId,
    );
    response.when(
      success: (moduleLessonsResponse) async {
        emit(ModuleLessonsState.success(moduleLessonsResponse));
      },
      failure: (error) {
        emit(
          ModuleLessonsState.error(error: error.apiErrorModel.message ?? ''),
        );
      },
    );
  }
}
