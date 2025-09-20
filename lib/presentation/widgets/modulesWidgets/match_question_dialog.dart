import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/CoursesModules/data/models/lesson_details_response.dart';

class MatchQuestionDialog extends StatefulWidget {
  final LessonQuestion question;
  final Function(bool isCorrect) onAnswerSubmitted;
  final VoidCallback onSkip;

  const MatchQuestionDialog({
    Key? key,
    required this.question,
    required this.onAnswerSubmitted,
    required this.onSkip,
  }) : super(key: key);

  @override
  State<MatchQuestionDialog> createState() => _MatchQuestionDialogState();
}

class _MatchQuestionDialogState extends State<MatchQuestionDialog>
    with TickerProviderStateMixin {
  Map<int, int?> _matches = {}; // promptId -> responseId
  List<Prompt> _shuffledPrompts = [];
  int? _selectedPromptId; // السؤال المختار حالياً
  bool _showResult = false;
  bool _isCorrect = false;
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // خلط الأسئلة (الـ prompts)
    _shuffledPrompts = List.from(widget.question.prompts);
    _shuffledPrompts.shuffle();

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
    // تحقق من صحة الإجابات
    bool allCorrect = true;

    for (var prompt in widget.question.prompts) {
      int? selectedResponseId = _matches[prompt.id];
      if (selectedResponseId == null ||
          prompt.response == null ||
          selectedResponseId != prompt.response!.id) {
        allCorrect = false;
        break;
      }
    }

    setState(() {
      _isCorrect = allCorrect;
      _showResult = true;
    });

    // إرسال النتيجة بعد 3 ثوانِ
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        widget.onAnswerSubmitted(_isCorrect);
      }
    });
  }

  bool get _isAnswerComplete {
    return _matches.length == widget.question.prompts.length &&
        !_matches.values.contains(null);
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
              Color(0xFFD32F2F), // أحمر غامق من أعلى
              Color(0xFFE53935), // أحمر متوسط في الوسط
              Color(0xFFEF5350), // أحمر فاتح من أسفل
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.link, color: Colors.white, size: 18),
                      const SizedBox(width: 6),
                      const Text(
                        "وصل السؤال بالإجابة",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cairo',
                          fontSize: 16,
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
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Question Title
          if (widget.question.title.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                _cleanHtmlText(widget.question.title),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Cairo',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          const SizedBox(height: 16),

          // Match Content
          Expanded(
            child: Row(
              children: [
                // Left side - Questions/Prompts
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "الأسئلة",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView.builder(
                            itemCount: widget.question.prompts.length,
                            itemBuilder: (context, index) {
                              final prompt = widget.question.prompts[index];
                              final isMatched = _matches.containsKey(prompt.id);
                              final isSelected = _selectedPromptId == prompt.id;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                height: 80,
                                child: GestureDetector(
                                  onTap: () {
                                    print('Prompt tapped: ${prompt.id}');
                                    setState(() {
                                      if (_selectedPromptId == prompt.id) {
                                        _selectedPromptId =
                                            null; // إلغاء التحديد
                                        print('Prompt deselected');
                                      } else {
                                        _selectedPromptId =
                                            prompt.id; // تحديد جديد
                                        print('Prompt selected: ${prompt.id}');
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 80,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: isMatched
                                          ? Colors.green.withOpacity(0.8)
                                          : isSelected
                                          ? Colors.orange.withOpacity(0.8)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isMatched
                                            ? Colors.green
                                            : isSelected
                                            ? Colors.orange
                                            : Colors.blue,
                                        width: isSelected ? 3 : 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        if (prompt.image != null) ...[
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            child: SizedBox(
                                              width: 40,
                                              height: 40,
                                              child: Image.network(
                                                prompt.image!.url,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return Container(
                                                        color: Colors.grey[300],
                                                        child: const Icon(
                                                          Icons.image,
                                                          color: Colors.grey,
                                                          size: 20,
                                                        ),
                                                      );
                                                    },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                        ],
                                        Expanded(
                                          child: Text(
                                            _cleanHtmlText(prompt.title),
                                            style: TextStyle(
                                              color: isMatched || isSelected
                                                  ? Colors.white
                                                  : Colors.black87,
                                              fontFamily: 'Cairo',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            textAlign: TextAlign.center,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Right side - Responses (shuffled)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "الإجابات",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _shuffledPrompts.length,
                            itemBuilder: (context, index) {
                              final response = _shuffledPrompts[index].response;
                              if (response == null)
                                return const SizedBox(height: 80);

                              final matchedPromptId = _matches.entries
                                  .where((entry) => entry.value == response.id)
                                  .map((entry) => entry.key)
                                  .firstOrNull;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                height: matchedPromptId != null ? 120 : 80,
                                child: DragTarget<int>(
                                  onAcceptWithDetails: (details) {
                                    setState(() {
                                      // إزالة أي تطابق سابق لهذه الإجابة
                                      _matches.removeWhere(
                                        (key, value) => value == response.id,
                                      );
                                      // إضافة التطابق الجديد
                                      _matches[details.data] = response.id;
                                    });
                                  },
                                  builder:
                                      (context, candidateData, rejectedData) {
                                        final isTargeted =
                                            candidateData.isNotEmpty;

                                        return AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          width: double.infinity,
                                          height: matchedPromptId != null
                                              ? 120
                                              : 80,
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: matchedPromptId != null
                                                ? Colors.green.withOpacity(0.8)
                                                : isTargeted
                                                ? Colors.yellow.withOpacity(0.8)
                                                : Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: matchedPromptId != null
                                                  ? Colors.green
                                                  : isTargeted
                                                  ? Colors.yellow
                                                  : Colors.grey[300]!,
                                              width: isTargeted ? 3 : 2,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.1,
                                                ),
                                                blurRadius: 6,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // Matched prompt (if any)
                                              if (matchedPromptId != null) ...[
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                    bottom: 6,
                                                  ),
                                                  padding: const EdgeInsets.all(
                                                    6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.9),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                  ),
                                                  child:
                                                      _buildSmallPromptPreview(
                                                        matchedPromptId,
                                                      ),
                                                ),
                                                const SizedBox(height: 4),
                                              ],

                                              // Response
                                              Flexible(
                                                child: Text(
                                                  response.title,
                                                  style: TextStyle(
                                                    color:
                                                        matchedPromptId != null
                                                        ? Colors.white
                                                        : Colors.black87,
                                                    fontFamily: 'Cairo',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Progress
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              "تم ربط ${_matches.length} من ${widget.question.prompts.length}",
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Cairo',
                fontSize: 14,
              ),
            ),
          ),

          // Bottom Actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: TextButton(
                      onPressed: widget.onSkip,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "تخطي",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cairo',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _isAnswerComplete ? _submitAnswer : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isAnswerComplete
                          ? Colors.white
                          : Colors.grey.withOpacity(0.3),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 6,
                    ),
                    child: Text(
                      "إرسال الإجابة",
                      style: TextStyle(
                        color: _isAnswerComplete
                            ? const Color(0xFFD32F2F)
                            : Colors.white.withOpacity(0.5),
                        fontFamily: 'Cairo',
                        fontSize: 18,
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

  Widget _buildSmallPromptPreview(int promptId) {
    final prompt = widget.question.prompts.firstWhere((p) => p.id == promptId);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (prompt.image != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              prompt.image!.url,
              height: 20,
              width: 20,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 20,
                  width: 20,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 12, color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(width: 4),
        ],
        Flexible(
          child: Text(
            _cleanHtmlText(prompt.title),
            style: const TextStyle(
              color: Colors.black87,
              fontFamily: 'Cairo',
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildResultScreen() {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.elasticOut,
        child: Container(
          margin: const EdgeInsets.all(30),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: _isCorrect
                ? Colors.green.withOpacity(0.9)
                : Colors.red.withOpacity(0.9),
            borderRadius: BorderRadius.circular(25),
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
              // Result Icon
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 800),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Icon(
                      _isCorrect ? Icons.check_circle : Icons.cancel,
                      color: Colors.white,
                      size: 100,
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              Text(
                _isCorrect ? "إجابة صحيحة!" : "إجابة خاطئة!",
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Cairo',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              Text(
                _isCorrect
                    ? "أحسنت! لقد وصلت كل سؤال بإجابته الصحيحة"
                    : "بعض الإجابات غير صحيحة، راجع التوصيل مرة أخرى",
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
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
