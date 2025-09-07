import 'package:dio/dio.dart';
import 'api_constants.dart';
import 'api_error_model.dart';

/// تعداد مصادر الأخطاء المختلفة
enum DataSource {
  // Success states
  success,
  created,
  noContent,

  // Client errors (4xx)
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  apiLogicError,

  // Server errors (5xx)
  internalServerError,

  // Network/Connection errors
  connectTimeout,
  receiveTimeout,
  sendTimeout,
  connectionError,

  // Local errors
  cancel,
  cacheError,
  noInternetConnection,
  parseError,
  certificateError,
  unknownError,
}

/// أكواد الاستجابة HTTP والمحلية
class ResponseStatusCode {
  // Success codes
  static const int success = 200;
  static const int created = 201;
  static const int noContent = 204;

  // Client error codes
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int apiLogicError = 422;

  // Server error codes
  static const int internalServerError = 500;

  // Local error codes (negative values)
  static const int connectTimeout = -1;
  static const int receiveTimeout = -2;
  static const int sendTimeout = -3;
  static const int connectionError = -4;
  static const int cancel = -5;
  static const int cacheError = -6;
  static const int noInternetConnection = -7;
  static const int parseError = -8;
  static const int certificateError = -9;
  static const int unknownError = -10;
}

/// رسائل الأخطاء
class ResponseMessage {
  // Success messages
  static const String success = "تم بنجاح";
  static const String created = "تم الإنشاء بنجاح";
  static const String noContent = ApiErrors.noContent;

  // Client error messages
  static const String badRequest = ApiErrors.badRequestError;
  static const String unauthorized = ApiErrors.unauthorizedError;
  static const String forbidden = ApiErrors.forbiddenError;
  static const String notFound = ApiErrors.notFoundError;
  static const String apiLogicError = "خطأ في منطق API";

  // Server error messages
  static const String internalServerError = ApiErrors.internalServerError;

  // Local error messages
  static const String connectTimeout = ApiErrors.timeoutError;
  static const String receiveTimeout = ApiErrors.timeoutError;
  static const String sendTimeout = ApiErrors.timeoutError;
  static const String connectionError = "خطأ في الاتصال";
  static const String cancel = "تم إلغاء الطلب";
  static const String cacheError = ApiErrors.cacheError;
  static const String noInternetConnection = ApiErrors.noInternetError;
  static const String parseError = "خطأ في تحليل البيانات";
  static const String certificateError = "خطأ في شهادة الأمان";
  static const String unknownError = "خطأ غير معروف";
}

/// Extension لتحويل DataSource إلى ApiErrorModel
extension DataSourceExtension on DataSource {
  ApiErrorModel getFailure() {
    switch (this) {
      case DataSource.success:
        return ApiErrorModel(
          statusCode: ResponseStatusCode.success,
          message: ResponseMessage.success,
        );
      case DataSource.created:
        return ApiErrorModel(
          statusCode: ResponseStatusCode.created,
          message: ResponseMessage.created,
        );
      case DataSource.noContent:
        return ApiErrorModel(
          statusCode: ResponseStatusCode.noContent,
          message: ResponseMessage.noContent,
        );
      case DataSource.badRequest:
        return ApiErrorModel(
          statusCode: ResponseStatusCode.badRequest,
          message: ResponseMessage.badRequest,
        );
      case DataSource.unauthorized:
        return ApiErrorModel(
          statusCode: ResponseStatusCode.unauthorized,
          message: ResponseMessage.unauthorized,
        );
      case DataSource.forbidden:
        return ApiErrorModel(
          statusCode: ResponseStatusCode.forbidden,
          message: ResponseMessage.forbidden,
        );
      case DataSource.notFound:
        return ApiErrorModel(
          statusCode: ResponseStatusCode.notFound,
          message: ResponseMessage.notFound,
        );
      case DataSource.apiLogicError:
        return ApiErrorModel(
          statusCode: ResponseStatusCode.apiLogicError,
          message: ResponseMessage.apiLogicError,
        );
      case DataSource.internalServerError:
        return ApiErrorModel(
          statusCode: ResponseStatusCode.internalServerError,
          message: ResponseMessage.internalServerError,
        );
      case DataSource.connectTimeout:
        return ApiErrorModel(
          statusCode: ResponseStatusCode.connectTimeout,
          message: ResponseMessage.connectTimeout,
        );
      case DataSource.receiveTimeout:
        return ApiErrorModel(
          statusCode: ResponseStatusCode.receiveTimeout,
          message: ResponseMessage.receiveTimeout,
        );
      case DataSource.sendTimeout:
        return ApiErrorModel(
          statusCode: ResponseStatusCode.sendTimeout,
          message: ResponseMessage.sendTimeout,
        );
      case DataSource.connectionError:
        return ApiErrorModel(
          statusCode: ResponseStatusCode.connectionError,
          message: ResponseMessage.connectionError,
        );
      case DataSource.cancel:
        return ApiErrorModel(
          statusCode: ResponseStatusCode.cancel,
          message: ResponseMessage.cancel,
        );
      case DataSource.cacheError:
        return ApiErrorModel(
          statusCode: ResponseStatusCode.cacheError,
          message: ResponseMessage.cacheError,
        );
      case DataSource.noInternetConnection:
        return ApiErrorModel(
          statusCode: ResponseStatusCode.noInternetConnection,
          message: ResponseMessage.noInternetConnection,
        );
      case DataSource.parseError:
        return ApiErrorModel(
          statusCode: ResponseStatusCode.parseError,
          message: ResponseMessage.parseError,
        );
      case DataSource.certificateError:
        return ApiErrorModel(
          statusCode: ResponseStatusCode.certificateError,
          message: ResponseMessage.certificateError,
        );
      case DataSource.unknownError:
        return ApiErrorModel(
          statusCode: ResponseStatusCode.unknownError,
          message: ResponseMessage.unknownError,
        );
    }
  }
}

/// معالج الأخطاء الرئيسي
class ErrorHandler implements Exception {
  late ApiErrorModel apiErrorModel;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      // خطأ من Dio - معالجة متخصصة
      apiErrorModel = _handleDioError(error);
    } else {
      // خطأ عام غير متوقع
      apiErrorModel = ApiErrorModel(
        statusCode: ResponseStatusCode.unknownError,
        message: error.toString(),
      );
    }
  }

  /// معالجة أخطاء Dio
  static ApiErrorModel _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return DataSource.connectTimeout.getFailure();

      case DioExceptionType.sendTimeout:
        return DataSource.sendTimeout.getFailure();

      case DioExceptionType.receiveTimeout:
        return DataSource.receiveTimeout.getFailure();

      case DioExceptionType.badResponse:
        return _handleResponseError(error);

      case DioExceptionType.cancel:
        return DataSource.cancel.getFailure();

      case DioExceptionType.connectionError:
        return DataSource.connectionError.getFailure();

      case DioExceptionType.badCertificate:
        return DataSource.certificateError.getFailure();

      case DioExceptionType.unknown:
        return _handleUnknownError(error);
    }
  }

  /// معالجة أخطاء الاستجابة (badResponse)
  static ApiErrorModel _handleResponseError(DioException error) {
    final statusCode = error.response?.statusCode;

    if (statusCode == null) {
      return DataSource.unknownError.getFailure();
    }

    switch (statusCode) {
      case 400:
        return DataSource.badRequest.getFailure();
      case 401:
        return DataSource.unauthorized.getFailure();
      case 403:
        return DataSource.forbidden.getFailure();
      case 404:
        return DataSource.notFound.getFailure();
      case 422:
        return DataSource.apiLogicError.getFailure();
      case 500:
        return DataSource.internalServerError.getFailure();
      default:
        return _parseErrorFromResponse(error);
    }
  }

  /// معالجة الأخطاء المجهولة
  /// معالجة الأخطاء المجهولة
  static ApiErrorModel _handleUnknownError(DioException dioError) {
    // محاولة معالجة الاستجابة إذا كانت موجودة
    if (dioError.response?.statusCode != null) {
      return _handleResponseError(dioError);
    }

    // فحص نوع الخطأ من الرسالة
    final errorMessage = dioError.message?.toLowerCase() ?? '';

    if (errorMessage.contains('network') ||
        errorMessage.contains('connection')) {
      return DataSource.noInternetConnection.getFailure();
    }

    if (errorMessage.contains('timeout')) {
      return DataSource.connectTimeout.getFailure();
    }

    // ✅ في حالة الخطأ غير معروف: نرجّع رسالة الخطأ نفسها
    return ApiErrorModel(
      statusCode: ResponseStatusCode.unknownError,
      message: dioError.message,
    );
  }

  /// محاولة استخراج الخطأ من استجابة الخادم
  static ApiErrorModel _parseErrorFromResponse(DioException error) {
    try {
      if (error.response?.data != null) {
        // محاولة تحليل البيانات كـ ApiErrorModel
        return ApiErrorModel.fromJson(error.response!.data);
      }
    } catch (parseException) {
      // إذا فشل التحليل، نسجل الخطأ ونعيد خطأ parse
      _logError('Failed to parse error response', parseException);
      return DataSource.parseError.getFailure();
    }

    return DataSource.unknownError.getFailure();
  }

  /// تسجيل الأخطاء (يمكن تطويرها حسب نظام التسجيل المستخدم)
  static void _logError(String message, dynamic error) {
    // يمكنك استخدام logging package أو Firebase Crashlytics
    print('🔴 ErrorHandler: $message - Error: $error');
  }
}

/// حالات API الداخلية
class ApiInternalStatus {
  static const int success = 0;
  static const int failure = 1;
}

/// Helper methods للتحقق من نوع الخطأ
extension ApiErrorModelExtension on ApiErrorModel {
  bool get isNetworkError => [
    ResponseStatusCode.connectTimeout,
    ResponseStatusCode.receiveTimeout,
    ResponseStatusCode.sendTimeout,
    ResponseStatusCode.connectionError,
    ResponseStatusCode.noInternetConnection,
  ].contains(statusCode);

  bool get isServerError => statusCode! >= 500 && statusCode! < 600;

  bool get isClientError => statusCode! >= 400 && statusCode! < 500;

  bool get isSuccess => statusCode! >= 200 && statusCode! < 300;

  bool get shouldRetry => isNetworkError || statusCode == 500;
}
