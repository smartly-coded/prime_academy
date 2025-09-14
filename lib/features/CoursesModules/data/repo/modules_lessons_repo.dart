import 'package:prime_academy/core/networking/api_error_handler.dart';
import 'package:prime_academy/core/networking/api_result.dart';
import 'package:prime_academy/core/networking/api_service.dart';
import 'package:prime_academy/features/CoursesModules/data/models/module_lessons_request_body.dart';
import 'package:prime_academy/features/CoursesModules/data/models/module_lessons_response_model.dart';

class ModulesLessonsRepo {
  final ApiService _apiService; //مسئول عن ارسال الطلبات لل api

  ModulesLessonsRepo(this._apiService); //dependency injection

  Future<ApiResult<ModuleLessonsResponse>> getModuleLessons(
    int moduleId,
    int courseId,
  ) async {
    try {
      final response = await _apiService.getModuleLessons(
        moduleId,
        ModuleLessonsRequestBody(courseId: courseId),
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
