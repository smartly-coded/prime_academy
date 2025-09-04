
import 'package:flutter/material.dart';
import 'package:prime_academy/presentation/login/veiw/loginScreen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF0f1217),
      appBar: AppBar(
        backgroundColor: const Color(0XFF0f1217),
        title: const Text("Home", style: TextStyle(color: Colors.white)),
        actions: [
          Container(
            padding: EdgeInsets.all(2),
            width: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff4f2349), Color(0xffa76433)],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              width: 60,

              //padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Color(0XFF0f1217), // لون الخلفية الداخلية
                borderRadius: BorderRadius.circular(
                  15,
                ), // أصغر من الخارجي بـ 3px
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          "مرحباً بك في الصفحة الرئيسية 👋",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
