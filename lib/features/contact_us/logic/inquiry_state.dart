abstract class ContactUsState {}

class ContactUsInitial extends ContactUsState {}

class ContactUsLoading extends ContactUsState {}

class ContactUsSuccess extends ContactUsState {}

class ContactUsFailure extends ContactUsState {
  final String message;
  ContactUsFailure(this.message);
}
