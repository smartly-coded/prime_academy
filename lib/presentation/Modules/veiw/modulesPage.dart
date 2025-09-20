import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/CoursesModules/data/repo/modules_repository.dart';
import 'package:prime_academy/features/CoursesModules/logic/modules_cubit.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/module_tile.dart';

class ModulesPage extends StatelessWidget {
  final int courseId;
  final String courseName;
    final LoginResponse user;

  const ModulesPage({
    super.key,
    required this.courseId,
    required this.courseName,required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ModulesCubit(ModulesRepository())..loadModules(courseId),
      child: Scaffold(
        backgroundColor: Mycolors.backgroundColor,
        appBar: AppBar(
          backgroundColor: Mycolors.backgroundColor,
          elevation: 0,
          title: Image.asset("assets/images/footer-logo.webp", height: 40),
          actions: [
            Container(
              padding: const EdgeInsets.all(2),
              width: 70,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff4f2349), Color(0xffa76433)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0XFF0f1217),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "حسابي",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocBuilder<ModulesCubit, ModulesState>(
          builder: (context, state) {
            if (state is ModulesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ModulesLoaded) {
              final course = state.course;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: Mycolors.module_card,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          courseName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ...course.modules.map(
                      (module) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ModuleTile(module: module, courseId: courseId, user: user, ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ModulesError) {
              return Center(child: Text("Error: ${state.message}"));
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
