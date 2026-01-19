
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  void emitLoginStates(LoginRequestBody loginRequestBody) async {
    emit(const LoginState.loading());
    
    
    final loginRequest = LoginRequestBody(
      email: emailController.text,
      password: passwordController.text,
    );
    
    final response = await _loginRepo.login(loginRequest);
    
    response.when(
      success: (loginResponse) async {
        currentUser = loginResponse;
        
        try {
          await _storage.write(
            key: "userData",
            value: jsonEncode(loginResponse.toJson()),
          );
          print("✅ User data saved successfully");
        } catch (e) {
          print("❌ Error saving user data: $e");
        }
        
        emit(LoginState.success(loginResponse));
      },
      failure: (error) {
        emit(LoginState.error(error: error.apiErrorModel.message ?? ''));
      },
    );
  }

  Future<LoginResponse?> loadSavedUser() async {
    try {
      final userData = await _storage.read(key: "userData");
      if (userData != null && userData.isNotEmpty) {
        return LoginResponse.fromJson(jsonDecode(userData));
      }
    } catch (e) {
      print("❌ Error loading saved user: $e");
    }
    return null;
  }

  Future<void> clearUserData() async {
    try {
      await _storage.delete(key: "userData");
      await _storage.delete(key: "accessToken");
      await _storage.delete(key: "refreshToken");
      currentUser = null;
      print("✅ User data cleared successfully");
    } catch (e) {
      print("❌ Error clearing user data: $e");
    }
  }
}