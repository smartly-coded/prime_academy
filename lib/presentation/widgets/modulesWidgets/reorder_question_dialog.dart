import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/CoursesModules/data/models/lesson_details_response.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/question_title.dart';
import 'package:prime_academy/core/helpers/constants.dart';

class ReorderQuestionDialog extends StatefulWidget {
  final LessonQuestion question;
  final Function(Map<int, int> orderAnswers, bool isCorrect) onAnswerSubmitted;
  final VoidCallback onSkip;

  const ReorderQuestionDialog({
    super.key,
    required this.question,
    required this.onAnswerSubmitted,
    required this.onSkip,
  });

  @override
  State<ReorderQuestionDialog> createState() => _ReorderQuestionDialogState();
}

class _ReorderQuestionDialogState extends State<ReorderQuestionDialog> {
  List<Answer> _shuffledAnswers = [];
  List<int> _orderSlots = []; // قائمة أرقام الترتيب
  final Map<int, int?> _matches = {}; // slotIndex -> answerIndex
  final Map<int, bool> _slotHovered = {}; // slotIndex -> isHovered
  bool _showResult = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();

    // خلط الإجابات
    _shuffledAnswers = List.from(widget.question.answers);
    _shuffledAnswers.shuffle();

    // إنشاء قائمة أرقام الترتيب
    _orderSlots = List.generate(
      widget.question.answers.length,
      (index) => index,
    );

    // تهيئة حالة الـ hover للأرقام
    for (int i = 0; i < _orderSlots.length; i++) {
      _slotHovered[i] = false;
    }
  }

  // دالة لبناء رابط الصورة
  String buildImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return "";
    if (imagePath.startsWith('http')) {
      return imagePath;
    }
    return imagePath.startsWith('/')
        ? Constants.baseUrl + imagePath
        : '${Constants.baseUrl}/$imagePath';
  }

  void _submitAnswer() {
    // تحقق من صحة الإجابات
    bool allCorrect = true;

    // إنشاء خريطة للإرسال للـ API
    Map<int, int> orderAnswers = {};

    for (int i = 0; i < _orderSlots.length; i++) {
      int? answerIndex = _matches[i];
      if (answerIndex != null) {
        int answerId = _shuffledAnswers[answerIndex].id;
        orderAnswers[i] = answerId; // position -> answerId

        // تحقق من الترتيب الصحيح
        int correctPosition = widget.question.correctAnswers
            .firstWhere((ca) => ca.answerId == answerId)
            .order!;
        if (correctPosition != i) {
          allCorrect = false;
        }
      } else {
        allCorrect = false;
      }
    }

    setState(() {
      _isCorrect = allCorrect;
      _showResult = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        widget.onAnswerSubmitted(orderAnswers, _isCorrect);
      }
    });
  }

  bool get _isAnswerComplete {
    return _matches.length == _orderSlots.length &&
        !_matches.values.contains(null);
  }

  void _handleAnswerDrop(int answerIndex, int slotIndex) {
    setState(() {
      // إزالة أي ربط سابق لهذه الإجابة
      _matches.removeWhere((key, value) => value == answerIndex);

      // ربط جديد
      _matches[slotIndex] = answerIndex;

      // إزالة حالة الـ hover
      _slotHovered[slotIndex] = false;
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
            colors: [Color(0xFF5d0b39), Color(0xff3f0627), Color(0xff270419)],
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
        bool isLandscape = constraints.maxWidth > constraints.maxHeight;
        bool isTablet = constraints.maxWidth > 600;

        return Padding(
          padding: EdgeInsets.all(isTablet ? 24 : 16),
          child: Column(
            children: [
              // Header
              SizedBox(height: isTablet ? 20 : 16),

              // Instructions
              questionTitle(widget.question.title),

              SizedBox(height: isTablet ? 24 : 20),

              // Content
              Expanded(child: _buildGridContent(isLandscape, isTablet)),

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
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _cleanHtmlText(widget.question.title),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
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

  Widget _buildGridContent(bool isLandscape, bool isTablet) {
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العمود الأول: الكلمات
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(_shuffledAnswers.length, (index) {
                final answer = _shuffledAnswers[index];
                final isMatched = _matches.containsValue(index);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: isMatched
                      ? _buildEmptyAnswerSlot(index, isTablet)
                      : Draggable<int>(
                          data: index,
                          feedback: SizedBox(
                            width: 150, // نفس العرض اللي بتحبيه
                            height: 80, // نفس الطول
                            child: _buildAnswerCard(
                              answer,
                              index,
                              isTablet,
                              isDragging: true,
                            ),
                          ),
                          childWhenDragging: _buildEmptyAnswerSlot(
                            index,
                            isTablet,
                          ),
                          child: _buildAnswerCard(answer, index, isTablet),
                          onDragEnd: (details) {
                            if (!details.wasAccepted) {
                              setState(() {});
                            }
                          },
                        ),
                );
              }),
            ),
          ),

          SizedBox(width: 20),

          // العمود الثاني: أرقام الترتيب
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(_orderSlots.length, (index) {
                final isUsed = _matches.containsKey(index);
                final isHovered = _slotHovered[index] ?? false;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DragTarget<int>(
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        height: 80,
                        padding: EdgeInsets.all(isTablet ? 12 : 8),
                        decoration: BoxDecoration(
                          color: Color(0xff3f0627),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: candidateData.isNotEmpty
                                ? Colors.green
                                : isHovered
                                ? Colors.green
                                : Colors.white.withOpacity(0.3),
                            width: candidateData.isNotEmpty || isHovered
                                ? 3
                                : 2,
                          ),
                        ),
                        child: isUsed
                            ? _buildDraggableAnswerInSlot(
                                _shuffledAnswers[_matches[index]!],
                                _matches[index]!,
                                index,
                                isTablet,
                              )
                            : _buildOrderSlot(index, isTablet),
                      );
                    },
                    onWillAcceptWithDetails: (answerIndex) {
                      return !_matches.containsKey(index);
                    },
                    // onAcceptWithDetails: (answerIndex) {
                    //   _handleAnswerDrop(answerIndex, index);
                    // },
                    onAcceptWithDetails: (details) {
  _handleAnswerDrop(details.data, index);
},

                    onMove: (details) {
                      setState(() {
                        _slotHovered[index] = true;
                      });
                    },
                    onLeave: (answerIndex) {
                      setState(() {
                        _slotHovered[index] = false;
                      });
                    },
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyAnswerSlot(int index, bool isTablet) {
    return Container(
      height: 80,
      padding: EdgeInsets.all(isTablet ? 12 : 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
    );
  }

  Widget _buildDraggableAnswerInSlot(
    Answer answer,
    int answerIndex,
    int slotIndex,
    bool isTablet,
  ) {
    return Draggable<String>(
      data: "remove_$answerIndex",
      feedback: _buildAnswerCard(
        answer,
        answerIndex,
        isTablet,
        isDragging: true,
      ),
      childWhenDragging: SizedBox(
        height: 80,
        child: Center(
          child: Icon(
            Icons.remove_circle_outline,
            color: Colors.white.withOpacity(0.3),
            size: isTablet ? 40 : 35,
          ),
        ),
      ),
      child: _buildAnswerCard(
        answer,
        answerIndex,
        isTablet,
        showDragHint: true,
      ),
      onDragEnd: (details) {
        if (!details.wasAccepted) {
          setState(() {
            _matches.remove(slotIndex);
          });
        }
      },
    );
  }

  Widget _buildOrderSlot(int slotIndex, bool isTablet) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${slotIndex + 1}",
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 12 : 10,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerCard(
    Answer answer,
    int index,
    bool isTablet, {
    bool isDragging = false,
    bool showDragHint = false,
  }) {
    final List<Color> cardColors = [
      Colors.red,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.amber,
    ];

    Color baseColor = cardColors[index % cardColors.length];
    String imageUrl = buildImageUrl(answer.image?.url);
    bool hasImage = imageUrl.isNotEmpty;

    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 80,
        padding: EdgeInsets.all(isTablet ? 12 : 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [Colors.white.withOpacity(0.4), baseColor],
            stops: const [0.0, 0.15],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: baseColor, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasImage) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  imageUrl,
                  width: isTablet ? 30 : 25,
                  height: isTablet ? 30 : 25,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: isTablet ? 30 : 25,
                      height: isTablet ? 30 : 25,
                      color: Colors.grey[300],
                      child: Icon(Icons.image, size: isTablet ? 15 : 12),
                    );
                  },
                ),
              ),
              SizedBox(height: isTablet ? 4 : 2),
            ],
            Flexible(
              child: Text(
                answer.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 14 : 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection(bool isTablet) {
    return Column(
      children: [
        Row(
          children: [
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
                        ? const Color(0xFFD32F2F)
                        : Colors.white,
                    fontSize: isTablet ? 18 : 16,
                    // fontWeight: FontWeight.bold,
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
                fontSize: 32,
                // fontWeight: FontWeight.bold,
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
