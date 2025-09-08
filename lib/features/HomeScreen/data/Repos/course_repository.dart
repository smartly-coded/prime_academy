import 'package:dio/dio.dart';
import 'package:prime_academy/features/HomeScreen/data/models/CourseModel.dart';

class CourseRepository {
  final String baseUrl;
  final Dio dio;

  CourseRepository(this.baseUrl) : dio = Dio();

  Future<List<Course>> getUserCourses(int userId) async {
    try {
      final response = await dio.get('$baseUrl/courses/1/user');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          final course = Course.fromJson(data);
          return [course];
        }

        if (data is List) {
          return data.map((json) => Course.fromJson(json)).toList();
        }

        throw Exception("Unexpected response format");
      } else {
        throw Exception('Failed to load courses. Status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
