import 'package:prime_academy/core/networking/api_error_handler.dart';
import 'package:prime_academy/core/networking/api_result.dart';
import 'package:prime_academy/core/networking/api_service.dart';
import 'package:prime_academy/features/profileScreen/data/models/student_profile_response.dart';

class StudentProfileRepo {
  final ApiService _apiService; //مسئول عن ارسال الطلبات لل api

  StudentProfileRepo(this._apiService); //dependency injection

  Future<ApiResult<StudentProfileResponse>> getStudentProfileData() async {
    try {
      final response = await _apiService.getStudentProfileData();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
