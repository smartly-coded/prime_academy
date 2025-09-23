import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/CoursesModules/data/models/lesson_details_response.dart';

class ResponsiveMatchDialog extends StatefulWidget {
  final LessonQuestion question;
  final Function(Map<int, int> matchAnswers, bool isCorrect) onAnswerSubmitted;
  final VoidCallback onSkip;

  const ResponsiveMatchDialog({
    Key? key,
    required this.question,
    required this.onAnswerSubmitted,
    required this.onSkip,
  }) : super(key: key);

  @override
  State<ResponsiveMatchDialog> createState() => _ResponsiveMatchDialogState();
}

class _ResponsiveMatchDialogState extends State<ResponsiveMatchDialog> {
  late List<Prompt> _prompts;
  late List<ResponseModel> _responses;
  Map<int, int?> _matches = {}; // promptIndex -> responseIndex
  Map<int, bool> _responseHovered = {}; // responseIndex -> isHovered
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
        matchAnswers[_prompts[promptIndex].id!] = _responses[responseIndex].id!;
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

  void _handlePromptTap(int promptIndex) {
    // إلغاء الربط بالضغط على السؤال
    setState(() {
      _matches.remove(promptIndex);
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
                    fontFamily: 'Cairo',
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.drag_indicator, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              const Text(
                "اسحب وأسقط للربط",
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
            child: const Icon(Icons.close, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildGridContent(bool isLandscape, bool isTablet) {
    int crossAxisCount = isTablet ? 3 : 2;
    if (isLandscape && !isTablet) crossAxisCount = 3;

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
                      ? SizedBox(
                          height: 60, // يخلي مكان السؤال فاضي بنفس المساحة
                        )
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
                          childWhenDragging: SizedBox(
                            height: 60, // مكان فاضي برضه لما يتسحب
                          ),
                          child: _buildQuestionCard(
                            prompt,
                            index,
                            false,
                            null,
                            isTablet,
                          ),
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
                            color: isHovered
                                ? Colors.green
                                : Colors.white.withOpacity(0.3),
                            width: isHovered ? 3 : 2,
                          ),
                        ),
                        child: isUsed
                            ? _buildQuestionCard(
                                // نعرض السؤال اللي اتعمله drop بنفس لونه
                                _prompts[_matches.entries
                                    .firstWhere((entry) => entry.value == index)
                                    .key],
                                index,
                                false,
                                null,
                                isTablet,
                              )
                            : Text(
                                response.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Cairo',
                                  fontSize: isTablet ? 14 : 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      );
                    },
                    onWillAccept: (promptIndex) => true, // يقبل أي سؤال
                    onAccept: (promptIndex) {
                      setState(() {
                        _matches[promptIndex] = index;
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

  Widget _buildQuestionCard(
    Prompt prompt,
    int index,
    bool isMatched,
    int? matchedResponseIndex,
    bool isTablet, {
    bool isDragging = false,
    bool isDraggedAway = false,
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
      elevation: isDragging ? 8 : 0,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(isTablet ? 12 : 8),
        decoration: BoxDecoration(
          color: isMatched
              ? Color.fromARGB(142, 63, 6, 39) // ✅ لون فاضي أخضر عند الماتش
              : isDraggedAway
              ? Color.fromARGB(81, 63, 6, 39)
              : baseColor.withOpacity(0.8), // ✅ اللون الأساسي لكل مربع
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isMatched
                ? const Color.fromARGB(255, 114, 104, 104)
                : isDraggedAway
                ? Colors.grey
                : baseColor, // نفس لون الخلفية كبوردر
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
                  width: isTablet ? 40 : 30,
                  height: isTablet ? 40 : 30,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: isTablet ? 40 : 30,
                      height: isTablet ? 40 : 30,
                      color: Colors.grey[300],
                      child: Icon(Icons.image, size: isTablet ? 20 : 15),
                    );
                  },
                ),
              ),
              SizedBox(height: isTablet ? 6 : 4),
            ],
            if (!isMatched && !isDraggedAway)
              Flexible(
                child: Text(
                  _cleanHtmlText(prompt.title),
                  style: TextStyle(
                    color: isMatched
                        ? Colors.green[900] // ✅ النص يبقى أخضر غامق عند الماتش
                        : Colors.white, // النص أبيض على الخلفية الملونة
                    fontFamily: 'Cairo',
                    fontSize: isTablet ? 12 : 10,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (!isMatched && !isDraggedAway)
              Icon(
                Icons.drag_indicator,
                color: Colors.white,
                size: isTablet ? 20 : 16,
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
                  "تحقق من الإجابة",
                  style: TextStyle(
                    color: _isAnswerComplete
                        ? const Color(0xFFD32F2F)
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
              _isCorrect ? "إجابة صحيحة!" : "إجابة خاطئة!",
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
                  ? "لقد ربطت كل الأسئلة بإجاباتها الصحيحة"
                  : "بعض الروابط غير صحيحة، حاول مرة أخرى",
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
