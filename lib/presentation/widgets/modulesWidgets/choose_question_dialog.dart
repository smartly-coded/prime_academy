import 'package:flutter/material.dart';
import 'package:prime_academy/features/CoursesModules/data/models/lesson_details_response.dart';

class FullScreenMcqDialog extends StatefulWidget {
  final LessonQuestion question;
  final Function(bool isCorrect) onAnswerSubmitted;
  final VoidCallback onSkip;

  const FullScreenMcqDialog({
    super.key,
    required this.question,
    required this.onAnswerSubmitted,
    required this.onSkip,
  });

  @override
  State<FullScreenMcqDialog> createState() => _FullScreenMcqDialogState();
}

class _FullScreenMcqDialogState extends State<FullScreenMcqDialog>
    with TickerProviderStateMixin {
  int? _selectedAnswerId;
  bool _showResult = false;
  bool _isCorrect = false;
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
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _submitAnswer() {
    if (_selectedAnswerId == null) return;

    // تحقق من الإجابة الصحيحة
    final correctAnswerIds = widget.question.correctAnswers
        .map((ca) => ca.answerId)
        .toList();

    setState(() {
      _isCorrect = correctAnswerIds.contains(_selectedAnswerId);
      _showResult = true;
    });

    // إرسال النتيجة بعد 3 ثوانِ
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        widget.onAnswerSubmitted(_isCorrect);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4A148C), // موف غامق من أعلى
              Color(0xFF7B1FA2), // موف متوسط في الوسط
              Color(0xFF9C27B0), // موف فاتح من أسفل
            ],
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

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "سؤال على غفلة",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Cairo',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: widget.onSkip,
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Question Content
          Expanded(
            child: Column(
              children: [
                // Question Title
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 40,
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Cairo',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 40),

                // Answers in colored boxes like the image
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 1.4,
                      children: widget.question.answers.asMap().entries.map((
                        entry,
                      ) {
                        int index = entry.key;
                        var answer = entry.value;
                        final isSelected = _selectedAnswerId == answer.id;

                        // ألوان مختلفة لكل اختيار مثل الصورة
                        List<Color> answerColors = [
                          const Color(0xFF8BC34A), // أخضر للأول
                          const Color(0xFF9C27B0), // موف للثاني
                          const Color(0xFFFF9800), // برتقالي للثالث
                          const Color(0xFF00BCD4), // تركوازي للرابع
                        ];

                        Color answerColor =
                            answerColors[index % answerColors.length];

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedAnswerId = answer.id;
                              });
                            },
                            borderRadius: BorderRadius.circular(25),
                            child: Container(
                              decoration: BoxDecoration(
                                color: answerColor,
                                borderRadius: BorderRadius.circular(25),
                                border: isSelected
                                    ? Border.all(color: Colors.white, width: 5)
                                    : null,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: isSelected ? 15 : 10,
                                    offset: const Offset(0, 5),
                                  ),
                                  if (isSelected)
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.5),
                                      blurRadius: 20,
                                      offset: const Offset(0, 0),
                                    ),
                                ],
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    answer.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Cairo',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black54,
                                          offset: Offset(1, 1),
                                          blurRadius: 3,
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Actions
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: TextButton(
                      onPressed: widget.onSkip,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "تخطي",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cairo',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _selectedAnswerId != null ? _submitAnswer : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedAnswerId != null
                          ? Colors.white
                          : Colors.grey.withOpacity(0.3),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                    ),
                    child: Text(
                      "إرسال الإجابة",
                      style: TextStyle(
                        color: _selectedAnswerId != null
                            ? const Color(0xFF7B1FA2)
                            : Colors.white.withOpacity(0.5),
                        fontFamily: 'Cairo',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen() {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.elasticOut,
        child: Container(
          margin: const EdgeInsets.all(40),
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: _isCorrect
                ? Colors.green.withOpacity(0.9)
                : Colors.red.withOpacity(0.9),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: (_isCorrect ? Colors.green : Colors.red).withOpacity(
                  0.3,
                ),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Result Icon with animation
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 800),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Icon(
                      _isCorrect ? Icons.check_circle : Icons.cancel,
                      color: Colors.white,
                      size: 120,
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              // Result Text
              Text(
                _isCorrect ? "إجابة صحيحة!" : "إجابة خاطئة!",
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Cairo',
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // Subtitle
              Text(
                _isCorrect
                    ? "أحسنت! استمر في التعلم"
                    : "لا بأس، حاول مرة أخرى في المرة القادمة",
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),

              // Show correct answer if wrong
              if (!_isCorrect) ...[
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "الإجابة الصحيحة:",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _getCorrectAnswerText(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cairo',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getCorrectAnswerText() {
    final correctAnswerIds = widget.question.correctAnswers
        .map((ca) => ca.answerId)
        .toList();

    if (correctAnswerIds.isNotEmpty) {
      final correctAnswer = widget.question.answers.firstWhere(
        (answer) => correctAnswerIds.contains(answer.id),
      );
      return correctAnswer.title;
    }

    return "غير محدد";
  }

  String _cleanHtmlText(String htmlText) {
    return htmlText
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .trim();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return "${minutes}:${secs.toString().padLeft(2, '0')}";
  }
}
