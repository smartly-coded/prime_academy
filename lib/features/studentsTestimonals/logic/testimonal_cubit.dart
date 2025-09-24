import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/networking/api_result.dart';
import 'package:prime_academy/features/studentsTestimonals/data/models/students_testimonals_request.dart';
import 'package:prime_academy/features/studentsTestimonals/data/models/students_testimonals_response.dart';
import 'package:prime_academy/features/studentsTestimonals/data/repos/student_testimonal_repo.dart';
import 'package:prime_academy/features/studentsTestimonals/logic/testimonal_state.dart';

class TestimonalCubit extends Cubit<TestimonalState> {
  final StudentTestimonalRepo _studentTestimonalRepo;

  TestimonalCubit(this._studentTestimonalRepo)
    : super(const TestimonalState.initial());

  /// جلب شهادات الطلاب
  Future<void> getStudentTestimonals() async {
    emit(const TestimonalState.loading());

    final result = await _studentTestimonalRepo.getStudentTestimonal();

    result.when(
      success: (List<StudentTestimonalsResponse> testimonials) {
        emit(TestimonalState.success(testimonials));
      },
      failure: (error) {
        emit(
          TestimonalState.error(
            error: error.apiErrorModel.message ?? 'حدث خطأ غير متوقع',
          ),
        );
      },
    );
  }

  /// إرسال شهادة طالب جديدة
  Future<void> sendStudentTestimonal(StudentsTestimonalsRequest request) async {
    emit(const TestimonalState.loading());

    final result = await _studentTestimonalRepo.sendStudentTestimonal(request);

    result.when(
      success: (_) {
        emit(const TestimonalState.success('تم إرسال الشهادة بنجاح'));
      },
      failure: (error) {
        emit(
          TestimonalState.error(
            error: error.apiErrorModel.message ?? 'فشل في إرسال الشهادة',
          ),
        );
      },
    );
  }
}
