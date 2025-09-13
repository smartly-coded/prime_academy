class CommRequest {
  final String phoneNumber;

  CommRequest({required this.phoneNumber});

  Map<String, dynamic> toJson() {
    return {
      "phone_number": phoneNumber,
    };
  }
}
