import 'package:flutter/material.dart';
import 'package:prime_academy/core/routing/app_routes.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/build_text.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/three_tabs_widget.dart';

class HomeScreen extends StatelessWidget {
  final LoginResponse? user;
  const HomeScreen({super.key, this.user});

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
            width: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff4f2349), Color(0xffa76433)],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              width: 80,

              //padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Color(0XFF0f1217), // لون الخلفية الداخلية
                borderRadius: BorderRadius.circular(
                  15,
                ), // أصغر من الخارجي بـ 3px
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.login);
                },
                child: const Text(
                  "تسجيل الخروج",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          buildText("مرحبا", "${user!.firstname} ${user!.lastname}", context),
          ThreeTabsWidget(),
        ],
      ),
    );
  }
}
