import 'package:prime_academy/core/networking/api_error_handler.dart';
import 'package:prime_academy/core/networking/api_result.dart';
import 'package:prime_academy/core/networking/api_service.dart';
import 'package:prime_academy/features/authScreen/data/models/login_request_body.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/features/profileScreen/data/models/student_profile_response.dart';

class LoginRepo {
  final ApiService _apiService; //مسئول عن ارسال الطلبات لل api

  LoginRepo(this._apiService); //dependency injection

  Future<ApiResult<LoginResponse>> login(
    LoginRequestBody loginRequestBody,
  ) async {
    try {
      final response = await _apiService.login(loginRequestBody);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
  Future<StudentProfileResponse?> getMyProfile() async {
  try {
    final response = await _apiService.getStudentProfileData();
    return response;
  } catch (error) {
    print('❌ Error fetching profile: $error');
    return null;
  }
}
}
