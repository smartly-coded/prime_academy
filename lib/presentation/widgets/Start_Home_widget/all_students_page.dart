import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/startScreen/logic/start_screen_cubit.dart';
import 'package:prime_academy/features/startScreen/logic/start_screen_state.dart';
import 'package:prime_academy/layout/app_layout.dart';
import 'package:prime_academy/layout/custom_app_bar.dart';
import 'package:prime_academy/presentation/Start_homeScreen/student_detail_screen.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/search_feild.dart';

class AllStudentsPage extends StatefulWidget {
  const AllStudentsPage({super.key});

  @override
  State<AllStudentsPage> createState() => _AllStudentsPageState();
}

class _AllStudentsPageState extends State<AllStudentsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  int _getCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width >= 1000) return 4;
    if (width >= 700) return 3;
    if (width >= 500) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mycolors.backgroundColor,
      appBar: CustomAppBar(
        user: null,
        showNotificationIcon: false,
        onLogoPressed: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AppLayout(user: null)),
          (route) => false,
        ), showBackArrow: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(70, 16, 70, 20),
              child: GradientSearchField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.trim().toLowerCase();
                  });
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),

          BlocBuilder<StartScreenCubit, StartScreenState>(
            builder: (context, state) {
              final allStudents = context.watch<StartScreenCubit>().allStudents;

              if (state is Loading || allStudents.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final filteredStudents = allStudents.where((student) {
                final fullName = "${student.firstname} ${student.lastname}"
                    .toLowerCase();
                return fullName.contains(_searchQuery);
              }).toList();

              if (filteredStudents.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      "لا يوجد طلاب بهذا الاسم",
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  ),
                );
              }

              return SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _getCrossAxisCount(context),
                  childAspectRatio: 0.58,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 24,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final student = filteredStudents[index];
                  final imageUrl = _buildImageUrl(student.image?.url);
              
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              StudentDetailScreen(studentId: student.id),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: Mycolors.darkblue,
                          width: 5,
                        ),
                        color: Mycolors.backgroundColor,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: imageUrl.isNotEmpty
                            ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _buildPlaceholder(),
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return _buildPlaceholder();
                                },
                              )
                            : _buildPlaceholder(),
                      ),
                    ),
                  );
                }, childCount: filteredStudents.length),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.6),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.person, size: 100, color: Colors.black87),
      ),
    );
  }

  String _buildImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return "";
    if (imagePath.startsWith('http')) return imagePath;
    const String cdn = "https://cdn.primeacademy.education/primeacademy";
    return imagePath.startsWith('/') ? "$cdn$imagePath" : "$cdn/$imagePath";
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
