import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/features/startScreen/data/models/student_response.dart';
import 'package:prime_academy/features/startScreen/data/repos/start_screen_repo.dart';
import 'package:prime_academy/features/startScreen/logic/start_screen_state.dart';
import 'package:prime_academy/core/networking/api_result.dart';

// class StartScreenCubit extends Cubit<StartScreenState> {
//   final StartScreenRepo _startScreenRepo;

//   StartScreenCubit(this._startScreenRepo) : super(StartScreenState.initial());

//   void emitStartScreenState() async {
//     emit(const StartScreenState.loading());
//     final response = await _startScreenRepo.getStudents();
//     response.when(
//       success: (studentsResponse) async {
//         emit(StartScreenState.success(studentsResponse));
//       },
//       failure: (error) {
//         emit(StartScreenState.error(error: error.apiErrorModel.message ?? ''));
//       },
//     );
//   }
// }
// class StartScreenCubit extends Cubit<StartScreenState> {
//   final StartScreenRepo _startScreenRepo;

//   StartScreenCubit(this._startScreenRepo) : super(StartScreenState.initial());

//   // لتحميل كل الطلاب
//   void emitAllStudentsState() async {
//     emit(const StartScreenState.loading());
//     final response = await _startScreenRepo.getAllStudents();
//     response.when(
//       success: (studentsResponse) {
//         emit(StartScreenState.success(studentsResponse));
//       },
//       failure: (error) {
//         emit(StartScreenState.error(error: error.apiErrorModel.message ?? ''));
//       },
//     );
//   }

//   // لتحميل آخر صفحة (الأوائل للسلايدر)
//   void emitSliderStudentsState() async {
//     emit(const StartScreenState.loading());
//     final response = await _startScreenRepo.getLastPageStudents();
//     response.when(
//       success: (studentsResponse) {
//         // ناخد آخر 8 طلاب من آخر صفحة
//         final last8 = (studentsResponse.data ?? []).reversed.take(8).toList();
//         final modifiedResponse = StudentsResponse(
//           data: last8,
//           meta: studentsResponse.meta,
//         );
//         emit(StartScreenState.success(modifiedResponse));
//       },
//       failure: (error) {
//         emit(StartScreenState.error(error: error.apiErrorModel.message ?? ''));
//       },
//     );
//   }
// }

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

            // نضيف الدفعة
            allStudents.addAll(pageStudents);

            // نعمل emit للدفعة الحالية فقط
            emit(StartScreenState.studentsBatchLoaded(allStudents));

            // هل لسه في صفحات؟
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

  // لتحميل آخر صفحة (الأوائل للسلايدر)
  void emitSliderStudentsState() async {
    emit(const StartScreenState.loading());
    final response = await _startScreenRepo.getLastPageStudents();
    response.when(
      success: (studentsResponse) {
        final last8 = (studentsResponse.data ?? []).reversed.take(8).toList();
        sliderStudents = last8;
        final modifiedResponse = StudentsResponse(
          data: last8,
          meta: studentsResponse.meta,
        );
        emit(StartScreenState.success(modifiedResponse));
      },
      failure: (error) {
        emit(StartScreenState.error(error: error.apiErrorModel.message ?? ''));
      },
    );
  }
}
