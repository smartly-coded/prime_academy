import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/features/startScreen/data/models/student_response.dart';
import 'package:prime_academy/features/startScreen/data/repos/start_screen_repo.dart';
import 'package:prime_academy/features/startScreen/logic/start_screen_state.dart';
import 'package:prime_academy/core/networking/api_result.dart';

class StartScreenCubit extends Cubit<StartScreenState> {
  final StartScreenRepo _startScreenRepo;

  StartScreenCubit(this._startScreenRepo) : super(StartScreenState.initial());

  List<Student> allStudents = [];
  List<Student> sliderStudents = [];

  void emitAllStudentsState() async {
    emit(const StartScreenState.loading());
    final response = await _startScreenRepo.getAllStudents();
    response.when(
      success: (studentsResponse) {
        allStudents = (studentsResponse.data ?? [])
            .whereType<Student>()
            .toList();
        emit(StartScreenState.success(studentsResponse));
      },
      failure: (error) {
        emit(StartScreenState.error(error: error.apiErrorModel.message ?? ''));
      },
    );
  }

  void loadStudentsGradually() async {
    int currentPage = 1;
    bool hasMore = true;

    emit(const StartScreenState.loading());

    try {
      while (hasMore) {
        final response = await _startScreenRepo.getStudentsPage(currentPage);

        response.when(
          success: (studentsResponse) {
            final pageStudents = studentsResponse.data ?? [];

            if (pageStudents.isEmpty) {
              hasMore = false;
              return;
            }

            allStudents.addAll(pageStudents);

            emit(StartScreenState.studentsBatchLoaded(allStudents));

            hasMore =
                studentsResponse.meta.currentPage <
                studentsResponse.meta.lastPage;

            currentPage++;
          },
          failure: (error) {
            emit(
              StartScreenState.error(error: error.apiErrorModel.message ?? ''),
            );
            hasMore = false;
          },
        );
      }
    } catch (e) {
      emit(StartScreenState.error(error: e.toString()));
    }
  }

  void emitSliderStudentsState() async {
    emit(const StartScreenState.loading());

    final response = await _startScreenRepo.getTopLastStudents(count: 8);

    response.when(
      success: (students) {
        sliderStudents = students;

        final modifiedResponse = StudentsResponse(
          data: students,
          meta: Meta(currentPage: 1, lastPage: 1, total: students.length),
        );

        emit(StartScreenState.success(modifiedResponse));
      },
      failure: (error) {
        emit(StartScreenState.error(error: error.apiErrorModel.message ?? ''));
      },
    );
  }
}
