import 'package:prime_academy/features/ranckingScreen/data/models/rankingModel.dart';

abstract class RankState {}

class RankInitial extends RankState {}

class RankLoading extends RankState {}

class RankSuccess extends RankState {
  final List<RankingModel> ranks;
  RankSuccess(this.ranks);
}

class RankError extends RankState {
  final String message;
  RankError(this.message);
}
