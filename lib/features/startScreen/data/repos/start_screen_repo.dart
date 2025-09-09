import 'package:prime_academy/core/networking/api_error_handler.dart';
import 'package:prime_academy/core/networking/api_result.dart';
import 'package:prime_academy/core/networking/api_service.dart';
import 'package:prime_academy/features/startScreen/data/models/certificate_response.dart';
import 'package:prime_academy/features/startScreen/data/models/student_response.dart';

class StartScreenRepo {
  final ApiService _apiService; //مسئول عن ارسال الطلبات لل api

  StartScreenRepo(this._apiService); //dependency injection

  Future<ApiResult<StudentsResponse>> getStudents() async {
    try {
      final response = await _apiService.getStudents();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<CertificateResponse>>> getCertificates() async {
    try {
      final certificateResponse = await _apiService.getCertificates();
      return ApiResult.success(certificateResponse);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
