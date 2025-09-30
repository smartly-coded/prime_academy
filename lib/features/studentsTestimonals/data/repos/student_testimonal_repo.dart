import 'package:prime_academy/core/networking/api_error_handler.dart';
import 'package:prime_academy/core/networking/api_result.dart';
import 'package:prime_academy/core/networking/api_service.dart';
import 'package:prime_academy/features/studentsTestimonals/data/models/students_testimonals_request.dart';
import 'package:prime_academy/features/studentsTestimonals/data/models/students_testimonals_response.dart';

class StudentTestimonalRepo {
  final ApiService _apiService; //مسئول عن ارسال الطلبات لل api

  StudentTestimonalRepo(this._apiService); //dependency injection

  Future<ApiResult<List<StudentTestimonalsResponse>>>
  getStudentTestimonal() async {
    try {
      final response = await _apiService.getStudentsTestimonals();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  Future<ApiResult<void>> sendStudentTestimonal(
    StudentsTestimonalsRequest request,
  ) async {
    try {
      final response = await _apiService.sendTestimonals(request);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
