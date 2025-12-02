import 'package:dio/dio.dart';
import 'package:prime_academy/core/networking/api_constants.dart';
import 'package:prime_academy/features/CoursesModules/data/models/lesson_details_response.dart';
import 'package:prime_academy/features/CoursesModules/data/models/mark_answerd_request_body.dart';
import 'package:prime_academy/features/CoursesModules/data/models/mark_answered_response_model.dart';
import 'package:prime_academy/features/CoursesModules/data/models/module_lessons_request_body.dart';
import 'package:prime_academy/features/CoursesModules/data/models/module_lessons_response_model.dart';
import 'package:prime_academy/features/authScreen/data/models/login_request_body.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/features/profileScreen/data/models/student_profile_response.dart';
import 'package:prime_academy/features/startScreen/data/models/certificate_response.dart';
import 'package:prime_academy/features/startScreen/data/models/student_preview_response.dart';
import 'package:prime_academy/features/startScreen/data/models/student_response.dart';
import 'package:prime_academy/features/studentsTestimonals/data/models/students_testimonals_request.dart';
import 'package:prime_academy/features/studentsTestimonals/data/models/students_testimonals_response.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST(ApiConstants.login)
  Future<LoginResponse> login(@Body() LoginRequestBody loginRequestBody);
  @GET(ApiConstants.studentsPreview)
  // Future<StudentsResponse> getStudents();
  Future<StudentsResponse> getStudents({@Query("page") int page = 1});
  @GET(ApiConstants.certificates)
  Future<List<CertificateResponse>> getCertificates();
  @GET(ApiConstants.studentProfile)
  Future<StudentProfileResponse> getStudentProfileData();
  @GET("students/preview/{id}")
  Future<StudentPreviewResponse> previewStudent(@Path("id") int id);
  @POST("module-items/{moduleId}/user")
  Future<ModuleLessonsResponse> getModuleLessons(
    @Path("moduleId") int moduleId,
    @Body() ModuleLessonsRequestBody moduleLessonsRequestBody,
  );
  @GET("module-items/lesson/{itemId}/user")
  Future<LessonDetailsResponse> getLessonDetails(@Path("itemId") int itemId);
  @POST("/lesson-questions/{questionId}/mark-answered")
  Future<MarkAnsweredResponseModel> getLessonRewardStatus(
    @Path("questionId") int questionId,
    @Body() MarkAnsweredRequestBody markAnsweredRequestBody,
  );
  @POST(ApiConstants.testimonals)
  Future<void> sendTestimonals(
    @Body() StudentsTestimonalsRequest studentTestimonalRequest,
  );
  @GET(ApiConstants.testimonals)
  Future<List<StudentTestimonalsResponse>> getStudentsTestimonals();
}
