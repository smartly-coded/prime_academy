
import 'package:json_annotation/json_annotation.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

part 'login_request_body.g.dart';

@JsonSerializable()
class LoginRequestBody {
  final String email;
  final String password;
  @JsonKey(name: 'deviceType')
  final String deviceType;

  LoginRequestBody({
    required this.email,
    required this.password,
    String? deviceType,
  }) : deviceType = deviceType ?? _getDeviceType();

  
  static String _getDeviceType() {
    if (kIsWeb) {
      return 'web';
    } else if (Platform.isAndroid) {
      return 'android';
    } else if (Platform.isIOS) {
      return 'ios';
    }
    return 'unknown';
  }

  Map<String, dynamic> toJson() => _$LoginRequestBodyToJson(this);
}
