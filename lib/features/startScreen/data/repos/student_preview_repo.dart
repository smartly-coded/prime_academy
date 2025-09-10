import 'package:prime_academy/core/networking/api_error_handler.dart';
import 'package:prime_academy/core/networking/api_result.dart';
import 'package:prime_academy/core/networking/api_service.dart';
import 'package:prime_academy/features/startScreen/data/models/student_preview_response.dart';

class StudentPreviewRepo {
  final ApiService _apiService; //مسئول عن ارسال الطلبات لل api

  StudentPreviewRepo(this._apiService); //dependency injection

  Future<ApiResult<StudentPreviewResponse>> previewStudent(int id) async {
    try {
      final response = await _apiService.previewStudent(id);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
