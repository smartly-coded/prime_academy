import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/features/contact_us/data/Repos/contact_us_repo.dart';
import 'package:prime_academy/features/contact_us/data/models/inquery_model.dart';
import 'package:prime_academy/features/contact_us/logic/inquiry_state.dart';


class ContactUsCubit extends Cubit<ContactUsState> {
  final ContactUsRepo repo;

  ContactUsCubit(this.repo) : super(ContactUsInitial());

  Future<void> sendInquiry(InquiryRequest request) async {
    emit(ContactUsLoading());
    try {
      final success = await repo.sendInquiry(request);
      if (success) {
        emit(ContactUsSuccess());
      } else {
        emit(ContactUsFailure("Failed to send inquiry"));
      }
    } catch (e) {
      emit(ContactUsFailure(e.toString()));
    }
  }
}
