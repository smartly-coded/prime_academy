import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/features/startScreen/data/repos/start_screen_repo.dart';
import 'package:prime_academy/features/startScreen/logic/start_screen_state.dart';
import 'package:prime_academy/core/networking/api_result.dart';

class StartScreenCubit extends Cubit<StartScreenState> {
  final StartScreenRepo _startScreenRepo;

  StartScreenCubit(this._startScreenRepo) : super(StartScreenState.initial());

  void emitStartScreenState() async {
    emit(const StartScreenState.loading());
    final response = await _startScreenRepo.getStudents();
    response.when(
      success: (studentsResponse) async {
        emit(StartScreenState.success(studentsResponse));
      },
      failure: (error) {
        emit(StartScreenState.error(error: error.apiErrorModel.message ?? ''));
      },
    );
  }
}
