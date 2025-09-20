import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/constants.dart';
import 'package:prime_academy/features/CoursesModules/data/models/lesson_details_response.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/header_title.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/question_title.dart';

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
  Set<int> _selectedAnswerIds = {};
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

  // دالة لبناء رابط الصورة
  String buildImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return "";
    if (imagePath.startsWith('http')) {
      return imagePath;
    }
    return imagePath.startsWith('/')
        ? Constants.baseUrl + imagePath
        : Constants.baseUrl + '/' + imagePath;
  }

  void _submitAnswer() {
    if (_selectedAnswerIds.isEmpty) return;

    // الحصول على جميع الإجابات الصحيحة
    final correctAnswerIds = widget.question.correctAnswers
        .map((ca) => ca.answerId)
        .toSet();

    setState(() {
      // التحقق من أن الإجابات المختارة تطابق الإجابات الصحيحة تماماً
      _isCorrect =
          _selectedAnswerIds.length == correctAnswerIds.length &&
          _selectedAnswerIds.every((id) => correctAnswerIds.contains(id));
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
          HeaderTitle(),

          // Question Content
          Expanded(
            child: Column(
              children: [
                // Question Title
                questionTitle(widget.question.title),

                if (widget.question.allowMultipleAnswers) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "يمكنك اختيار أكثر من إجابة",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Cairo',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                // Answers in colored boxes with images
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
                        final isSelected = _selectedAnswerIds.contains(
                          answer.id,
                        );

                        // ألوان مختلفة لكل اختيار مثل الصورة
                        List<Color> answerColors = [
                          const Color.fromARGB(255, 178, 188, 3),
                          const Color(0xFF9C27B0),
                          const Color(0xFFFF9800),
                          const Color(0xFF00BCD4),
                        ];

                        Color answerColor =
                            answerColors[index % answerColors.length];

                        // التحقق من وجود صورة
                        String imageUrl = buildImageUrl(answer.image?.url);
                        bool hasImage = imageUrl.isNotEmpty;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                // التحقق من نوع السؤال
                                if (widget.question.allowMultipleAnswers) {
                                  // للأسئلة متعددة الإجابات
                                  if (_selectedAnswerIds.contains(answer.id)) {
                                    _selectedAnswerIds.remove(
                                      answer.id,
                                    ); // إلغاء التحديد
                                  } else {
                                    _selectedAnswerIds.add(
                                      answer.id,
                                    ); // إضافة التحديد
                                  }
                                } else {
                                  // للأسئلة ذات الإجابة الواحدة
                                  _selectedAnswerIds.clear();
                                  _selectedAnswerIds.add(answer.id);
                                }
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
                                  padding: const EdgeInsets.all(16),
                                  child: hasImage
                                      ? _buildAnswerWithImage(
                                          answer.title,
                                          imageUrl,
                                        )
                                      : _buildAnswerTextOnly(answer.title),
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
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _selectedAnswerIds.isNotEmpty
                        ? _submitAnswer
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedAnswerIds.isNotEmpty
                          ? Colors.white
                          : Colors.grey.withOpacity(0.3),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                    ),
                    child: Text(
                      "تقديم",
                      style: TextStyle(
                        color: _selectedAnswerIds != null
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

  // ويدجت للإجابة مع صورة (الصورة في الأعلى والنص في الأسفل)
  Widget _buildAnswerWithImage(String title, String imageUrl) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // الصورة
        Expanded(
          flex: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.white,
                    size: 30,
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 8),

        // النص
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Cairo',
              fontSize: 18,
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // ويدجت للإجابة النصية فقط (بدون صورة)
  Widget _buildAnswerTextOnly(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'Cairo',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(color: Colors.black54, offset: Offset(1, 1), blurRadius: 3),
        ],
      ),
      textAlign: TextAlign.center,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
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
      // الحصول على جميع الإجابات الصحيحة
      final correctAnswers = widget.question.answers
          .where((answer) => correctAnswerIds.contains(answer.id))
          .map((answer) => answer.title)
          .toList();

      // دمج الإجابات بفاصلة أو "و"
      if (correctAnswers.length == 1) {
        return correctAnswers.first;
      } else if (correctAnswers.length == 2) {
        return "${correctAnswers[0]} و ${correctAnswers[1]}";
      } else {
        final lastAnswer = correctAnswers.removeLast();
        return "${correctAnswers.join('، ')} و $lastAnswer";
      }
    }

    return "غير محدد";
  }
}
