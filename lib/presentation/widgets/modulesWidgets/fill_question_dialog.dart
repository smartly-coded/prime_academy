import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/CoursesModules/data/models/lesson_details_response.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/header_title.dart';

class FillInBlanksDialog extends StatefulWidget {
  final LessonQuestion question;
  final Function(String answer, bool isCorrect) onAnswerSubmitted;
  final VoidCallback onSkip;
  final int expectedLength;

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
      if (index < _controllers.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
  }

  void _submitAnswer() {
    _userAnswer = _controllers.map((controller) => controller.text).join('');

    if (_userAnswer.trim().isEmpty) return;

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
            vertical: 20,
          ),
          child: Column(
            children: [
              HeaderTitle(),

              SizedBox(height: isLandscape ? 20 : 40),

              _buildQuestionSection(isLandscape, screenWidth),

              SizedBox(height: isLandscape ? 20 : 30),

              _buildAnswerInputSection(isLandscape, screenWidth),

              SizedBox(height: isLandscape ? 15 : 30),

              _buildClearButton(),

              SizedBox(height: isLandscape ? 20 : 40),

              _buildSubmitButton(),

              // إضافة مساحة إضافية في الأسفل لتجنب تداخل الكيبورد
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionSection(bool isLandscape, double screenWidth) {
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
          fontSize: isLandscape ? 20 : 28,
          fontWeight: FontWeight.bold,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAnswerInputSection(bool isLandscape, double screenWidth) {
    return Container(
      padding: EdgeInsets.all(isLandscape ? 15 : 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: _buildCharacterBoxes(isLandscape, screenWidth),
    );
  }

  // Fixed method for calculating boxes layout
  Widget _buildCharacterBoxes(bool isLandscape, double screenWidth) {
    // حساب العرض المتاح للمربعات (مع مراعاة padding)
    final containerPadding = isLandscape ? 30.0 : 40.0; // padding من الجانبين
    final availableWidth =
        screenWidth - containerPadding - 40; // 40 for screen margins

    // حساب حجم المربع والمسافة بناءً على الشاشة والتوجه
    final boxSpacing = isLandscape ? 6.0 : 8.0;
    final baseBoxSize = isLandscape ? 45.0 : 50.0;

    // حساب عدد المربعات التي تدخل في صف واحد
    final totalBoxes = widget.expectedLength;
    int maxBoxesPerRow;
    double actualBoxSize;

    if (isLandscape) {
      maxBoxesPerRow = 12;
      actualBoxSize = baseBoxSize;
    } else {
      // في portrait، احسب عدد المربعات بناءً على العرض المتاح
      maxBoxesPerRow =
          ((availableWidth + boxSpacing) / (baseBoxSize + boxSpacing)).floor();

      // تأكد من وجود مساحة كافية للمربعات
      if (maxBoxesPerRow > totalBoxes) {
        maxBoxesPerRow = totalBoxes;
      } else if (maxBoxesPerRow < 3) {
        // أقل حد 3 مربعات في الصف
        maxBoxesPerRow = 3;
      }

      // احسب حجم المربع الفعلي بناءً على المساحة المتاحة
      actualBoxSize =
          (availableWidth - (maxBoxesPerRow - 1) * boxSpacing) / maxBoxesPerRow;
      actualBoxSize = actualBoxSize.clamp(35.0, 60.0); // حد أدنى وأعلى للحجم
    }

    final numberOfRows = (totalBoxes / maxBoxesPerRow).ceil();

    return Column(
      children: List.generate(numberOfRows, (rowIndex) {
        final startIndex = rowIndex * maxBoxesPerRow;
        final endIndex = (startIndex + maxBoxesPerRow).clamp(0, totalBoxes);
        final boxesInThisRow = endIndex - startIndex;

        return Padding(
          padding: EdgeInsets.only(
            bottom: rowIndex < numberOfRows - 1 ? 15 : 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(boxesInThisRow, (boxIndex) {
              final globalIndex = startIndex + boxIndex;
              return _buildSingleCharacterBox(
                globalIndex,
                actualBoxSize,
                boxSpacing,
                boxIndex < boxesInThisRow - 1,
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildSingleCharacterBox(
    int index,
    double boxSize,
    double spacing,
    bool hasSpacing,
  ) {
    return Container(
      margin: EdgeInsets.only(right: hasSpacing ? spacing : 0),
      child: Container(
        width: boxSize,
        height: boxSize,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: _focusNodes[index].hasFocus
                  ? const Color(0xFF4CAF50).withOpacity(0.3)
                  : Colors.black.withOpacity(0.1),
              blurRadius: _focusNodes[index].hasFocus ? 8 : 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: boxSize < 45 ? 16 : (boxSize < 55 ? 18 : 20),
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
            _controllers[index].selection = TextSelection(
              baseOffset: 0,
              extentOffset: _controllers[index].text.length,
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
  }

  Widget _buildClearButton() {
    return TextButton.icon(
      onPressed: () {
        for (var controller in _controllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
        setState(() {});
      },
      icon: const Icon(Icons.clear_all, color: Colors.white70, size: 20),
      label: const Text(
        "مسح الكل",
        style: TextStyle(
          color: Colors.white70,
          fontFamily: 'Cairo',
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.4,
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
          "تقديم",
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
            margin: EdgeInsets.all(isLandscape ? 20 : 40),
            padding: EdgeInsets.all(isLandscape ? 25 : 40),
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
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Icon(
                        _isCorrect ? Icons.check_circle : Icons.cancel,
                        color: Colors.white,
                        size: isLandscape ? 80 : 120,
                      ),
                    );
                  },
                ),

                SizedBox(height: isLandscape ? 15 : 30),

                Text(
                  _isCorrect ? "إجابة صحيحة!" : "إجابة خاطئة!",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Cairo',
                    fontSize: isLandscape ? 28 : 36,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: isLandscape ? 10 : 20),

                Text(
                  _isCorrect
                      ? "أحسنت! لقد أكملت الإجابة بشكل صحيح"
                      : "راجع إجابتك وحاول مرة أخرى",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Cairo',
                    fontSize: isLandscape ? 14 : 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: isLandscape ? 15 : 30),

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
                      Text(
                        _userAnswer.isEmpty ? "لم تكتب إجابة" : _userAnswer,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cairo',
                          fontSize: isLandscape ? 20 : 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                if (!_isCorrect &&
                    widget.question.correctAnswers.isNotEmpty) ...[
                  SizedBox(height: isLandscape ? 15 : 20),
                  Container(
                    padding: EdgeInsets.all(isLandscape ? 15 : 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "الإجابة الصحيحة:",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Cairo',
                            fontSize: isLandscape ? 14 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.question.correctAnswers.first.title ?? "",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Cairo',
                            fontSize: isLandscape ? 20 : 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
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
