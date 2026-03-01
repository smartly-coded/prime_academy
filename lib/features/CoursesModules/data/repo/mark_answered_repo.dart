import 'dart:convert';

import 'package:prime_academy/core/networking/api_error_handler.dart';
import 'package:prime_academy/core/networking/api_result.dart';
import 'package:prime_academy/core/networking/api_service.dart';
import 'package:prime_academy/features/CoursesModules/data/models/mark_answerd_request_body.dart';
import 'package:prime_academy/features/CoursesModules/data/models/mark_answered_response_model.dart';

class MarkAnsweredRepo {
  final ApiService _apiService; //مسئول عن ارسال الطلبات لل api

  MarkAnsweredRepo(this._apiService); 

  Future<ApiResult<MarkAnsweredResponseModel>> getLessonRewardStatus(
    int questionId,
    MarkAnsweredRequestBody requestBody,
  ) async {
    try {
      // طباعة الـ JSON الفعلي
      print('Sending JSON to API: ${jsonEncode(requestBody.toJson())}');

      final response = await _apiService.getLessonRewardStatus(
        questionId,
        requestBody,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  /// للأسئلة من نوع re-order
  Future<ApiResult<MarkAnsweredResponseModel>> submitReOrderAnswer(
    int questionId,
    int lessonId,
    Map<int, int> orderMap, // index -> questionId
  ) async {
    final requestBody = QuestionAnswerHelper.createReOrderAnswer(
      lessonId: lessonId,
      orderMap: orderMap,
    );

    return getLessonRewardStatus(questionId, requestBody);
  }

  /// للأسئلة من نوع match
  Future<ApiResult<MarkAnsweredResponseModel>> submitMatchAnswer(
    int questionId,
    int lessonId,
    Map<int, int> matchMap, // questionId -> answerId
  ) async {
    final requestBody = QuestionAnswerHelper.createMatchAnswer(
      lessonId: lessonId,
      matchMap: matchMap,
    );

    return getLessonRewardStatus(questionId, requestBody);
  }

  /// للأسئلة من نوع choose (multiple choice)
  Future<ApiResult<MarkAnsweredResponseModel>> submitChoiceAnswer(
    int questionId,
    int lessonId,
    List<int> selectedChoices,
  ) async {
    final requestBody = QuestionAnswerHelper.createChoiceAnswer(
      lessonId: lessonId,
      selectedChoices: selectedChoices,
    );

    return getLessonRewardStatus(questionId, requestBody);
  }

  /// للأسئلة من نوع fill-in-blanks
  Future<ApiResult<MarkAnsweredResponseModel>> submitFillAnswer(
    int questionId,
    int lessonId,
    String answer,
  ) async {
    final requestBody = QuestionAnswerHelper.createFillAnswer(
      lessonId: lessonId,
      answer: answer,
    );

    return getLessonRewardStatus(questionId, requestBody);
  }

  /// للأسئلة من نوع essay
  Future<ApiResult<MarkAnsweredResponseModel>> submitEssayAnswer(
    int questionId,
    int lessonId,
    String answer,
  ) async {
    final requestBody = QuestionAnswerHelper.createEssayAnswer(
      lessonId: lessonId,
      answer: answer,
    );

    return getLessonRewardStatus(questionId, requestBody);
  }


  Future<ApiResult<dynamic>> markLessonWatched(int lessonId) async {
  try {
    await _apiService.markLessonWatched(lessonId);
    return const ApiResult.success(null);
  } catch (error) {
    return ApiResult.failure(ErrorHandler.handle(error));
  }
}
}
