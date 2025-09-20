import 'package:prime_academy/features/authScreen/data/models/login_response.dart';

class ChatInfoModel {
  final int id;
  final String name;
  final String? imageUrl;

  ChatInfoModel({
    required this.id,
    required this.name,
    this.imageUrl,
  });

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
      name:fullName ,
      imageUrl: user.image?.url,
    );
  }
}
