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
        width: 150,
        height: 44,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFD67944), // Orange on left
              Color(0xFF863868), // Medium purple-pink in middle
              Color(0xFF51255B), // Dark purple on right
            ],
          ),
          borderRadius: BorderRadius.circular(100), // rounded-full
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(0, 10),
              blurRadius: 15,
              spreadRadius: -3,
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(0, 4),
              blurRadius: 6,
              spreadRadius: -4,
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "تسجيل الخروج",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.logout, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
