import 'package:get/get.dart';

class PhoneValidator {
  static final PhoneValidator _singleton = PhoneValidator._internal();
  factory PhoneValidator() {
    return _singleton;
  }
  PhoneValidator._internal();
  static String? validate(String? phone) {
    if (phone == null || phone.isEmpty) {
      return 'digite um numero de telefone';
    } else if (phone.length < 14 || !phone.isPhoneNumber) {
      return 'Digite um numero valido';
    }
    return null;
  }
}
