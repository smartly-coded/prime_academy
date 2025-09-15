import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/networking/api_result.dart';
import 'package:prime_academy/features/CoursesModules/data/repo/lesson_details_repo.dart';
import 'package:prime_academy/features/CoursesModules/logic/lesson_details_state.dart';

class LessonDetailsCubit extends Cubit<LessonDetailsState> {
  final LessonDetailsRepo _lessonDetailsRepo;
  LessonDetailsCubit(this._lessonDetailsRepo)
    : super(LessonDetailsState.initial());
  void emitModuleLessonsStates(int itemId) async {
    emit(const LessonDetailsState.loading());
    final response = await _lessonDetailsRepo.getLessonDetails(itemId);
    response.when(
      success: (moduleLessonsResponse) async {
        emit(LessonDetailsState.success(moduleLessonsResponse));
      },
      failure: (error) {
        emit(
          LessonDetailsState.error(error: error.apiErrorModel.message ?? ''),
        );
      },
    );
  }
}
