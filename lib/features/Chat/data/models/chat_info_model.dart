

import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/features/CoursesModules/data/models/module_lessons_response_model.dart';

class ChatInfoModel {
  final int id;
  final String name;
  final String? imageUrl;

  final int? teacherId;
  final String? teacherName;
  final String? teacherImageUrl;

  ChatInfoModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.teacherId,
    this.teacherName,
    this.teacherImageUrl,
  });

  // factory ChatInfoModel.fromLoginResponse(LoginResponse user) {
  //   String fullName = "";
  //   if ((user.firstname != null && user.firstname!.isNotEmpty) ||
  //       (user.lastname != null && user.lastname!.isNotEmpty)) {
  //     fullName = "${user.firstname ?? ""} ${user.lastname ?? ""}".trim();
  //   } else {
  //     fullName = user.username ?? "طالب";
  //   }

  //   return ChatInfoModel(
  //     id: user.id ?? 0,
  //     name: fullName,
  //     imageUrl: user.image?.url,
  //   );
  // }
  // ✅ للـ login response (بدون صورة)
factory ChatInfoModel.fromLoginResponse(LoginResponse user) {
  print("========== LOGIN RESPONSE DEBUG ==========");
  print("User ID: ${user.id}");
  print("Note: Login response doesn't include image");
  print("==========================================");
  
  String fullName = "";
  if ((user.firstname != null && user.firstname!.isNotEmpty) ||
      (user.lastname != null && user.lastname!.isNotEmpty)) {
    fullName = "${user.firstname ?? ""} ${user.lastname ?? ""}".trim();
  } else {
    fullName = user.username ?? "طالب";
  }

  return ChatInfoModel(
    id: user.id ?? 0,
    name: fullName,
    imageUrl: null, // ❌ Login response مفيهوش صورة
  );
}

// ✅ للـ profile response (فيه صورة)
factory ChatInfoModel.fromProfileResponse(dynamic profile) {
  print("========== PROFILE RESPONSE DEBUG ==========");
  print("User ID: ${profile['id']}");
  print("Raw image object: ${profile['image']}");
  print("Raw image URL: ${profile['image']?['url']}");
  
  String fullName = "";
  String? firstname = profile['firstname'];
  String? lastname = profile['lastname'];
  
  if ((firstname != null && firstname.isNotEmpty) ||
      (lastname != null && lastname.isNotEmpty)) {
    fullName = "${firstname ?? ""} ${lastname ?? ""}".trim();
  } else {
    fullName = profile['username'] ?? "طالب";
  }

  // ✅ بناء الـ URL الكامل للصورة
  String? imageUrl = profile['image']?['url'];
  print("Before processing imageUrl: $imageUrl");
  
  if (imageUrl != null && imageUrl.isNotEmpty) {
    if (!imageUrl.startsWith('http')) {
      const String cdnPrefix = "https://cdn.primeacademy.education/primeacademy";
      imageUrl = imageUrl.startsWith('/') ? "$cdnPrefix$imageUrl" : "$cdnPrefix/$imageUrl";
    }
  }
  
  print("After processing imageUrl: $imageUrl");
  print("============================================");

  return ChatInfoModel(
    id: profile['id'] ?? 0,
    name: fullName,
    imageUrl: imageUrl,
  );
}

  ChatInfoModel copyWithTeacher(Teacher teacher) {
    return ChatInfoModel(
      id: id,
      name: name,
      imageUrl: imageUrl,
      teacherId: teacher.id,
      teacherName: "${teacher.firstname} ${teacher.lastname}".trim(),
      
      teacherImageUrl: teacher.image?.url ,
    );



  }

 
  ChatInfoModel copyWithTeacherData({
    required int teacherId,
    required String teacherName,
    required String? teacherImageUrl,
  }) {
    return ChatInfoModel(
      id: id,
      name: name,
      imageUrl: imageUrl,
      teacherId: teacherId,
      teacherName: teacherName,
      teacherImageUrl: teacherImageUrl,
    );
  }
  
}
