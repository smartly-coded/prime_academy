// import 'package:dio/dio.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';
// import 'package:prime_academy/core/helpers/Device%20Fingerprint%20Helper.dart';
// import 'package:prime_academy/core/networking/Interceptor.dart';

// class DioFactory {
//   DioFactory._();

//   static Dio? dio;

//   static Dio getDio() {
//     Duration timeOut = const Duration(seconds: 30);

//     if (dio == null) {
//       dio = Dio();
//       dio!
//         ..options.connectTimeout = timeOut
//         ..options.receiveTimeout = timeOut;
//       addDioHeader();
//       addDioInterceptor();
//       return dio!;
//     } else {
//       return dio!;
//     }
//   }

//   static void addDioHeader() async {
//     dio?.options.headers = {"Accept": "application/json"};
//   }

//   static void addDioInterceptor() {
//     final storage = const FlutterSecureStorage();
//     dio?.interceptors.addAll([
//       LoadingInterceptor(),
//       InterceptorsWrapper(
//         onRequest: (options, handler) async {
//           // 1. Add Device Fingerprint (ALWAYS)
//           try {
//             final deviceIdentifier =
//                 await DeviceFingerprintHelper.getDeviceFingerprint();
//             if (deviceIdentifier.isNotEmpty) {
//               options.headers['X-Device-Identifier'] = deviceIdentifier;
//               print('✅ Added X-Device-Identifier: $deviceIdentifier');
//             }
//           } catch (e) {
//             print('❌ Error getting device fingerprint: $e');
//           }

//           // 2. Add Auth Tokens (if available)
//           final accessToken = await storage.read(key: "accessToken");
//           final refreshToken = await storage.read(key: "refreshToken");

//           if (accessToken != null) {
//             options.headers['Authorization'] = 'Bearer $accessToken';
//           }

//           if (accessToken != null && refreshToken != null) {
//             options.headers['Cookie'] =
//                 'accessToken=$accessToken; refreshToken=$refreshToken';
//           }

//           return handler.next(options);
//         },
//         onResponse: (response, handler) async {
//           final cookies = response.headers['Set-Cookie'];
//           if (cookies != null) {
//             for (var cookie in cookies) {
//               if (cookie.contains("accessToken=")) {
//                 final accessToken = cookie
//                     .split("accessToken=")
//                     .last
//                     .split(";")
//                     .first;
//                 await storage.write(key: "accessToken", value: accessToken);
//               }
//               if (cookie.contains("refreshToken=")) {
//                 final refreshToken = cookie
//                     .split("refreshToken=")
//                     .last
//                     .split(";")
//                     .first;
//                 await storage.write(key: "refreshToken", value: refreshToken);
//               }
//             }
//           }
//           return handler.next(response);
//         },
//       ),
//       PrettyDioLogger(
//         requestBody: true,
//         requestHeader: true,
//         responseHeader: true,
//         responseBody: true,
//       ),
//     ]);
//   }
//   //   static void addDioInterceptor() {
//   //     final storage = const FlutterSecureStorage();
//   //     dio?.interceptors.addAll([
//   //       LoadingInterceptor(),
//   //       InterceptorsWrapper(
//   //         onResponse: (response, handler) async {
//   //           final cookies = response.headers['Set-Cookie'];
//   //           if (cookies != null) {
//   //             for (var cookie in cookies) {
//   //               if (cookie.contains("accessToken=")) {
//   //                 final accessToken = cookie
//   //                     .split("accessToken=")
//   //                     .last
//   //                     .split(";")
//   //                     .first;
//   //                 await storage.write(key: "accessToken", value: accessToken);
//   //               }
//   //               if (cookie.contains("refreshToken=")) {
//   //                 final refreshToken = cookie
//   //                     .split("refreshToken=")
//   //                     .last
//   //                     .split(";")
//   //                     .first;
//   //                 await storage.write(key: "refreshToken", value: refreshToken);
//   //               }
//   //             }
//   //           }
//   //           return handler.next(response);
//   //         },
//   //         onRequest: (options, handler) async {
//   //   final accessToken = await storage.read(key: "accessToken");
//   //   final refreshToken = await storage.read(key: "refreshToken");

//   //   final deviceIdentifier =
//   //       await storage.read(key: 'device_fingerprint');

//   //   if (deviceIdentifier != null && deviceIdentifier.isNotEmpty) {
//   //     options.headers['X-Device-Identifier'] = deviceIdentifier;
//   //   }

//   //   if (accessToken != null) {
//   //     options.headers['Authorization'] = 'Bearer $accessToken';
//   //   }

//   //   if (accessToken != null && refreshToken != null) {
//   //     options.headers['Cookie'] =
//   //         'accessToken=$accessToken; refreshToken=$refreshToken';
//   //   }

//   //   return handler.next(options);
//   // },

//   //         // onRequest: (options, handler) async {
//   //         //   final accessToken = await storage.read(key: "accessToken");
//   //         //   final refreshToken = await storage.read(key: "refreshToken");

//   //         //   if (accessToken != null) {
//   //         //     options.headers['Authorization'] = 'Bearer $accessToken';
//   //         //   }

//   //         //   if (accessToken != null && refreshToken != null) {
//   //         //     options.headers['Cookie'] =
//   //         //         'accessToken=$accessToken; refreshToken=$refreshToken';
//   //         //   }

//   //         //   return handler.next(options);
//   //         // },
//   //       ),

//   //       PrettyDioLogger(
//   //         requestBody: true,
//   //         requestHeader: true,
//   //         responseHeader: true,
//   //         responseBody: true,
//   //       ),
//   //     ]);
//   //   }
// }
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:prime_academy/core/helpers/Device%20Fingerprint%20Helper.dart';
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
        onRequest: (options, handler) async {
          // 1. Add Device Fingerprint (ALWAYS)
          try {
            final deviceIdentifier =
                await DeviceFingerprintHelper.getDeviceFingerprint();
            if (deviceIdentifier.isNotEmpty) {
              options.headers['X-Device-Identifier'] = deviceIdentifier;
              print('✅ Added X-Device-Identifier: $deviceIdentifier');
            }
          } catch (e) {
            print('❌ Error getting device fingerprint: $e');
          }

          // 2. Add Device Token (if available)
          final deviceToken = await storage.read(key: "deviceToken");
          if (deviceToken != null && deviceToken.isNotEmpty) {
            options.headers['X-Device-Identifier'] = deviceToken;
            print('✅ Added X-Device-Identifier');
          }

          // 3. Add Auth Tokens (if available)
          final accessToken = await storage.read(key: "accessToken");
          final refreshToken = await storage.read(key: "refreshToken");

          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }

          if (accessToken != null && refreshToken != null) {
            options.headers['Cookie'] =
                'accessToken=$accessToken; refreshToken=$refreshToken';
          }

          return handler.next(options);
        },
        onResponse: (response, handler) async {
          // 1. Extract and save cookies
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
                print('✅ Saved accessToken');
              }
              if (cookie.contains("refreshToken=")) {
                final refreshToken = cookie
                    .split("refreshToken=")
                    .last
                    .split(";")
                    .first;
                await storage.write(key: "refreshToken", value: refreshToken);
                print('✅ Saved refreshToken');
              }
            }
          }

          // 2. Extract and save deviceToken from response body (for login)
          try {
            if (response.data != null && response.data is Map) {
              final deviceToken = response.data['deviceToken'];
              if (deviceToken != null && deviceToken.toString().isNotEmpty) {
                await storage.write(key: "deviceToken", value: deviceToken.toString());
                print('✅ Saved deviceToken: ${deviceToken.toString().substring(0, 20)}...');
              }
            }
          } catch (e) {
            print('⚠️ Could not extract deviceToken from response: $e');
          }

          return handler.next(response);
        },
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