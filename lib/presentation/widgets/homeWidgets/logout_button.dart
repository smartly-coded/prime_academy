import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final bool isMobile;
  const LogoutButton({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xffa76433), Color(0xff4f2349)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.logout, color: Colors.white, size: 18),
            const SizedBox(width: 5),
            Text(
              "تسجيل الخروج",
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                color: Colors.white,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
