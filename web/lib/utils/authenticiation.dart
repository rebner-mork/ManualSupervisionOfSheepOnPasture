import 'package:firebase_auth/firebase_auth.dart';

Future<String> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return '';
  } catch (e) {
    //TODO return different thing based on exception
    return "Passord og/eller e-post stemmer ikke";
  }
}
