// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/networking/api_result.dart';
import 'package:prime_academy/features/CoursesModules/data/models/mark_answerd_request_body.dart';

import 'package:prime_academy/features/CoursesModules/data/repo/mark_answered_repo.dart';
import 'package:prime_academy/features/CoursesModules/logic/mark_answered_state.dart';

class MarkAnsweredCubit extends Cubit<MarkAnsweredState> {
  final MarkAnsweredRepo _markAnsweredRepo;

  MarkAnsweredCubit(this._markAnsweredRepo)
    : super(MarkAnsweredState.initial());

  /// الطريقة العامة (للحفاظ على backward compatibility)
  void emitMarkAnsweredState(
    int questionId,
    int lessonId,
    String questionType,
    dynamic answers, // غيرت من List<Map<String, dynamic>> إلى dynamic
  ) async {
    emit(const MarkAnsweredState.loading());

    final requestBody = _createRequestBodyFromType(
      lessonId,
      questionType,
      answers,
    );
    if (requestBody == null) {
      emit(MarkAnsweredState.error(error: 'نوع السؤال غير مدعوم'));
      return;
    }

    final response = await _markAnsweredRepo.getLessonRewardStatus(
      questionId,
      requestBody,
    );

    response.when(
      success: (markAnsweredResponseModel) async {
        emit(MarkAnsweredState.success(markAnsweredResponseModel));
      },
      failure: (error) {
        emit(MarkAnsweredState.error(error: error.apiErrorModel.message ?? ''));
      },
    );
  }

  /// للأسئلة من نوع re-order
  void submitReOrderAnswer(
    int questionId,
    int lessonId,
    Map<int, int> orderMap,
  ) async {
    emit(const MarkAnsweredState.loading());

    final response = await _markAnsweredRepo.submitReOrderAnswer(
      questionId,
      lessonId,
      orderMap,
    );

    _handleResponse(response);
  }

  /// للأسئلة من نوع match
  void submitMatchAnswer(
    int questionId,
    int lessonId,
    Map<int, int> matchMap,
  ) async {
    emit(const MarkAnsweredState.loading());

    final response = await _markAnsweredRepo.submitMatchAnswer(
      questionId,
      lessonId,
      matchMap,
    );

    _handleResponse(response);
  }

  /// للأسئلة من نوع choose (multiple choice)
  void submitChoiceAnswer(
    int questionId,
    int lessonId,
    List<int> selectedChoices,
  ) async {
    emit(const MarkAnsweredState.loading());

    final response = await _markAnsweredRepo.submitChoiceAnswer(
      questionId,
      lessonId,
      selectedChoices,
    );

    _handleResponse(response);
  }

  /// للأسئلة من نوع fill-in-blanks
  void submitFillAnswer(int questionId, int lessonId, String answer) async {
    emit(const MarkAnsweredState.loading());

    final response = await _markAnsweredRepo.submitFillAnswer(
      questionId,
      lessonId,
      answer,
    );

    _handleResponse(response);
  }

  void submitEssayAnswer(int questionId, int lessonId, String answer) async {
    emit(const MarkAnsweredState.loading());

    // إضافة logging للـ JSON
    final requestBody = QuestionAnswerHelper.createEssayAnswer(
      lessonId: lessonId,
      answer: answer,
    );

    print('Essay Request JSON: ${jsonEncode(requestBody.toJson())}');

    final response = await _markAnsweredRepo.submitEssayAnswer(
      questionId,
      lessonId,
      answer,
    );

    _handleResponse(response);
  }

  /// طريقة مساعدة للتعامل مع الـ response
  void _handleResponse(ApiResult response) {
    response.when(
      success: (markAnsweredResponseModel) async {
        emit(MarkAnsweredState.success(markAnsweredResponseModel));
      },
      failure: (error) {
        emit(MarkAnsweredState.error(error: error.apiErrorModel.message ?? ''));
      },
    );
  }

  /// طريقة مساعدة لإنشاء الـ request body من النوع والبيانات
  MarkAnsweredRequestBody? _createRequestBodyFromType(
    int lessonId,
    String questionType,
    dynamic answers,
  ) {
    switch (questionType.toLowerCase()) {
      case 're-order':
        if (answers is Map<int, int>) {
          return QuestionAnswerHelper.createReOrderAnswer(
            lessonId: lessonId,
            orderMap: answers,
          );
        } else if (answers is Map<String, dynamic>) {
          // تحويل String keys إلى int
          final orderMap = <int, int>{};
          answers.forEach((key, value) {
            final intKey = int.tryParse(key.toString());
            final intValue = int.tryParse(value.toString());
            if (intKey != null && intValue != null) {
              orderMap[intKey] = intValue;
            }
          });
          return QuestionAnswerHelper.createReOrderAnswer(
            lessonId: lessonId,
            orderMap: orderMap,
          );
        }
        break;

      case 'match':
        if (answers is Map<int, int>) {
          return QuestionAnswerHelper.createMatchAnswer(
            lessonId: lessonId,
            matchMap: answers,
          );
        } else if (answers is Map<String, dynamic>) {
          // تحويل String keys إلى int
          final matchMap = <int, int>{};
          answers.forEach((key, value) {
            final intKey = int.tryParse(key.toString());
            final intValue = int.tryParse(value.toString());
            if (intKey != null && intValue != null) {
              matchMap[intKey] = intValue;
            }
          });
          return QuestionAnswerHelper.createMatchAnswer(
            lessonId: lessonId,
            matchMap: matchMap,
          );
        }
        break;

      case 'choose':
        if (answers is List<int>) {
          return QuestionAnswerHelper.createChoiceAnswer(
            lessonId: lessonId,
            selectedChoices: answers,
          );
        } else if (answers is List) {
          // تحويل List<dynamic> إلى List<int>
          final choices = answers
              .map((e) => int.tryParse(e.toString()))
              .where((e) => e != null)
              .cast<int>()
              .toList();
          return QuestionAnswerHelper.createChoiceAnswer(
            lessonId: lessonId,
            selectedChoices: choices,
          );
        }
        break;

      case 'fill':
        if (answers is String) {
          return QuestionAnswerHelper.createFillAnswer(
            lessonId: lessonId,
            answer: answers,
          );
        } else if (answers is List && answers.isNotEmpty) {
          return QuestionAnswerHelper.createFillAnswer(
            lessonId: lessonId,
            answer: answers.first.toString(),
          );
        }
        break;

      case 'essay':
        if (answers is String) {
          return QuestionAnswerHelper.createEssayAnswer(
            lessonId: lessonId,
            answer: answers,
          );
        } else if (answers is List && answers.isNotEmpty) {
          return QuestionAnswerHelper.createEssayAnswer(
            lessonId: lessonId,
            answer: answers.first.toString(),
          );
        }
        break;
    }

    return null;
  }
}

// مثال على الاستخدام في الـ UI:
/*

// في الـ Dialog أو Widget:
class SomeQuestionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<MarkAnsweredCubit, MarkAnsweredState>(
      listener: (context, state) {
        state.when(
          initial: () {},
          loading: () {
            // إظهار loading
          },
          success: (data) {
            final isLastReward = data.lastReward ?? false;
            // التعامل مع النتيجة
            if (isLastReward) {
              // إظهار مكافأة
            } else {
              // الانتقال للسؤال التالي
            }
          },
          error: (error) {
            // إظهار رسالة خطأ
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error)),
            );
          },
        );
      },
      child: // UI content
    );
  }
}

// استخدام الطرق المختلفة:

// للسؤال من نوع re-order:
context.read<MarkAnsweredCubit>().submitReOrderAnswer(
  questionId,
  lessonId,
  {0: 22, 1: 23, 2: 24},
);

// للسؤال من نوع match:
context.read<MarkAnsweredCubit>().submitMatchAnswer(
  questionId,
  lessonId,
  {18: 18, 19: 19, 20: 20},
);

// للسؤال من نوع choose:
context.read<MarkAnsweredCubit>().submitChoiceAnswer(
  questionId,
  lessonId,
  [1, 3, 5],
);

// للسؤال من نوع fill:
context.read<MarkAnsweredCubit>().submitFillAnswer(
  questionId,
  lessonId,
  "الإجابة الصحيحة",
);

// للسؤال من نوع essay:
context.read<MarkAnsweredCubit>().submitEssayAnswer(
  questionId,
  lessonId,
  "إجابة السؤال المقالي...",
);

// أو استخدام الطريقة العامة (للكود القديم):
context.read<MarkAnsweredCubit>().emitMarkAnsweredState(
  questionId,
  lessonId,
  "re-order",
  {0: 22, 1: 23, 2: 24},
);

*/
