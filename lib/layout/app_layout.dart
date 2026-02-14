
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:prime_academy/core/di/dependency_injection.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/core/routing/app_routes.dart';
import 'package:prime_academy/features/Notification/logic/notification_cubit.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/features/authScreen/logic/login_cubit.dart';
import 'package:prime_academy/features/startScreen/data/repos/start_screen_repo.dart';
import 'package:prime_academy/features/startScreen/logic/certificate_cubit.dart';
import 'package:prime_academy/features/startScreen/logic/start_screen_cubit.dart';
import 'package:prime_academy/layout/custom_app_bar.dart';
import 'package:prime_academy/presentation/ContactUs/ContactUs_page.dart';
import 'package:prime_academy/presentation/Notification/notification_screen.dart';
import 'package:prime_academy/presentation/Start_homeScreen/start-screen.dart';
import 'package:prime_academy/presentation/about/about.dart';
import 'nav_items.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key, this.user});
  final LoginResponse? user;

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _currentIndex = 0;
  LoginResponse? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (widget.user != null) {
      setState(() {
        _currentUser = widget.user;
      });
      return;
    }

    final loginCubit = context.read<LoginCubit>();
    final savedUser = await loginCubit.loadSavedUser();

    if (savedUser != null) {
      setState(() {
        _currentUser = savedUser;
      });

      loginCubit.currentUser = savedUser;
    }
  }

  final List<Widget> _pages = [
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              StartScreenCubit(getIt<StartScreenRepo>())
                ..emitAllStudentsState(),
        ),
        BlocProvider(
          create: (context) =>
              CertificateCubit(getIt<StartScreenRepo>())
                ..emitCertificateState(),
        ),
      ],
      child: StartPage(),
    ),
    AboutUsPage(),
    ContactUsPage(),
  ];

  Future<void> _handleAccountButton() async {
    try {
      const storage = FlutterSecureStorage();
      final accessToken = await storage.read(key: "accessToken");

      if (accessToken == null || accessToken.isEmpty) {
        print("⏩ No accessToken, navigating to LoginScreen");
        if (mounted) {
          Navigator.pushNamed(context, AppRoutes.login);
        }
        return;
      }

      final userData = await storage.read(key: "userData");

      if (userData == null || userData.isEmpty) {
        print("⚠️ Token exists but no userData, navigating to login");
        await storage.delete(key: "accessToken");
        await storage.delete(key: "refreshToken");
        if (mounted) {
          Navigator.pushNamed(context, AppRoutes.login);
        }
        return;
      }

      try {
        final loginResponse = LoginResponse.fromJson(jsonDecode(userData));
        print("✅ Navigating to HomeScreen from AppLayout");

        if (mounted) {
          Navigator.pushNamed(
            context,
            AppRoutes.Home,
            arguments: loginResponse,
          );
        }
      } catch (parseError) {
        print("❌ Error parsing userData: $parseError");
        await storage.delete(key: "userData");
        await storage.delete(key: "accessToken");
        await storage.delete(key: "refreshToken");

        if (mounted) {
          Navigator.pushNamed(context, AppRoutes.login);
        }
      }
    } catch (e) {
      print("❌ Error in _handleAccountButton: $e");
      if (mounted) {
        Navigator.pushNamed(context, AppRoutes.login);
      }
    }
  }

  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0b0f12),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: CustomAppBar(
              user: _currentUser,
              onAccountPressed: _handleAccountButton,
              showBackArrow: false,
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _pages[_currentIndex],
              childCount: 1,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.black,
        items: bottomNavItems,
      ),
    );
  }
}
