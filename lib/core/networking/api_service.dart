import 'package:dio/dio.dart';
import 'package:prime_academy/core/networking/api_constants.dart';
import 'package:prime_academy/features/authScreen/data/models/login_request_body.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/features/profileScreen/data/models/student_profile_response.dart';
import 'package:prime_academy/features/startScreen/data/models/certificate_response.dart';
import 'package:prime_academy/features/startScreen/data/models/student_preview_response.dart';
import 'package:prime_academy/features/startScreen/data/models/student_response.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST(ApiConstants.login)
  Future<LoginResponse> login(@Body() LoginRequestBody loginRequestBody);
  @GET(ApiConstants.studentsPreview)
  Future<StudentsResponse> getStudents();
  @GET(ApiConstants.certificates)
  Future<List<CertificateResponse>> getCertificates();
  @GET(ApiConstants.studentProfile)
  Future<StudentProfileResponse> getStudentProfileData();
  @GET("students/preview/{id}")
  Future<StudentPreviewResponse> previewStudent(@Path("id") int id);
}
