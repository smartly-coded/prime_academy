// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:prime_academy/core/Utils/validators.dart';
// import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
// import 'package:prime_academy/features/authScreen/data/models/login_request_body.dart';
// import 'package:prime_academy/features/authScreen/logic/login_cubit.dart';
// import 'package:prime_academy/presentation/widgets/loginWidgets/loginBlocListener.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   bool _obscurePassword = true;

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final isTablet = size.width > 600;

//     return Scaffold(
//       backgroundColor: Mycolors.backgroundColor,
//       appBar: AppBar(
//         backgroundColor: Mycolors.backgroundColor,
//         elevation: 0,
//         leadingWidth: 180,
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 8.0),
//           child: Image.asset("assets/images/footer-logo.webp", height: 45),
//         ),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: context.read<LoginCubit>().formKey,
//             child: Container(
//               width: isTablet ? size.width * 0.5 : size.width * 0.9,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.15),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: Text(
//                       "البريد الإلكتروني",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: isTablet ? 18 : 16,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   TextFormField(
//                     controller: context.read<LoginCubit>().emailController,
//                     textAlign: TextAlign.right,
//                     style: const TextStyle(color: Colors.black),
//                     decoration: InputDecoration(
//                       filled: true,

//                       fillColor: const Color.fromARGB(255, 228, 230, 235),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                     validator: Validators.validateEmail,
//                   ),
//                   const SizedBox(height: 20),

//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: Text(
//                       "كلمة المرور",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: isTablet ? 18 : 16,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   TextFormField(
//                     controller: context.read<LoginCubit>().passwordController,
//                     obscureText: _obscurePassword,
//                     textAlign: TextAlign.right,
//                     style: const TextStyle(color: Colors.black),
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: const Color.fromARGB(255, 228, 230, 235),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _obscurePassword
//                               ? Icons.visibility_off
//                               : Icons.visibility,
//                           color: Colors.black,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _obscurePassword = !_obscurePassword;
//                           });
//                         },
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                     validator: Validators.validatePassword,
//                   ),
//                   const SizedBox(height: 30),

//                   Center(
//                     child: Container(
//                       width: isTablet ? size.width * 0.4 : size.width * 0.6,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         gradient: const LinearGradient(
//                           colors: [Color(0xff4f2349), Color(0xffa76433)],
//                         ),
//                       ),
//                       child: ElevatedButton(
//                         onPressed: () {
//                           if (context
//                               .read<LoginCubit>()
//                               .formKey
//                               .currentState!

//                               .validate()) {
//                             context.read<LoginCubit>().emitLoginStates(
//                               LoginRequestBody(
//                                 email: context
//                                     .read<LoginCubit>()
//                                     .emailController
//                                     .text,
//                                 password: context
//                                     .read<LoginCubit>()
//                                     .passwordController
//                                     .text,
//                               ),
//                             );
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.transparent,
//                           shadowColor: Colors.transparent,
//                           padding: const EdgeInsets.symmetric(vertical: 15),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                         ),
//                         child: Text(
//                           "تسجيل الدخول",
//                           style: TextStyle(
//                             fontSize: isTablet ? 20 : 18,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const LoginBlocListener(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/Utils/validators.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/authScreen/data/models/login_request_body.dart';
import 'package:prime_academy/features/authScreen/logic/login_cubit.dart';
import 'package:prime_academy/layout/custom_app_bar.dart';
import 'package:prime_academy/presentation/widgets/loginWidgets/loginBlocListener.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isSmallMobile = size.width < 350;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: CustomAppBar(user: null, showNotificationIcon: false),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallMobile ? 12 : 16,
            vertical: isSmallMobile ? 8 : 16,
          ),
          child: Form(
            key: context.read<LoginCubit>().formKey,
            child: Container(
              width: isTablet
                  ? size.width * 0.7
                  : isSmallMobile
                  ? size.width * 0.95
                  : size.width * 0.9,
              height: isTablet
                  ? size.height * 0.5
                  : isSmallMobile
                  ? null
                  : size.height * 0.5,
              padding: EdgeInsets.symmetric(
                horizontal: isSmallMobile ? 16 : 24,
                vertical: isSmallMobile ? 24 : 40,
              ),
              constraints: BoxConstraints(
                maxWidth: 500,
                minHeight: isSmallMobile ? 300 : 350,
              ),
              decoration: BoxDecoration(
                color: Mycolors.cardColor1,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Email Label
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        "البريد الإلكتروني",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTablet
                              ? 22
                              : isSmallMobile
                              ? 16
                              : 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isSmallMobile ? 8 : 12),

                  TextFormField(
                    controller: context.read<LoginCubit>().emailController,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallMobile ? 14 : 16,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Mycolors.cardColor1,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 5,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 207, 217, 236),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 207, 217, 236),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 207, 217, 236),
                          width: 1,
                        ),
                      ),
                    ),
                    validator: Validators.validateEmail,
                  ),
                  SizedBox(
                    height: isTablet
                        ? 24
                        : isSmallMobile
                        ? 16
                        : 20,
                  ),

                  // Password Label
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        "كلمة المرور",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTablet
                              ? 22
                              : isSmallMobile
                              ? 16
                              : 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isSmallMobile ? 8 : 12),

                  // Password Field
                  TextFormField(
                    controller: context.read<LoginCubit>().passwordController,
                    obscureText: _obscurePassword,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallMobile ? 14 : 16,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Mycolors.cardColor1,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 5,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: const Color(0xFF6B7280),
                          size: isSmallMobile ? 20 : 22,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 207, 217, 236),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 207, 217, 236),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 207, 217, 236),
                          width: 1,
                        ),
                      ),
                    ),
                    validator: Validators.validatePassword,
                  ),
                  SizedBox(
                    height: isTablet
                        ? 40
                        : isSmallMobile
                        ? 24
                        : 36,
                  ),

                  // Login Button
                  Container(
                    width: isTablet
                        ? size.width * 0.25
                        : isSmallMobile
                        ? size.width * 0.6
                        : size.width * 0.5,
                    height: isSmallMobile ? 45 : 50,
                    constraints: BoxConstraints(maxWidth: 300, minWidth: 200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: Mycolors.primary_color.colors,
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: const [0.0, 1.1],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD4636F).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (context
                            .read<LoginCubit>()
                            .formKey
                            .currentState!
                            .validate()) {
                          context.read<LoginCubit>().emitLoginStates(
                            LoginRequestBody(
                              email: context
                                  .read<LoginCubit>()
                                  .emailController
                                  .text,
                              password: context
                                  .read<LoginCubit>()
                                  .passwordController
                                  .text,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "تسجيل الدخول",
                        style: TextStyle(
                          fontSize: isTablet
                              ? 20
                              : isSmallMobile
                              ? 14
                              : 16,
                          color: Colors.white,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isSmallMobile ? 16 : 24),
                  const LoginBlocListener(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
