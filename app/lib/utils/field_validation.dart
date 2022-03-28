import 'package:email_validator/email_validator.dart';

String? validateName(String? name) {
  if (name!.isEmpty) {
    return 'Skriv fullt navn';
  } else if (!name.contains(' ')) {
    return 'Skriv fornavn og etternavn';
  }
  return null;
}

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

String? validatePasswords(String? passwordOne, String? passwordTwo) {
  if (passwordOne != passwordTwo) {
    return 'Passordene er ikke like';
  } else if (validatePassword(passwordOne) != null) {
    return validatePassword(passwordOne);
  } else if (validatePassword(passwordTwo) != null) {
    return validatePassword(passwordTwo);
  }

  return null;
}

String? validatePhone(String? phone) {
  if (phone!.isEmpty) {
    return 'Skriv telefonnummer';
  } else if (double.tryParse(phone) == null) {
    return 'Telefonnummer må kun bestå av siffer';
  } else if (phone.length < 8) {
    return 'Telefonnummer må inneholde minst 8 siffer';
  }

  return null;
}
