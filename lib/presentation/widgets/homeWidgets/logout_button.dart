import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';

class LogoutButton extends StatelessWidget {
  final bool isMobile;
  const LogoutButton({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        const storage = FlutterSecureStorage();
        await storage.delete(key: "accessToken");
        await storage.delete(key: "refreshToken");
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Mycolors.primary_color.colors,
            begin: Alignment.topRight,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "تسجيل الخروج",
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 5),

            const Icon(Icons.logout, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}
