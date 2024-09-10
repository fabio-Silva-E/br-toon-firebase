class ErrorsConst {
  static final ErrorsConst _singleton = ErrorsConst._internal();

  factory ErrorsConst() {
    return _singleton;
  }

  ErrorsConst._internal();
  static const API_DEFALT_ERROR = "erro por favor tente novamente mais tarde";
}
