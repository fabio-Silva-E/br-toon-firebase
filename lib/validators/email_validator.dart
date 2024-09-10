class EmailValidator {
  static final EmailValidator _singleton = EmailValidator._internal();
  factory EmailValidator() {
    return _singleton;
  }
  EmailValidator._internal();
  static String? validate(String? email) {
    final emailRegex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (email == null || email.isEmpty) {
      return 'Email obrigatorio';
    } else if (!emailRegex.hasMatch(email)) {
      return 'Esse email não e valido';
    } else if (email.length > 200) {
      return 'email muito longo';
    }
    return null;
  }
}
