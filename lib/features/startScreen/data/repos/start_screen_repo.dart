import 'package:prime_academy/core/networking/api_error_handler.dart';
import 'package:prime_academy/core/networking/api_result.dart';
import 'package:prime_academy/core/networking/api_service.dart';
import 'package:prime_academy/features/startScreen/data/models/certificate_response.dart';
import 'package:prime_academy/features/startScreen/data/models/student_response.dart';

// class StartScreenRepo {
//   final ApiService _apiService; //مسئول عن ارسال الطلبات لل api

//   StartScreenRepo(this._apiService); //dependency injection

//   Future<ApiResult<StudentsResponse>> getStudents() async {
//     try {
//       final response = await _apiService.getStudents();
//       return ApiResult.success(response);
//     } catch (error) {
//       return ApiResult.failure(ErrorHandler.handle(error));
//     }
//   }

//   Future<ApiResult<List<CertificateResponse>>> getCertificates() async {
//     try {
//       final certificateResponse = await _apiService.getCertificates();
//       return ApiResult.success(certificateResponse);
//     } catch (error) {
//       return ApiResult.failure(ErrorHandler.handle(error));
//     }
//   }
// }
class StartScreenRepo {
  final ApiService _apiService;

  StartScreenRepo(this._apiService);

  // لتحميل كل الصفحات
  Future<ApiResult<StudentsResponse>> getAllStudents() async {
    try {
      List<Student> allStudents = [];
      int currentPage = 1;
      int lastPage = 1;

      do {
        final response = await _apiService.getStudents(page: currentPage);
        if (response.data != null) {
          allStudents.addAll(response.data!);
          lastPage = response.meta.lastPage;
          currentPage++;
        } else {
          break;
        }
      } while (currentPage <= lastPage);

      final allResponse = StudentsResponse(
        data: allStudents,
        meta: Meta(currentPage: 1, lastPage: 1, total: allStudents.length),
      );

      return ApiResult.success(allResponse);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
Future<ApiResult<StudentsResponse>> getStudentsPage(int page) async {
  try {
    final response = await _apiService.getStudents(page: page);
    return ApiResult.success(response);
  } catch (error) {
    return ApiResult.failure(ErrorHandler.handle(error));
  }
}

  // لتحميل آخر صفحة فقط (الأوائل للسلايدر)
  Future<ApiResult<StudentsResponse>> getLastPageStudents() async {
    try {
      // نفترض آخر صفحة رقم 33
      final response = await _apiService.getStudents(page: 33);
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
