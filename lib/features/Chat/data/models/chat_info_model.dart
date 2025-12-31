// import 'package:prime_academy/features/authScreen/data/models/login_response.dart';

// class ChatInfoModel {
//   final int id;
//   final String name;
//   final String? imageUrl;

//   ChatInfoModel({
//     required this.id,
//     required this.name,
//     this.imageUrl,
//   });

//   factory ChatInfoModel.fromLoginResponse(LoginResponse user) {

//     String fullName = "";
//   if ((user.firstname != null && user.firstname!.isNotEmpty) ||
//       (user.lastname != null && user.lastname!.isNotEmpty)) {
//     fullName = "${user.firstname ?? ""} ${user.lastname ?? ""}".trim();
//   } else {
//     fullName = user.username ?? "طالب";
//   }

//     return ChatInfoModel(
//       id: user.id ?? 0,
//       name:fullName ,
//       imageUrl: user.image?.url,
//     );
//   }
// }


import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/features/CoursesModules/data/models/module_lessons_response_model.dart';

class ChatInfoModel {
  final int id;
  final String name;
  final String? imageUrl;
  
  // ⭐ بيانات المعلم
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

  // من بيانات الطالب
  factory ChatInfoModel.fromLoginResponse(LoginResponse user) {
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
      imageUrl: user.image?.url,
    );
  }

  // ⭐ إضافة بيانات المعلم
  ChatInfoModel copyWithTeacher(Teacher teacher) {
    return ChatInfoModel(
      id: id,
      name: name,
      imageUrl: imageUrl,
      teacherId: teacher.id,
      teacherName: "${teacher.firstname} ${teacher.lastname}".trim(),
      teacherImageUrl: teacher.image.url,
    );
  }
}