import 'package:dio/dio.dart';
import 'package:prime_academy/core/networking/api_constants.dart';
import 'package:prime_academy/core/networking/dio_factory.dart';
import 'package:prime_academy/features/contact_us/data/models/inquery_model.dart';


class ContactUsRepo {
  final Dio dio;

  ContactUsRepo() : dio = DioFactory.getDio();

  Future<bool> sendInquiry(InquiryRequest request) async {
    try {
      final response = await dio.post(
        "${ApiConstants.apiBaseUrl}${ApiConstants.inquiries}",
        data: request.toJson(),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception(
            'Failed to send inquiry: ${response.statusCode} ${response.statusMessage}');
      }
    } on DioError catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
