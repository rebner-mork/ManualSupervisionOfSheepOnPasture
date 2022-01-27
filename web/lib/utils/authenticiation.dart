import 'package:firebase_auth/firebase_auth.dart';

Future<String> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return '';
  } on FirebaseAuthException {
    return "Passord og/eller e-post er ugyldig";
  } catch (e) {
    return "Noe gikk galt";
  }
}
