class PasswordValidator {
  static final PasswordValidator _singleton = PasswordValidator._internal();
  factory PasswordValidator() {
    return _singleton;
  }
  PasswordValidator._internal();
  static String? validate(String? password) {
    if (password == null || password.isEmpty) {
      return 'Senha Obrigatoria';
    } else if (password.length < 7) {
      return 'A senha de ter pelo menos 7 caracteres';
    } else if (password.length > 100) {
      return 'Sua semha deve ter no maximo 100 caracteres';
    }
    return null;
  }
}
