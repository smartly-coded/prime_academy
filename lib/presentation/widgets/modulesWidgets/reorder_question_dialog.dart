import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/CoursesModules/data/models/lesson_details_response.dart';
import 'package:prime_academy/presentation/Home/veiw/home_screen.dart';

class ReorderQuestionDialog extends StatefulWidget {
  final LessonQuestion question;
  final Function(bool isCorrect) onAnswerSubmitted;
  final VoidCallback onSkip;

  const ReorderQuestionDialog({
    Key? key,
    required this.question,
    required this.onAnswerSubmitted,
    required this.onSkip,
  }) : super(key: key);

  @override
  State<ReorderQuestionDialog> createState() => _ReorderQuestionDialogState();
}

class _ReorderQuestionDialogState extends State<ReorderQuestionDialog> {
  late List<Answer> _shuffledAnswers;
  late List<Answer?> _orderedAnswers; // الترتيب الحالي
  late Map<int, int> _correctOrder; // answerId -> order
  bool _showResult = false;
  bool _isCorrect = false;
  int? _selectedAnswerIndex; // الكلمة المختارة

  @override
  void initState() {
    super.initState();

    // خلط الإجابات
    _shuffledAnswers = List.from(widget.question.answers);
    _shuffledAnswers.shuffle();

    // إنشاء قائمة فارغة للترتيب
    _orderedAnswers = List.filled(widget.question.answers.length, null);

    // إنشاء خريطة الترتيب الصحيح
    _correctOrder = {};
    for (var correctAnswer in widget.question.correctAnswers) {
      if (correctAnswer.answerId != null && correctAnswer.order != null) {
        _correctOrder[correctAnswer.answerId!] = correctAnswer.order!;
      }
    }
  }

  void _selectAnswer(int index) {
    print('Word selected: ${_shuffledAnswers[index].title} (index: $index)');
    setState(() {
      _selectedAnswerIndex = index;
    });
  }

  void _placeAnswer(int position) {
    print('Trying to place answer at position: $position');
    print('Selected answer index: $_selectedAnswerIndex');

    if (_selectedAnswerIndex != null) {
      print(
        'Placing ${_shuffledAnswers[_selectedAnswerIndex!].title} at position $position',
      );

      setState(() {
        // إزالة الكلمة من موضعها السابق إن كانت موجودة
        for (int i = 0; i < _orderedAnswers.length; i++) {
          if (_orderedAnswers[i]?.id ==
              _shuffledAnswers[_selectedAnswerIndex!].id) {
            _orderedAnswers[i] = null;
            break;
          }
        }

        // وضع الكلمة في الموضع الجديد
        _orderedAnswers[position] = _shuffledAnswers[_selectedAnswerIndex!];
        _selectedAnswerIndex = null;
      });
    } else {
      print('No answer selected');
    }
  }

  void _removeAnswer(int position) {
    print('Removing answer from position: $position');
    setState(() {
      _orderedAnswers[position] = null;
    });
  }

  void _submitAnswer() {
    // تحقق من الترتيب الصحيح
    bool allCorrect = true;

    for (int i = 0; i < _orderedAnswers.length; i++) {
      Answer? answer = _orderedAnswers[i];
      if (answer == null || _correctOrder[answer.id] != i) {
        allCorrect = false;
        break;
      }
    }

    setState(() {
      _isCorrect = allCorrect;
      _showResult = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        widget.onAnswerSubmitted(_isCorrect);
      }
    });
  }

  bool get _isAnswerComplete {
    return !_orderedAnswers.contains(null);
  }

  bool _isAnswerUsed(Answer answer) {
    return _orderedAnswers.any((a) => a?.id == answer.id);
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
              Color(0xFF6A1B9A), // موف غامق
              Color(0xFF8E24AA), // موف متوسط
              Color(0xFFAB47BC), // موف فاتح
            ],
          ),
        ),
        child: SafeArea(
          child: _showResult ? _buildResultScreen() : _buildReorderContent(),
        ),
      ),
    );
  }

  Widget _buildReorderContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isTablet = constraints.maxWidth > 600;

        return Padding(
          padding: EdgeInsets.all(isTablet ? 24 : 16),
          child: Column(
            children: [
              // Header
              _buildHeader(),

              SizedBox(height: isTablet ? 20 : 16),

              // Instructions
              Container(
                padding: EdgeInsets.all(isTablet ? 20 : 16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      _cleanHtmlText(widget.question.title),
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Cairo',
                        fontSize: isTablet ? 20 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isTablet ? 12 : 8),
                    Text(
                      "اختر الكلمة ثم اضغط على الرقم المناسب لترتيبها",
                      style: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Cairo',
                        fontSize: isTablet ? 16 : 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              SizedBox(height: isTablet ? 24 : 20),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Order slots (numbered boxes)
                      _buildOrderSlots(isTablet),

                      SizedBox(height: isTablet ? 32 : 24),

                      // Available words
                      _buildAvailableWords(isTablet),

                      // Extra space to prevent overflow
                      SizedBox(height: isTablet ? 32 : 24),
                    ],
                  ),
                ),
              ),

              // Bottom section
              _buildBottomSection(isTablet),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.sort, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                widget.question.sortDirection == SortDirection.asc
                    ? "رتب تصاعدياً"
                    : "رتب تنازلياً",
                style: const TextStyle(
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
            child: const Icon(Icons.close, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSlots(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 16 : 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            "الترتيب الصحيح",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Cairo',
              fontSize: isTablet ? 20 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isTablet ? 16 : 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isTablet ? 4 : 3,
              crossAxisSpacing: isTablet ? 12 : 8,
              mainAxisSpacing: isTablet ? 12 : 8,
              childAspectRatio: 1.0,
            ),
            itemCount: _orderedAnswers.length,
            itemBuilder: (context, index) {
              Answer? answer = _orderedAnswers[index];
              String imageUrl = buildImageUrl(answer!.image!.url);
              bool isCorrectPosition =
                  answer != null && _correctOrder[answer.id] == index;

              return InkWell(
                onTap: () {
                  print('Order slot $index tapped');
                  if (answer != null) {
                    _removeAnswer(index);
                  } else if (_selectedAnswerIndex != null) {
                    _placeAnswer(index);
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: answer != null
                        ? (isCorrectPosition
                              ? Colors.green.withOpacity(0.8)
                              : Colors.orange.withOpacity(0.8))
                        : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: answer != null
                          ? (isCorrectPosition ? Colors.green : Colors.orange)
                          : (_selectedAnswerIndex != null
                                ? Colors.yellow
                                : Colors.white.withOpacity(0.5)),
                      width: _selectedAnswerIndex != null && answer == null
                          ? 3
                          : 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Number
                      Container(
                        width: isTablet ? 28 : 24,
                        height: isTablet ? 28 : 24,
                        decoration: BoxDecoration(
                          color: answer != null
                              ? Colors.white
                              : Colors.white.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: answer != null
                                  ? (isCorrectPosition
                                        ? Colors.green
                                        : Colors.orange)
                                  : Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              fontSize: isTablet ? 14 : 12,
                            ),
                          ),
                        ),
                      ),

                      if (answer != null) ...[
                        SizedBox(height: isTablet ? 6 : 4),

                        // Image if available
                        if (answer.image != null) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              imageUrl,
                              width: isTablet ? 20 : 16,
                              height: isTablet ? 20 : 16,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: isTablet ? 20 : 16,
                                  height: isTablet ? 20 : 16,
                                  color: Colors.grey[300],
                                  child: Icon(
                                    Icons.image,
                                    size: isTablet ? 10 : 8,
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: isTablet ? 2 : 1),
                        ],

                        // Text
                        Flexible(
                          child: Text(
                            answer.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Cairo',
                              fontSize: isTablet ? 10 : 8,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableWords(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 16 : 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Wrap(
            spacing: isTablet ? 12 : 8,
            runSpacing: isTablet ? 12 : 8,
            children: _shuffledAnswers.asMap().entries.map((entry) {
              int index = entry.key;
              Answer answer = entry.value;
              String imageUrl = buildImageUrl(answer.image!.url);
              bool isSelected = _selectedAnswerIndex == index;
              bool isUsed = _isAnswerUsed(answer);

              return GestureDetector(
                onTap: isUsed ? null : () => _selectAnswer(index),
                child: Container(
                  padding: EdgeInsets.all(isTablet ? 12 : 10),
                  decoration: BoxDecoration(
                    color: isUsed
                        ? Colors.grey.withOpacity(0.3)
                        : isSelected
                        ? Colors.yellow.withOpacity(0.8)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isUsed
                          ? Colors.grey
                          : isSelected
                          ? Colors.yellow
                          : Colors.blue,
                      width: isSelected ? 3 : 2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Image if available
                      if (answer.image != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            imageUrl,
                            width: isTablet ? 40 : 32,
                            height: isTablet ? 40 : 32,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: isTablet ? 40 : 32,
                                height: isTablet ? 40 : 32,
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.image,
                                  size: isTablet ? 20 : 16,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: isTablet ? 8 : 6),
                      ],

                      // Text
                      Text(
                        answer.title,
                        style: TextStyle(
                          color: isUsed
                              ? Colors.grey[600]
                              : isSelected
                              ? Colors.black
                              : Colors.black87,
                          fontFamily: 'Cairo',
                          fontSize: isTablet ? 16 : 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(bool isTablet) {
    return Column(
      children: [
        // Progress
        Container(
          margin: EdgeInsets.symmetric(vertical: isTablet ? 20 : 16),
          child: Text(
            "مرتب: ${_orderedAnswers.where((a) => a != null).length} من ${_orderedAnswers.length}",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Cairo',
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Actions
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: widget.onSkip,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white, width: 2),
                  padding: EdgeInsets.symmetric(vertical: isTablet ? 18 : 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "تخطي",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Cairo',
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.w600,
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
                      : Colors.grey,
                  padding: EdgeInsets.symmetric(vertical: isTablet ? 18 : 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                ),
                child: Text(
                  "تحقق من الترتيب",
                  style: TextStyle(
                    color: _isAnswerComplete
                        ? const Color(0xFF6A1B9A)
                        : Colors.white,
                    fontFamily: 'Cairo',
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResultScreen() {
    return Center(
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
              color: (_isCorrect ? Colors.green : Colors.red).withOpacity(0.3),
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
                    size: 100,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              _isCorrect ? "ترتيب صحيح!" : "ترتيب خاطئ!",
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Cairo',
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              _isCorrect
                  ? "لقد رتبت كل الكلمات في المكان الصحيح"
                  : "بعض الكلمات في الترتيب الخاطئ",
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
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
