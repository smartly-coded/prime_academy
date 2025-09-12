// module_model.dart
import 'package:prime_academy/features/CoursesModules/data/models/module_model.dart';

class CourseModel {
  final String courseName;
  final List<ModuleModel> modules;

  CourseModel({required this.courseName, required this.modules});

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      courseName: json['course_name'] ?? '',
      modules: (json['modules'] as List)
          .map((e) => ModuleModel.fromJson(e))
          .toList(),
    );
  }
}
