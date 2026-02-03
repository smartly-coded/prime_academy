import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DeviceFingerprintHelper {
  static const _storage = FlutterSecureStorage();
  static const String _storageKey = 'device_fingerprint';

  /// Generate or retrieve cached device fingerprint
  static Future<String> getDeviceFingerprint() async {
    // Check if already cached
    final cached = await _storage.read(key: _storageKey);
    if (cached != null && cached.isNotEmpty) {
      print('✅ Using cached device fingerprint: $cached');
      return cached;
    }

    // Generate new fingerprint
    final fingerprint = await _generateFingerprint();
    await _storage.write(key: _storageKey, value: fingerprint);
    print('✅ Generated new device fingerprint: $fingerprint');
    return fingerprint;
  }

  /// Generate unique device fingerprint
  static Future<String> _generateFingerprint() async {
    final deviceInfo = DeviceInfoPlugin();
    String identifier;

    try {
      if (kIsWeb) {
        final webInfo = await deviceInfo.webBrowserInfo;
        identifier = '${webInfo.userAgent}_${webInfo.vendor}_${webInfo.platform}';
      } else if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        identifier = '${androidInfo.id}_${androidInfo.model}_${androidInfo.brand}_${androidInfo.device}';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        identifier = '${iosInfo.identifierForVendor}_${iosInfo.model}_${iosInfo.systemVersion}';
      } else {
        identifier = 'unknown_${DateTime.now().millisecondsSinceEpoch}';
      }

      // Create SHA-256 hash
      final bytes = utf8.encode(identifier);
      final hash = sha256.convert(bytes);
      return hash.toString();
    } catch (e) {
      print('❌ Error generating fingerprint: $e');
      // Fallback to timestamp-based identifier
      final fallback = 'fallback_${DateTime.now().millisecondsSinceEpoch}';
      final bytes = utf8.encode(fallback);
      final hash = sha256.convert(bytes);
      return hash.toString();
    }
  }

  /// Clear cached fingerprint (useful for logout/testing)
  static Future<void> clearFingerprint() async {
    await _storage.delete(key: _storageKey);
    print('✅ Device fingerprint cleared');
  }
}