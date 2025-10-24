// import 'package:flutter/material.dart';
// import 'package:prime_academy/core/routing/app_routes.dart';
// import 'package:prime_academy/presentation/login/veiw/loginScreen.dart';
// import 'package:prime_academy/presentation/widgets/Start_Home_widget/video_player.dart';
// import 'package:prime_academy/presentation/widgets/homeWidgets/build_text.dart';
// import 'package:prime_academy/presentation/widgets/splashWidgets/build_text_withoutImage.dart';

// class TrophySection extends StatelessWidget {
//   const TrophySection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         buildTextWithBorder("نافس و تعلم", "هدفنا إخراج جيل جديد", context),
//         const SizedBox(height: 15),

//         Row(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [
//                     Color(0xffd67944),

//                     Color(0xff863868),
//                     Color(0xff51255b),
//                   ],
//                   begin: Alignment.topRight,
//                   end: Alignment.bottomLeft,
//                 ),
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: TextButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, AppRoutes.login);
//                 },
//                 style: TextButton.styleFrom(
//                   shadowColor: Color(0XFF222633),
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 25,
//                     vertical: 12,
//                   ),
//                 ),
//                 child: const Text(
//                   "ابدأ الآن",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontFamily: 'Cairo',
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(width: 20),
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: const LinearGradient(
//                       colors: [
//                         Color(0xffd67944),
//                         Color(0xff51255b),
//                         Color(0xff51255b),
//                       ],
//                       begin: Alignment.bottomLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                   ),
//                   child: Center(
//                     child: Container(
//                       width: 44,
//                       height: 44,
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Color(0XFF222633),
//                       ),
//                       child: IconButton(
//                         icon: const Icon(
//                           Icons.play_arrow,
//                           color: Colors.white,
//                           size: 28,
//                         ),
//                         onPressed: () {
//                           showVideoDialog(context);
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 const Text(
//                   "اعرف أكثر",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:prime_academy/core/routing/app_routes.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/video_player.dart';
import 'package:prime_academy/presentation/widgets/splashWidgets/build_text_withoutImage.dart';

class TrophySection extends StatelessWidget {
  const TrophySection({super.key});

  Future<void> _handleStartButton(BuildContext context) async {
    try {
      const storage = FlutterSecureStorage();
      
      // 1️⃣ اجيب الـ accessToken
      final accessToken = await storage.read(key: "accessToken");
      
      // 2️⃣ لو مافيش توكن، روح تسجيل دخول
      if (accessToken == null || accessToken.isEmpty) {
        print("⏩ No accessToken found, navigating to LoginScreen");
        if (context.mounted) {
          Navigator.pushNamed(context, AppRoutes.login);
        }
        return;
      }

      // 3️⃣ لو فيه توكن، اجيب بيانات المستخدم
      final userData = await storage.read(key: "userData");
      
      if (userData == null || userData.isEmpty) {
        print("⚠️ Token exists but no userData, navigating to login");
        // امسح التوكن لأنه مش مفيد بدون بيانات المستخدم
        await storage.delete(key: "accessToken");
        await storage.delete(key: "refreshToken");
        if (context.mounted) {
          Navigator.pushNamed(context, AppRoutes.login);
        }
        return;
      }

      // 4️⃣ حاول تحول الـ userData لـ LoginResponse
      try {
        final loginResponse = LoginResponse.fromJson(jsonDecode(userData));
        print("✅ Navigating to HomeScreen with user data");
        
        if (context.mounted) {
          Navigator.pushNamed(
            context,
            AppRoutes.Home,
            arguments: loginResponse,
          );
        }
      } catch (parseError) {
        print("❌ Error parsing userData: $parseError");
        // لو فشل الـ parsing، امسح كل حاجة وروح login
        await storage.delete(key: "userData");
        await storage.delete(key: "accessToken");
        await storage.delete(key: "refreshToken");
        
        if (context.mounted) {
          Navigator.pushNamed(context, AppRoutes.login);
        }
      }
    } catch (e) {
      print("❌ Error in _handleStartButton: $e");
      if (context.mounted) {
        Navigator.pushNamed(context, AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTextWithBorder("نافس و تعلم", "هدفنا إخراج جيل جديد", context),
        const SizedBox(height: 15),
        Row(
          children: [
            // زر "ابدأ الآن"
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xffd67944),
                    Color(0xff863868),
                    Color(0xff51255b),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextButton(
                onPressed: () => _handleStartButton(context),
                style: TextButton.styleFrom(
                  shadowColor: const Color(0XFF222633),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  "ابدأ الآن",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            
            // زر "اعرف أكثر" مع الفيديو
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xffd67944),
                        Color(0xff51255b),
                        Color(0xff51255b),
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0XFF222633),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () {
                          showVideoDialog(context);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  "اعرف أكثر",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}