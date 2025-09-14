import 'package:dio/dio.dart';
import 'package:prime_academy/core/networking/api_constants.dart';
import 'package:prime_academy/core/networking/dio_factory.dart';
import 'package:prime_academy/features/start_CommRequest/data/models/commRequest_model.dart';

class CommRequestRepository {
  final Dio dio;

  CommRequestRepository() : dio = DioFactory.getDio();

  Future<bool> sendCommRequest(CommRequest request) async {
    try {
      final response = await dio.post(
        "${ApiConstants.apiBaseUrl}${ApiConstants.commRequests}",
        data: request.toJson(),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception(
            'Failed to send Comm Request: ${response.statusCode} ${response.statusMessage}');
      }
    } on DioError catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
