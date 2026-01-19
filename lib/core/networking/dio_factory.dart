import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:prime_academy/core/networking/Interceptor.dart';

class DioFactory {
  DioFactory._();

  static Dio? dio;

  static Dio getDio() {
    Duration timeOut = const Duration(seconds: 30);

    if (dio == null) {
      dio = Dio();
      dio!
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut;
      addDioHeader();
      addDioInterceptor();
      return dio!;
    } else {
      return dio!;
    }
  }

  static void addDioHeader() async {
    dio?.options.headers = {"Accept": "application/json"};
  }

  static void addDioInterceptor() {
    final storage = const FlutterSecureStorage();
    dio?.interceptors.addAll([
      LoadingInterceptor(),
      InterceptorsWrapper(
        onResponse: (response, handler) async {
          final cookies = response.headers['Set-Cookie'];
          if (cookies != null) {
            for (var cookie in cookies) {
              if (cookie.contains("accessToken=")) {
                final accessToken = cookie
                    .split("accessToken=")
                    .last
                    .split(";")
                    .first;
                await storage.write(key: "accessToken", value: accessToken);
              }
              if (cookie.contains("refreshToken=")) {
                final refreshToken = cookie
                    .split("refreshToken=")
                    .last
                    .split(";")
                    .first;
                await storage.write(key: "refreshToken", value: refreshToken);
              }
            }
          }
          return handler.next(response);
        },
        onRequest: (options, handler) async {
  final accessToken = await storage.read(key: "accessToken");
  final refreshToken = await storage.read(key: "refreshToken");

 
  final deviceIdentifier =
      await storage.read(key: 'device_fingerprint');

  if (deviceIdentifier != null && deviceIdentifier.isNotEmpty) {
    options.headers['X-Device-Identifier'] = deviceIdentifier;
  }

  if (accessToken != null) {
    options.headers['Authorization'] = 'Bearer $accessToken';
  }

  if (accessToken != null && refreshToken != null) {
    options.headers['Cookie'] =
        'accessToken=$accessToken; refreshToken=$refreshToken';
  }

  return handler.next(options);
},

        // onRequest: (options, handler) async {
        //   final accessToken = await storage.read(key: "accessToken");
        //   final refreshToken = await storage.read(key: "refreshToken");

        //   if (accessToken != null) {
        //     options.headers['Authorization'] = 'Bearer $accessToken';
        //   }

        //   if (accessToken != null && refreshToken != null) {
        //     options.headers['Cookie'] =
        //         'accessToken=$accessToken; refreshToken=$refreshToken';
        //   }

        //   return handler.next(options);
        // },
      ),

      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        responseBody: true,
      ),
    ]);
  }
}
