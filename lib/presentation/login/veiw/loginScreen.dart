import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/Utils/validators.dart';
import 'package:prime_academy/features/authScreen/data/models/login_request_body.dart';
import 'package:prime_academy/features/authScreen/logic/login_cubit.dart';
import 'package:prime_academy/features/authScreen/logic/login_state.dart';
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

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leadingWidth: 180,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Image.asset("lib/assets/images/footer-logo.webp", height: 45),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 160),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: context.read<LoginCubit>().formKey,
            child: Container(
              width: isTablet ? size.width * 0.5 : size.width * 0.9,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "البريد الإلكتروني",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 18 : 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: context.read<LoginCubit>().emailController,
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,

                      fillColor: const Color.fromARGB(255, 228, 230, 235),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: Validators.validateEmail,
                  ),
                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "كلمة المرور",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 18 : 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: context.read<LoginCubit>().passwordController,
                    obscureText: _obscurePassword,
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 228, 230, 235),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: Validators.validatePassword,
                  ),
                  const SizedBox(height: 30),

                  Center(
                    child: Container(
                      width: isTablet ? size.width * 0.4 : size.width * 0.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          colors: [Color(0xff4f2349), Color(0xffa76433)],
                        ),
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
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          "تسجيل الدخول",
                          style: TextStyle(
                            fontSize: isTablet ? 20 : 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
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
