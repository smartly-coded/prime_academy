import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:prime_academy/core/helpers/Device%20Fingerprint%20Helper.dart';
import 'package:prime_academy/core/networking/api_result.dart';
import 'package:prime_academy/features/authScreen/data/models/login_request_body.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/features/authScreen/data/repos/login_repo.dart';
import 'package:prime_academy/features/authScreen/logic/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo _loginRepo;
  LoginResponse? currentUser;
  final _storage = const FlutterSecureStorage();

  LoginCubit(this._loginRepo) : super(LoginState.initial());

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // void emitLoginStates(LoginRequestBody loginRequestBody) async {
  //   emit(const LoginState.loading());

  //   final loginRequest = LoginRequestBody(
  //     email: emailController.text,
  //     password: passwordController.text,
  //   );

  //   final response = await _loginRepo.login(loginRequest);

  //   response.when(
  //     success: (loginResponse) async {
  //       currentUser = loginResponse;

  //       try {
  //         await _storage.write(
  //           key: "userData",
  //           value: jsonEncode(loginResponse.toJson()),
  //         );
  //         print("✅ User data saved successfully");
  //       } catch (e) {
  //         print("❌ Error saving user data: $e");
  //       }

  //       emit(LoginState.success(loginResponse));
  //     },
  //     failure: (error) {
  //       emit(LoginState.error(error: error.apiErrorModel.message ?? ''));
  //     },
  //   );
  // }
void emitLoginStates(LoginRequestBody loginRequestBody) async {
  emit(const LoginState.loading());

  // Ensure device fingerprint exists before login
  try {
    await DeviceFingerprintHelper.getDeviceFingerprint();
  } catch (e) {
    print('❌ Failed to generate device fingerprint: $e');
    emit(LoginState.error(error: 'فشل في التحقق من الجهاز'));
    return;
  }

  final loginRequest = LoginRequestBody(
    email: emailController.text,
    password: passwordController.text,
  );

  final response = await _loginRepo.login(loginRequest);

  response.when(
    success: (loginResponse) async {
  currentUser = loginResponse;

  try {
    // ✅ اجلبي البروفايل عشان تاخدي الصورة
    final profile = await _loginRepo.getMyProfile();
     print('🔴 Profile result: $profile');
    print('🔴 Profile image: ${profile?.image}');
    print('🔴 Profile image url: ${profile?.image?.url}');
    
    final imageUrl = profile?.image?.url; // ✅ عدليها حسب اسم الـ field

    await _storage.write(
      key: "userData",
      value: jsonEncode({
        'id': loginResponse.id,
        'firstname': loginResponse.firstname,
        'lastname': loginResponse.lastname,
        'username': loginResponse.username,
        'email': loginResponse.email,
        'role': loginResponse.role,
        'image': imageUrl, // ✅ URL مباشرة
      }),
    );
    print("✅ User data saved with image: $imageUrl");
  } catch (e) {
    print("❌ Error: $e");
  }

  emit(LoginState.success(loginResponse));
},
    //   try {
    //     await _storage.write(
    //       key: "userData",
    //       value: jsonEncode(loginResponse.toJson()),
    //     );
    //     print("✅ User data saved successfully");
    //   } catch (e) {
    //     print("❌ Error saving user data: $e");
    //   }

    //   emit(LoginState.success(loginResponse));
    // },
    failure: (error) {
      emit(LoginState.error(error: error.apiErrorModel.message ?? ''));
    },
  );
}
Future<LoginResponse?> loadSavedUser() async {
  try {
    final userData = await _storage.read(key: "userData");
    if (userData != null && userData.isNotEmpty) {
      final Map<String, dynamic> json = jsonDecode(userData);
      
      // ✅ الـ image محفوظ كـ String مش Map
      final imageUrl = json['image'];
      if (imageUrl != null && imageUrl is String) {
        json['image'] = {'url': imageUrl}; // ✅ حوله لـ Map
      }
      
      return LoginResponse.fromJson(json);
    }
  } catch (e) {
    print("❌ Error loading saved user: $e");
  }
  return null;
}
  // Future<LoginResponse?> loadSavedUser() async {
  //   try {
  //     final userData = await _storage.read(key: "userData");
  //     if (userData != null && userData.isNotEmpty) {
  //       return LoginResponse.fromJson(jsonDecode(userData));
  //     }
  //   } catch (e) {
  //     print("❌ Error loading saved user: $e");
  //   }
  //   return null;
  // }

  Future<void> clearUserData() async {
    try {
      await _storage.delete(key: "userData");
      await _storage.delete(key: "accessToken");
      await _storage.delete(key: "refreshToken");
      await _storage.delete(key: "deviceToken");
      currentUser = null;
      print("✅ User data cleared successfully");
    } catch (e) {
      print("❌ Error clearing user data: $e");
    }
  }
}
