import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/CoursesModules/data/models/lesson_details_response.dart';

class FillInBlanksDialog extends StatefulWidget {
  final LessonQuestion question;
  final Function(String answer, bool isCorrect) onAnswerSubmitted;
  final VoidCallback onSkip;
  final int expectedLength; // عدد الحروف المتوقعة

  const FillInBlanksDialog({
    Key? key,
    required this.question,
    required this.onAnswerSubmitted,
    required this.onSkip,
    required this.expectedLength,
  }) : super(key: key);

  @override
  State<FillInBlanksDialog> createState() => _FillInBlanksDialogState();
}

class _FillInBlanksDialogState extends State<FillInBlanksDialog>
    with TickerProviderStateMixin {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
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

    // إنشاء controllers و focus nodes لكل حرف
    _controllers = List.generate(
      widget.expectedLength,
      (index) => TextEditingController(),
    );
    _focusNodes = List.generate(widget.expectedLength, (index) => FocusNode());

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

    // تركيز على أول مربع
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_focusNodes.isNotEmpty) {
        _focusNodes[0].requestFocus();
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _onTextChanged(String value, int index) {
    if (value.isNotEmpty) {
      // الانتقال للمربع التالي
      if (index < _controllers.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // آخر مربع - إزالة التركيز
        _focusNodes[index].unfocus();
      }
    }
  }

  void _onBackspace(int index) {
    if (index > 0 && _controllers[index].text.isEmpty) {
      // الرجوع للمربع السابق
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _submitAnswer() {
    // تجميع الإجابة من كل المربعات
    _userAnswer = _controllers.map((controller) => controller.text).join('');

    if (_userAnswer.trim().isEmpty) return;

    // تحقق من الإجابة الصحيحة
    final correctAnswers = widget.question.correctAnswers
        .map((ca) => ca.title!.toLowerCase().trim())
        .toList();

    _isCorrect = correctAnswers.any((correctAnswer) {
      final userAnswerLower = _userAnswer.toLowerCase().trim();
      final correctAnswerLower = correctAnswer.toLowerCase().trim();
      return userAnswerLower == correctAnswerLower;
    });

    setState(() {
      _showResult = true;
    });

    // إرسال النتيجة بعد 3 ثوانِ
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        widget.onAnswerSubmitted(_userAnswer, _isCorrect);
      }
    });
  }

  bool get _isAnswerComplete {
    return _controllers.every((controller) => controller.text.isNotEmpty);
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
              Color(0xFF2E7D32), // أخضر غامق من أعلى
              Color(0xFF388E3C), // أخضر متوسط في الوسط
              Color(0xFF4CAF50), // أخضر فاتح من أسفل
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
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.text_fields,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "أكمل الإجابة",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cairo',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Question Title
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 30,
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
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
                  child: Column(
                    children: [
                      Text(
                        _cleanHtmlText(widget.question.title),
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cairo',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "(${widget.expectedLength} حروف)",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontFamily: 'Cairo',
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // Answer Input Boxes
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "اكتب الإجابة حرف بحرف:",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cairo',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Character Input Boxes
                      LayoutBuilder(
                        builder: (context, constraints) {
                          // حساب عرض كل مربع ديناميكياً
                          double availableWidth =
                              constraints.maxWidth - 40; // مع هامش
                          double spacing = 8;
                          double totalSpacing =
                              (widget.expectedLength - 1) * spacing;
                          double boxWidth =
                              (availableWidth - totalSpacing) /
                              widget.expectedLength;

                          // تقليل العرض إذا كان كبير جداً أو صغير جداً
                          boxWidth = boxWidth.clamp(35.0, 60.0);

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(widget.expectedLength, (
                                index,
                              ) {
                                return Container(
                                  margin: EdgeInsets.only(
                                    right: index == 0 ? 0 : spacing,
                                  ),
                                  child: Container(
                                    width: boxWidth,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: _focusNodes[index].hasFocus
                                            ? const Color(0xFF4CAF50)
                                            : Colors.grey[300]!,
                                        width: _focusNodes[index].hasFocus
                                            ? 3
                                            : 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: TextField(
                                      controller: _controllers[index],
                                      focusNode: _focusNodes[index],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: boxWidth < 45 ? 18 : 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                      maxLength: 1,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        counterText: '',
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'[a-zA-Zا-ي\u0600-\u06FF]'),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        _onTextChanged(value, index);
                                        setState(() {});
                                      },
                                      onTap: () {
                                        _controllers[index]
                                            .selection = TextSelection(
                                          baseOffset: 0,
                                          extentOffset:
                                              _controllers[index].text.length,
                                        );
                                      },
                                      onSubmitted: (value) {
                                        if (index < _controllers.length - 1) {
                                          _focusNodes[index + 1].requestFocus();
                                        }
                                      },
                                    ),
                                  ),
                                );
                              }),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // Progress indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.white.withOpacity(0.7),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "اكتملت ${_controllers.where((c) => c.text.isNotEmpty).length} من ${widget.expectedLength}",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontFamily: 'Cairo',
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Clear button
                TextButton.icon(
                  onPressed: () {
                    for (var controller in _controllers) {
                      controller.clear();
                    }
                    _focusNodes[0].requestFocus();
                    setState(() {});
                  },
                  icon: const Icon(Icons.clear_all, color: Colors.white70),
                  label: const Text(
                    "مسح الكل",
                    style: TextStyle(
                      color: Colors.white70,
                      fontFamily: 'Cairo',
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
                    onPressed: _isAnswerComplete ? _submitAnswer : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isAnswerComplete
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
                        color: _isAnswerComplete
                            ? const Color(0xFF2E7D32)
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
                    ? "أحسنت! لقد أكملت الإجابة بشكل صحيح"
                    : "راجع إجابتك وحاول مرة أخرى",
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              // Show user answer
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    const Text(
                      "إجابتك:",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _userAnswer.isEmpty ? "لم تكتب إجابة" : _userAnswer,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Cairo',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Show correct answer if wrong
              if (!_isCorrect && widget.question.correctAnswers.isNotEmpty) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
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

  String _cleanHtmlText(String htmlText) {
    return htmlText
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .trim();
  }
}
