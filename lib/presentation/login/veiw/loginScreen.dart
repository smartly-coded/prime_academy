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
  bool _isGradientFlipped = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isSmallMobile = size.width < 350;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),

      body: Column(
        children: [
          CustomAppBar(
            user: null,
            showNotificationIcon: false,
            showBackArrow: true,
          ),
          SizedBox(height: isSmallMobile ? 80 : 150),
          Center(
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            " الإيميل",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet
                                  ? 22
                                  : isSmallMobile
                                  ? 16
                                  : 18,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: isSmallMobile ? 8 : 12),

                      Container(
                        height: 40,
                        child: TextFormField(
                          controller: context
                              .read<LoginCubit>()
                              .emailController,
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
                      ),
                      SizedBox(
                        height: isTablet
                            ? 24
                            : isSmallMobile
                            ? 16
                            : 20,
                      ),

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
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: isSmallMobile ? 8 : 12),

                      Container(
                        height: 40,
                        child: TextFormField(
                          controller: context
                              .read<LoginCubit>()
                              .passwordController,
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
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: const Color.fromARGB(255, 217, 218, 220),
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
                      ),
                      SizedBox(
                        height: isTablet
                            ? 40
                            : isSmallMobile
                            ? 24
                            : 36,
                      ),

                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        width: isTablet
                            ? size.width * 0.25
                            : isSmallMobile
                            ? size.width * 0.6
                            : size.width * 0.5,
                        height: isSmallMobile ? 45 : 50,
                        constraints: BoxConstraints(
                          maxWidth: 300,
                          minWidth: 200,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: _isGradientFlipped
                                ? Mycolors.primary_color.colors.reversed
                                      .toList()
                                : Mycolors.primary_color.colors,
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            stops: const [0.0, 1.1],
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isGradientFlipped = !_isGradientFlipped;
                            });

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
        ],
      ),
    );
  }
}
