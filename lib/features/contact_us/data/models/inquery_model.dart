class InquiryRequest {
  final String fullname;
  final String phoneNumber;
  final String content;

  InquiryRequest({
    required this.fullname,
    required this.phoneNumber,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      "fullname": fullname,
      "phone_number": phoneNumber,
      "content": content,
    };
  }
}
