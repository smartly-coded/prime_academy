import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/core/routing/app_routes.dart';
import 'package:prime_academy/features/startScreen/data/models/student_response.dart';
import 'package:prime_academy/features/startScreen/logic/start_screen_cubit.dart';
import 'package:prime_academy/features/startScreen/logic/start_screen_state.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/all_students_page.dart';

class StudentsSliderSection extends StatefulWidget {
  const StudentsSliderSection({super.key});

  @override
  State<StudentsSliderSection> createState() => _StudentsSliderSectionState();
}

class _StudentsSliderSectionState extends State<StudentsSliderSection> {
  late PageController _pageController;
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    final cubit = context.read<StartScreenCubit>();
    cubit.emitSliderStudentsState(); 
  }

  void _startTimer(List<Student> sliderStudents) {
    _timer?.cancel();
    if (sliderStudents.isEmpty) return;

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted && _pageController.hasClients) {
        _currentIndex = (_currentIndex + 1) % sliderStudents.length;
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopTimer() => _timer?.cancel();

  String _buildImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return "";
    if (imagePath.startsWith('http')) return imagePath;

    const String cdnPrefix = "https://cdn.primeacademy.education/primeacademy";
    return imagePath.startsWith('/')
        ? "$cdnPrefix$imagePath"
        : "$cdnPrefix/$imagePath";
  }

  void _goToStudentDetail(Student student) {
    _stopTimer();
    Navigator.pushNamed(
      context,
      AppRoutes.studentDetail,
      arguments: student.id,
    ).then((_) => _startTimer(context.read<StartScreenCubit>().sliderStudents));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Widget buildSliderUI(List<Student> sliderStudents) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50),
      color: Mycolors.cardColor1,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              final cubit = context.read<StartScreenCubit>();
              if (cubit.allStudents.isEmpty) {
                cubit.loadStudentsGradually();
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: cubit,
                    child: AllStudentsPage(),
                  ),
                ),
              );
            },
            child: buildStudentsButton(),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: screenHeight * 0.6,
            child: PageView.builder(
              controller: _pageController,
              itemCount: sliderStudents.length,
              itemBuilder: (_, i) {
                final student = sliderStudents[i];
                final imageUrl = _buildImageUrl(student.image?.url);
                return buildSliderItem(student, imageUrl, screenHeight);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStudentsButton() {
    return
    
    Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0xffa76433), Color(0xFF450486)],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Mycolors.darkblue,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, 
          children: [
            Text(
              "طلاب برايم أكاديمي",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(width: 8), 

            SvgPicture.asset(
              'assets/icons/student_cap.svg',
              width: 24,
              height: 24,
              color: Colors.white, 
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSliderItem(Student student, String imageUrl, double height) {
    return GestureDetector(
      onTap: () => _goToStudentDetail(student),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  height: height,
                  errorBuilder: (_, __, ___) =>
                      _buildPlaceholder(student.firstname),
                )
              : _buildPlaceholder(student.firstname),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StartScreenCubit>();

    return BlocBuilder<StartScreenCubit, StartScreenState>(
      builder: (context, state) {
        final sliderStudents = cubit.sliderStudents;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_timer == null && sliderStudents.isNotEmpty) {
            _startTimer(sliderStudents);
          }
        });

        return state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color(0xffa76433)),
            ),
          ),
          error: (error) => Center(
            child: Text(
              'خطأ في تحميل البيانات: $error',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),

          success: (_) => buildSliderUI(sliderStudents),

          studentsBatchLoaded: (_) => buildSliderUI(sliderStudents),
        );
      },
    );
  }

  Widget _buildPlaceholder(String name) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xff4f2349).withOpacity(0.7),
            const Color(0xffa76433).withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, color: Colors.white, size: 40),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
