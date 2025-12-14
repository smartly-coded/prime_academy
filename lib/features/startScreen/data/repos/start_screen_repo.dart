import 'package:prime_academy/core/networking/api_error_handler.dart';
import 'package:prime_academy/core/networking/api_result.dart';
import 'package:prime_academy/core/networking/api_service.dart';
import 'package:prime_academy/features/startScreen/data/models/certificate_response.dart';
import 'package:prime_academy/features/startScreen/data/models/student_response.dart';


class StartScreenRepo {
  final ApiService _apiService;

  StartScreenRepo(this._apiService);

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

 
Future<ApiResult<List<Student>>> getTopLastStudents({int count = 8}) async {
  try {
    final firstResponse = await _apiService.getStudents(page: 1);
    final lastPage = firstResponse.meta.lastPage;

    final lastPageResponse =
        await _apiService.getStudents(page: lastPage);

    List<Student> result = [];

    final lastPageStudents = lastPageResponse.data ?? [];

    if (lastPageStudents.length >= count) {
      result = lastPageStudents.sublist(
        lastPageStudents.length - count,
      );
    } else {
      final remaining = count - lastPageStudents.length;

      final prevPageResponse =
          await _apiService.getStudents(page: lastPage - 1);

      final prevStudents = prevPageResponse.data ?? [];

      result = [
        ...prevStudents.sublist(
          prevStudents.length - remaining,
        ),
        ...lastPageStudents,
      ];
    }

    return ApiResult.success(result);
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
