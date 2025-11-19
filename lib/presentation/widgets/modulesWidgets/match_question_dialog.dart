import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/CoursesModules/data/models/lesson_details_response.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/question_title.dart';

class ResponsiveMatchDialog extends StatefulWidget {
  final LessonQuestion question;
  final Function(Map<int, int> matchAnswers, bool isCorrect) onAnswerSubmitted;
  final VoidCallback onSkip;

  const ResponsiveMatchDialog({
    super.key,
    required this.question,
    required this.onAnswerSubmitted,
    required this.onSkip,
  });

  @override
  State<ResponsiveMatchDialog> createState() => _ResponsiveMatchDialogState();
}

class _ResponsiveMatchDialogState extends State<ResponsiveMatchDialog> {
  late List<Prompt> _prompts;
  late List<ResponseModel> _responses;
  final Map<int, int?> _matches = {}; // promptIndex -> responseIndex
  final Map<int, bool> _responseHovered = {}; // responseIndex -> isHovered
  bool _showResult = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _prompts = List.from(widget.question.prompts);
    _responses = widget.question.prompts
        .where((p) => p.response != null)
        .map((p) => p.response!)
        .toList();

    // خلط الإجابات بشكل عشوائي
    _responses.shuffle();

    // تهيئة حالة الـ hover للإجابات
    for (int i = 0; i < _responses.length; i++) {
      _responseHovered[i] = false;
    }
  }

  void _submitAnswer() {
    // تحقق من صحة الإجابات
    bool allCorrect = true;

    for (int i = 0; i < _prompts.length; i++) {
      int? responseIndex = _matches[i];
      if (responseIndex == null ||
          _responses[responseIndex].id != _prompts[i].response?.id) {
        allCorrect = false;
        break;
      }
    }

    // إنشاء خريطة للإرسال للـ API
    Map<int, int> matchAnswers = {};
    for (int promptIndex = 0; promptIndex < _prompts.length; promptIndex++) {
      int? responseIndex = _matches[promptIndex];
      if (responseIndex != null) {
        // promptId -> responseId
        matchAnswers[_prompts[promptIndex].id] = _responses[responseIndex].id;
      }
    }

    setState(() {
      _isCorrect = allCorrect;
      _showResult = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        widget.onAnswerSubmitted(matchAnswers, _isCorrect);
      }
    });
  }

  bool get _isAnswerComplete {
    return _matches.length == _prompts.length &&
        !_matches.values.contains(null);
  }

  void _handleQuestionDrop(int promptIndex, int responseIndex) {
    setState(() {
      // إزالة أي ربط سابق لهذا السؤال
      _matches.remove(promptIndex);

      // إزالة أي ربط سابق لهذه الإجابة من أسئلة أخرى
      _matches.removeWhere((key, value) => value == responseIndex);

      // ربط جديد
      _matches[promptIndex] = responseIndex;

      // إزالة حالة الـ hover
      _responseHovered[responseIndex] = false;
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
          child: _showResult ? _buildResultScreen() : _buildMatchContent(),
        ),
      ),
    );
  }

  Widget _buildMatchContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isLandscape = constraints.maxWidth > constraints.maxHeight;
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
                child: Text(
                  "اسحب الأسئلة وأسقطها على الإجابات المناسبة",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: questionTitle(widget.question.title),
        ),
      ],
    );
  }

  Widget _buildGridContent(bool isLandscape, bool isTablet) {
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العمود الأول: الأسئلة
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(_prompts.length, (index) {
                final prompt = _prompts[index];
                final isMatched = _matches.containsKey(index);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: isMatched
                      ? // 🔥 حل المشكلة الأولى: إظهار مربع فارغ بدلاً من SizedBox
                        _buildEmptyQuestionSlot(index, isTablet)
                      : Draggable<int>(
                          data: index,
                          feedback: _buildQuestionCard(
                            prompt,
                            index,
                            false,
                            null,
                            isTablet,
                            isDragging: true,
                          ),
                          childWhenDragging:
                              // 🔥 حل المشكلة الأولى: إظهار مربع فارغ أثناء السحب
                              _buildEmptyQuestionSlot(index, isTablet),
                          child: _buildQuestionCard(
                            prompt,
                            index,
                            false,
                            null,
                            isTablet,
                          ),
                          // 🔥 حل المشكلة الأولى: إرجاع السؤال لمكانه الأصلي عند الإلغاء
                          onDragEnd: (details) {
                            // إذا لم يتم إسقاط السؤال في مكان صحيح، يرجع لمكانه
                            if (!details.wasAccepted) {
                              // لا نحتاج لفعل شيء لأن الـ state لن يتغير
                              setState(() {}); // فقط لإعادة البناء
                            }
                          },
                        ),
                );
              }),
            ),
          ),

          SizedBox(width: 20),

          // العمود الثاني: الإجابات
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(_responses.length, (index) {
                final response = _responses[index];
                final isUsed = _matches.containsValue(index);
                final isHovered = _responseHovered[index] ?? false;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DragTarget<int>(
                    builder: (context, candidateData, rejectedData) {
                      return Container(
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
                            ? _buildDraggableQuestionInResponse(
                                // نعرض السؤال اللي اتعمله drop بنفس لونه ولكن قابل للسحب
                                _prompts[_matches.entries
                                    .firstWhere((entry) => entry.value == index)
                                    .key],
                                _matches.entries
                                    .firstWhere((entry) => entry.value == index)
                                    .key,
                                index,
                                isTablet,
                              )
                            : _buildResponseCard(response, isTablet),
                      );
                    },
                    // 🔥 حل المشكلة الثانية: منع وضع أكثر من سؤال في نفس المكان
                    onWillAcceptWithDetails: (promptIndex) {
                      return !_matches.containsValue(
                        index,
                      ); // يرفض إذا كان المكان مُستخدم
                    },
                    // onAcceptWithDetails: (promptIndex) {
                    //   _handleQuestionDrop(promptIndex, index);
                    // },
                    onAcceptWithDetails: (details) {
  _handleQuestionDrop(details.data, index);
},

                    onMove: (details) {
                      setState(() {
                        _responseHovered[index] = true;
                      });
                    },
                    onLeave: (promptIndex) {
                      setState(() {
                        _responseHovered[index] = false;
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

  // 🔥 ويدجت جديد للمربع الفارغ
  Widget _buildEmptyQuestionSlot(int index, bool isTablet) {
    return Container(
      height: 80, // نفس ارتفاع السؤال الأصلي
      padding: EdgeInsets.all(isTablet ? 12 : 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
          style: BorderStyle.solid, // خط متقطع ليوضح أنه مكان فارغ
        ),
      ),
    );
  }

  // 🔥 ويدجت جديد للسؤال القابل للسحب من داخل الإجابة
  Widget _buildDraggableQuestionInResponse(
    Prompt prompt,
    int promptIndex,
    int responseIndex,
    bool isTablet,
  ) {
    return Draggable<String>(
      // استخدام String بدلاً من int للتمييز عن الـ drag الأصلي
      data: "remove_$promptIndex",
      feedback: _buildQuestionCard(
        prompt,
        promptIndex,
        false,
        null,
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
      child: _buildQuestionCard(
        prompt,
        promptIndex,
        false,
        null,
        isTablet,
        showDragHint: true, // إضافة hint للسحب
      ),
      onDragEnd: (details) {
        // إذا تم سحب السؤال خارج منطقة الإجابة، أرجعه لمكانه الأصلي
        if (!details.wasAccepted) {
          setState(() {
            _matches.remove(promptIndex);
          });
        }
      },
    );
  }

  // ويدجت منفصل لعرض الإجابات
  Widget _buildResponseCard(ResponseModel response, bool isTablet) {
    return SizedBox(
      height: 60,
      child: Center(
        child: Text(
          response.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: isTablet ? 14 : 12,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildQuestionCard(
    Prompt prompt,
    int index,
    bool isMatched,
    int? matchedResponseIndex,
    bool isTablet, {
    bool isDragging = false,
    bool isDraggedAway = false,
    bool showDragHint = false,
  }) {
    // ألوان ثابتة حسب الترتيب
    final List<Color> cardColors = [
      Colors.red,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.amber,
    ];

    // حدد اللون حسب index
    Color baseColor = cardColors[index % cardColors.length];

    return Material(
      elevation: 0, // هنستغنى عن الـ Material shadow ونستخدم BoxShadow
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 80,
        padding: EdgeInsets.all(isTablet ? 12 : 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [
              Colors.white.withOpacity(0.4), // لمعة بسيطة جدًا من فوق
              baseColor, // اللون الأصلي للكارت
            ],
            stops: const [0.0, 0.15],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6, // قوة الضبابية
              offset: const Offset(0, 4), // اتجاه الظل (نازل لتحت)
            ),
          ],
          border: Border.all(
            color: isMatched
                ? Colors.green[900]!
                : isDraggedAway
                ? Colors.grey
                : baseColor,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prompt.image != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  prompt.image!.url,
                  width: isTablet ? 30 : 25,
                  height: isTablet ? 30 : 25,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: isTablet ? 4 : 2),
            ],
            if (!isMatched && !isDraggedAway)
              Flexible(
                child: Text(
                  _cleanHtmlText(prompt.title),
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
        // Actions
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
                  "تقديم",
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
              _isCorrect ? "إجابة صحيحة!" : "إجابة خاطئة!",
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
                  ? "لقد ربطت كل الأسئلة بإجاباتها الصحيحة"
                  : "بعض الروابط غير صحيحة، حاول مرة أخرى",
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
