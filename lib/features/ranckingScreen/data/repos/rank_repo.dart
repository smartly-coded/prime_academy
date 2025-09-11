// import 'package:dio/dio.dart';
// import 'package:prime_academy/features/ranckingScreen/data/models/rankingModel.dart';
// import 'package:prime_academy/core/networking/api_constants.dart';

// class RankRepository {
//   final Dio dio;
//   RankRepository(this.dio);

//   Future<List<RankingModel>> getRanks(int courseId) async {
//     final response = await dio.get(
//       "${ApiConstants.apiBaseUrl}courses/ranks/$courseId",
//     );
//     final data = response.data as List;
//     return data.map((e) => RankingModel.fromJson(e)).toList();
//   }
// }
import 'package:dio/dio.dart';
import 'package:prime_academy/core/networking/api_constants.dart';
import 'package:prime_academy/core/networking/dio_factory.dart';
import 'package:prime_academy/features/ranckingScreen/data/models/rankingModel.dart';


class RankRepository {
  final Dio dio;

  // constructor بيستخدم DioFactory
  RankRepository() : dio = DioFactory.getDio();

  Future<List<RankingModel>> getRanks(int courseId) async {
    try {
      final response = await dio.get(
        "${ApiConstants.apiBaseUrl}${ApiConstants.ranks}$courseId"

      );

      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((e) => RankingModel.fromJson(e)).toList();
      } else {
        throw Exception(
            'Failed to load ranks: ${response.statusCode} ${response.statusMessage}');
      }
    } on DioError catch (e) {
     
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
