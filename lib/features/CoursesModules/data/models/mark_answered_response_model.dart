import 'package:json_annotation/json_annotation.dart';

part 'mark_answered_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MarkAnsweredResponseModel {
  final bool lessonRewarded;
  MarkAnsweredResponseModel({required this.lessonRewarded});
  factory MarkAnsweredResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MarkAnsweredResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$MarkAnsweredResponseModelToJson(this);
}
