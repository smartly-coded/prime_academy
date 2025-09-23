import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/CoursesModules/data/models/lesson_details_response.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/header_title.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/question_title.dart';

class EssayQuestionDialog extends StatefulWidget {
  final LessonQuestion question;
  final Function(String answer, bool isCorrect) onAnswerSubmitted;
  final VoidCallback onSkip;

  const EssayQuestionDialog({
    Key? key,
    required this.question,
    required this.onAnswerSubmitted,
    required this.onSkip,
  }) : super(key: key);

  @override
  State<EssayQuestionDialog> createState() => _EssayQuestionDialogState();
}

class _EssayQuestionDialogState extends State<EssayQuestionDialog>
    with TickerProviderStateMixin {
  final TextEditingController _answerController = TextEditingController();
  bool _showResult = false;
  bool _isCorrect = false;
  String _userAnswer = '';
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _scaleController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _answerController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _submitAnswer() {
    final answer = _answerController.text.trim();
    if (answer.isEmpty) return;

    _userAnswer = answer;

    // تحقق من الإجابة الصحيحة - مقارنة مع الإجابات الصحيحة المحفوظة
    final correctAnswers = widget.question.correctAnswers
        .map((ca) => ca.title!.toLowerCase().trim())
        .toList();

    // مقارنة بسيطة - البحث عن كلمات مفتاحية أو مطابقة جزئية
    _isCorrect = correctAnswers.any((correctAnswer) {
      final userAnswerLower = answer.toLowerCase().trim();
      final correctAnswerLower = correctAnswer.toLowerCase().trim();

      // مطابقة كاملة
      if (userAnswerLower == correctAnswerLower) return true;

      // مطابقة جزئية - الإجابة الصحيحة موجودة في إجابة الطالب
      if (userAnswerLower.contains(correctAnswerLower)) return true;

      // مطابقة عكسية - إجابة الطالب موجودة في الإجابة الصحيحة (للكلمات القصيرة)
      if (correctAnswerLower.contains(userAnswerLower) &&
          userAnswerLower.length >= 3)
        return true;

      return false;
    });

    setState(() {
      _showResult = true;
    });

    // إرسال النتيجة بعد 4 ثوانِ
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        widget.onAnswerSubmitted(answer, _isCorrect);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // منع تغيير حجم الشاشة مع الكيبورد
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A148C), Color(0xFF7B1FA2), Color(0xFF9C27B0)],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildQuestionContent(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionContent() {
    if (_showResult) {
      return _buildResultScreen();
    }

    // معلومات الشاشة للاستجابة
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return SizedBox(
      height: screenHeight, // استخدام كامل ارتفاع الشاشة
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isLandscape ? 40 : 20,
            vertical: isLandscape ? 15 : 20,
          ),
          child: Column(
            children: [
              // Header - responsive
              if (!isLandscape) HeaderTitle(),
              if (isLandscape)
                SizedBox(
                  height: 50,
                  child: Center(
                    child: Text(
                      "السؤال المقالي",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ),

              SizedBox(height: isLandscape ? 15 : 30),

              // Question Title
              _buildQuestionSection(isLandscape),

              SizedBox(height: isLandscape ? 15 : 30),

              // Answer Text Field
              _buildAnswerSection(isLandscape, screenHeight),

              SizedBox(height: isLandscape ? 15 : 20),

              // Submit Button
              _buildSubmitButton(isLandscape),

              // إضافة مساحة إضافية في الأسفل لتجنب تداخل الكيبورد
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionSection(bool isLandscape) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isLandscape ? 20 : 32,
        vertical: isLandscape ? 15 : 20,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Text(
        _cleanHtmlText(widget.question.title),
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Cairo',
          fontSize: isLandscape ? 18 : 26,
          fontWeight: FontWeight.bold,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAnswerSection(bool isLandscape, double screenHeight) {
    // حساب ارتفاع ثابت ومناسب للـ TextField
    final textFieldHeight = isLandscape ? 140.0 : 220.0;

    return Container(
      height: textFieldHeight,
      child: TextField(
        controller: _answerController,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Cairo',
          fontSize: isLandscape ? 14 : 16,
          height: 1.5,
        ),
        decoration: InputDecoration(
          hintText: "اكتب إجابتك هنا...",
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontFamily: 'Cairo',
            fontSize: isLandscape ? 14 : 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          filled: true,
          fillColor: Colors.black.withOpacity(0.3),
          contentPadding: EdgeInsets.all(isLandscape ? 12 : 15),
        ),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildSubmitButton(bool isLandscape) {
    return SizedBox(
      width: double.infinity,
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _answerController,
        builder: (context, value, child) {
          final hasText = value.text.trim().isNotEmpty;
          return ElevatedButton(
            onPressed: hasText ? _submitAnswer : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: hasText
                  ? Colors.white
                  : Colors.grey.withOpacity(0.3),
              padding: EdgeInsets.symmetric(vertical: isLandscape ? 14 : 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8,
            ),
            child: Text(
              "إرسال الإجابة",
              style: TextStyle(
                color: hasText
                    ? const Color.fromARGB(255, 98, 4, 115)
                    : Colors.white.withOpacity(0.5),
                fontFamily: 'Cairo',
                fontSize: isLandscape ? 18 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultScreen() {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return SingleChildScrollView(
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.elasticOut,
          child: Container(
            margin: EdgeInsets.all(isLandscape ? 30 : 40),
            padding: EdgeInsets.all(isLandscape ? 25 : 40),
            decoration: BoxDecoration(
              color: _isCorrect
                  ? Colors.green.withOpacity(0.9)
                  : Colors.orange.withOpacity(0.9),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: (_isCorrect ? Colors.green : Colors.orange)
                      .withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Result Icon
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Icon(
                        _isCorrect
                            ? Icons.check_circle
                            : Icons.assignment_turned_in,
                        color: Colors.white,
                        size: isLandscape ? 80 : 120,
                      ),
                    );
                  },
                ),

                SizedBox(height: isLandscape ? 15 : 30),

                // Result Text
                Text(
                  _isCorrect ? "إجابة ممتازة!" : "تم إرسال إجابتك!",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Cairo',
                    fontSize: isLandscape ? 28 : 36,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: isLandscape ? 10 : 20),

                // Subtitle
                Text(
                  _isCorrect
                      ? "إجابتك صحيحة ومميزة"
                      : "سيتم مراجعة إجابتك من قبل المعلم",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Cairo',
                    fontSize: isLandscape ? 14 : 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: isLandscape ? 15 : 30),

                // User answer
                Container(
                  padding: EdgeInsets.all(isLandscape ? 15 : 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "إجابتك:",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cairo',
                          fontSize: isLandscape ? 14 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: isLandscape ? 80 : 120,
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            _userAnswer,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Cairo',
                              fontSize: isLandscape ? 13 : 16,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _cleanHtmlText(String htmlText) {
    return htmlText
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .trim();
  }
}
