import 'package:email_validator/email_validator.dart';

String? validateEmail(String? userName) {
  if (userName!.isEmpty) {
    return "Skriv inn e-post";
  } else if (!EmailValidator.validate(userName)) {
    return "Skriv gyldig e-post";
  }
  return null;
}

String? validatePassword(String? password) {
  int requiredLength = 8;
  if (password!.isEmpty) {
    return "Skriv inn passord";
  } else if (password.length < requiredLength) {
    return "Passord må inneholde minst $requiredLength tegn";
  }
  return null;
}
