import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/networking/api_result.dart';
import 'package:prime_academy/features/startScreen/data/repos/student_preview_repo.dart';
import 'package:prime_academy/features/startScreen/logic/student_preview_state.dart';

class StudentPreviewCubit extends Cubit<StudentPreviewState> {
  final StudentPreviewRepo _studentPreviewRepo;

  StudentPreviewCubit(this._studentPreviewRepo)
    : super(StudentPreviewState.initial());

  void emitProfilePreviewState(int id) async {
    emit(const StudentPreviewState.loading());
    final response = await _studentPreviewRepo.previewStudent(id);
    response.when(
      success: (studentPreviewResponse) async {
        emit(StudentPreviewState.success(studentPreviewResponse));
      },
      failure: (error) {
        emit(
          StudentPreviewState.error(error: error.apiErrorModel.message ?? ''),
        );
      },
    );
  }
}
