class Regex {
  static final emailValidationRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  static final onlyNumberInput = RegExp(r"^[0-9]+$");
}
