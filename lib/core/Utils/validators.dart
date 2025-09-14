class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "البريد الإلكتروني مطلوب";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return "البريد الإلكتروني غير صحيح";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "كلمة المرور مطلوبة";
    }
    if (value.length < 6) {
      return "كلمة المرور يجب أن تكون 6 أحرف على الأقل";
    }
    return null;
  }


  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return "الاسم مطلوب";
    }
    if (value.length < 3) {
      return "الاسم يجب أن يكون على الأقل 3 أحرف";
    }
    return null;
  }

  
  static String? validateKuwaitPhone(String? value) {
    if (value == null || value.isEmpty) {
      return "رقم الهاتف مطلوب";
    }
   
    final kuwaitPhoneRegex = RegExp(r'^\+965[0-9]{8}$');
    if (!kuwaitPhoneRegex.hasMatch(value)) {
      return "رقم الهاتف غير صحيح، يجب أن يبدأ بـ +965 ويتكون من 8 أرقام";
    }
    return null;
  }

  
  static String? validateMessage(String? value) {
    if (value == null || value.isEmpty) {
      return "الرسالة مطلوبة";
    }
    if (value.length < 10) {
      return "الرسالة يجب أن تكون على الأقل 10 أحرف";
    }
    return null;
  }
}
