import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/features/start_CommRequest/data/models/commRequest_model.dart';
import 'package:prime_academy/features/start_CommRequest/data/repos/commRequest_repo.dart';

part 'CommRequest_state.dart';

class CommRequestCubit extends Cubit<CommRequestState> {
  final CommRequestRepository repository;

  CommRequestCubit()
      : repository = CommRequestRepository(),
        super(CommRequestInitial());

  Future<void> sendRequest(String phone) async {
    emit(CommRequestLoading());
    try {
      final request = CommRequest(phoneNumber: phone);
      final success = await repository.sendCommRequest(request);

      if (success) {
        emit(CommRequestSuccess());
      } else {
        emit(CommRequestFailure("فشل إرسال الطلب"));
      }
    } catch (e) {
      emit(CommRequestFailure(e.toString()));
    }
  }
}
