import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/features/ranckingScreen/data/repos/rank_repo.dart';

import 'rank_state.dart';


class RankCubit extends Cubit<RankState> {
  final RankRepository repository;

  RankCubit(this.repository) : super(RankInitial());

  Future<void> fetchRanks(int courseId) async {
    emit(RankLoading());
    try {
      final ranks = await repository.getRanks(courseId);
      emit(RankSuccess(ranks));
    } catch (e) {
      emit(RankError(e.toString()));
    }
  }

  
}
