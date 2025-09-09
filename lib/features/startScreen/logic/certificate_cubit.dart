import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/features/startScreen/data/models/certificate_response.dart';
import 'package:prime_academy/features/startScreen/data/repos/start_screen_repo.dart';
import 'package:prime_academy/features/startScreen/logic/start_screen_state.dart';
import 'package:prime_academy/core/networking/api_result.dart';

class CertificateCubit extends Cubit<StartScreenState> {
  final StartScreenRepo _startScreenRepo;
  CertificateCubit(this._startScreenRepo) : super(StartScreenState.initial());
  void emitCertificateState() async {
    emit(const StartScreenState.loading());
    final response = await _startScreenRepo.getCertificates();
    response.when(
      success: (certificates) async {
        emit(StartScreenState<List<CertificateResponse>>.success(certificates));
      },
      failure: (error) {
        emit(StartScreenState.error(error: error.apiErrorModel.message ?? ''));
      },
    );
  }
}
