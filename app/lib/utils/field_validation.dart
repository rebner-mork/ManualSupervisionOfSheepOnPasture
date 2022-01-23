import 'package:email_validator/email_validator.dart';

String? validateEmail(String? email) {
  if (email!.isEmpty) {
    return 'Skriv e-post';
  } else if (!EmailValidator.validate(email)) {
    return 'Skriv gyldig e-post';
  }
  return null;
}

String? validatePassword(String? password) {
  if (password!.isEmpty) {
    return 'Skriv passord';
  } else if (password.length < 8) {
    return 'Passord må inneholde minst 8 tegn';
  }

  return null;
}
