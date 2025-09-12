import 'package:dio/dio.dart';
import 'package:prime_academy/core/networking/api_constants.dart';
import 'package:prime_academy/core/networking/dio_factory.dart';
import 'package:prime_academy/features/CoursesModules/data/models/courses_model.dart';

class ModulesRepository {
  final Dio dio;

  // هنا بنستخدم الـ DioFactory
  ModulesRepository() : dio = DioFactory.getDio();

  Future<CourseModel> fetchCourseModules(int courseId) async {
    try {
      final response = await dio.get(
        "${ApiConstants.apiBaseUrl}courses/$courseId/user",);

      if (response.statusCode == 200) {
        return CourseModel.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to load course modules: '
          '${response.statusCode} ${response.statusMessage}',
        );
      }
    } on DioError catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
