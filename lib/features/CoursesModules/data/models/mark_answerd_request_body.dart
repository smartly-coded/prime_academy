import 'package:json_annotation/json_annotation.dart';

part 'mark_answerd_request_body.g.dart';

@JsonSerializable()
class MarkAnsweredRequestBody {
  final int lessonId;

  @JsonKey(name: "type")
  final String questionType;

  final dynamic answers; // استخدم dynamic عشان يقبل أي نوع

  MarkAnsweredRequestBody({
    required this.lessonId,
    required this.questionType,
    required this.answers,
  });

  // Factory constructors for different question types

  /// للأسئلة من نوع re-order و match
  factory MarkAnsweredRequestBody.mapAnswers({
    required int lessonId,
    required String questionType,
    required Map<String, int> answersMap,
  }) {
    return MarkAnsweredRequestBody(
      lessonId: lessonId,
      questionType: questionType,
      answers: answersMap,
    );
  }

  /// للأسئلة من نوع choose (multiple choice)
  factory MarkAnsweredRequestBody.choiceAnswers({
    required int lessonId,
    required String questionType,
    required List<int> selectedChoices,
  }) {
    return MarkAnsweredRequestBody(
      lessonId: lessonId,
      questionType: questionType,
      answers: selectedChoices,
    );
  }

  /// للأسئلة من نوع fill-in-blanks و essay
  factory MarkAnsweredRequestBody.textAnswers({
    required int lessonId,
    required String questionType,
    required List<String> textAnswers,
  }) {
    return MarkAnsweredRequestBody(
      lessonId: lessonId,
      questionType: questionType,
      answers: textAnswers,
    );
  }

  /// للأسئلة من نوع essay (single text answer)
  factory MarkAnsweredRequestBody.singleTextAnswer({
    required int lessonId,
    required String questionType,
    required String answer,
  }) {
    return MarkAnsweredRequestBody(
      lessonId: lessonId,
      questionType: questionType,
      answers: [answer], // wrap في array كـ String
    );
  }

  Map<String, dynamic> toJson() => _$MarkAnsweredRequestBodyToJson(this);

  factory MarkAnsweredRequestBody.fromJson(Map<String, dynamic> json) =>
      _$MarkAnsweredRequestBodyFromJson(json);
}

// Helper class للتعامل مع إنشاء الـ request body
class QuestionAnswerHelper {
  /// إنشاء request body للسؤال من نوع re-order
  static MarkAnsweredRequestBody createReOrderAnswer({
    required int lessonId,
    required Map<int, int> orderMap, // index -> questionId
  }) {
    // تحويل الـ int keys إلى string
    final answersMap = orderMap.map(
      (key, value) => MapEntry(key.toString(), value),
    );

    return MarkAnsweredRequestBody.mapAnswers(
      lessonId: lessonId,
      questionType: "re-order",
      answersMap: answersMap,
    );
  }

  /// إنشاء request body للسؤال من نوع match
  static MarkAnsweredRequestBody createMatchAnswer({
    required int lessonId,
    required Map<int, int> matchMap, // questionId -> answerId
  }) {
    // تحويل الـ int keys إلى string
    final answersMap = matchMap.map(
      (key, value) => MapEntry(key.toString(), value),
    );

    return MarkAnsweredRequestBody.mapAnswers(
      lessonId: lessonId,
      questionType: "match",
      answersMap: answersMap,
    );
  }

  /// إنشاء request body للسؤال من نوع choose
  static MarkAnsweredRequestBody createChoiceAnswer({
    required int lessonId,
    required List<int> selectedChoices,
  }) {
    return MarkAnsweredRequestBody.choiceAnswers(
      lessonId: lessonId,
      questionType: "mcq",
      selectedChoices: selectedChoices,
    );
  }

  /// إنشاء request body للسؤال من نوع fill-in-blanks
  static MarkAnsweredRequestBody createFillAnswer({
    required int lessonId,
    required String answer,
  }) {
    return MarkAnsweredRequestBody.textAnswers(
      lessonId: lessonId,
      questionType: "fill-blank",
      textAnswers: [answer], // String في List
    );
  }

  /// إنشاء request body للسؤال من نوع essay
  static MarkAnsweredRequestBody createEssayAnswer({
    required int lessonId,
    required String answer,
  }) {
    return MarkAnsweredRequestBody.textAnswers(
      lessonId: lessonId,
      questionType: "essay",
      textAnswers: [answer], // String في List
    );
  }
}

// مثال على الاستخدام:
/*

// للسؤال من نوع re-order:
final reOrderBody = QuestionAnswerHelper.createReOrderAnswer(
  lessonId: 115,
  orderMap: {0: 22, 1: 23, 2: 24, 3: 25, 4: 26},
);

// للسؤال من نوع match:
final matchBody = QuestionAnswerHelper.createMatchAnswer(
  lessonId: 115,
  matchMap: {18: 18, 19: 19, 20: 20},
);

// للسؤال من نوع choose:
final choiceBody = QuestionAnswerHelper.createChoiceAnswer(
  lessonId: 115,
  selectedChoices: [1, 3, 5],
);

// للسؤال من نوع fill:
final fillBody = QuestionAnswerHelper.createFillAnswer(
  lessonId: 115,
  answer: "الإجابة الصحيحة",
);

// للسؤال من نوع essay:
final essayBody = QuestionAnswerHelper.createEssayAnswer(
  lessonId: 115,
  answer: "هذه إجابتي المفصلة للسؤال المقالي...",
);

// التحويل إلى JSON:
final json = reOrderBody.toJson();
print(json);
// Output: {lessonId: 115, type: "re-order", answers: {0: 22, 1: 23, 2: 24, 3: 25, 4: 26}}

*/
