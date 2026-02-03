import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prime_academy/features/CoursesModules/data/models/module_lessons_response_model.dart';

class TeacherCacheService {
  static const String _keyPrefix = 'teacher_data_chat_';

  static Future<void> saveTeacherData(int chatId, Teacher teacher) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_keyPrefix$chatId';

    final data = {
      'id': teacher.id,
      'firstname': teacher.firstname,
      'lastname': teacher.lastname,
      'role': teacher.role,
      'imageUrl': teacher.image?.url ,
    };

    await prefs.setString(key, jsonEncode(data));
    print('✅ تم حفظ بيانات المعلم للشات: $chatId');
  }

  static Future<Map<String, dynamic>?> getTeacherData(int chatId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_keyPrefix$chatId';
    final data = prefs.getString(key);

    if (data != null) {
      print('✅ تم قراءة بيانات المعلم من الكاش للشات: $chatId');
      return jsonDecode(data);
    }

    print('⚠️ لا توجد بيانات معلم محفوظة للشات: $chatId');
    return null;
  }

 
  static Future<void> clearTeacherData(int chatId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_keyPrefix$chatId';
    await prefs.remove(key);
  }

  
  static Future<void> clearAllTeacherData() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith(_keyPrefix));
    for (var key in keys) {
      await prefs.remove(key);
    }
  }
}
