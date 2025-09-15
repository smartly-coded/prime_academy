import 'package:prime_academy/core/networking/api_error_handler.dart';
import 'package:prime_academy/core/networking/api_result.dart';
import 'package:prime_academy/core/networking/api_service.dart';
import 'package:prime_academy/features/CoursesModules/data/models/lesson_details_response.dart';

class LessonDetailsRepo {
  final ApiService _apiService; //مسئول عن ارسال الطلبات لل api

  LessonDetailsRepo(this._apiService); //dependency injection

  Future<ApiResult<LessonDetailsResponse>> getLessonDetails(int itemId) async {
    try {
      final response = await _apiService.getLessonDetails(itemId);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
