import 'package:firebase_auth/firebase_auth.dart';

Future<UserCredential> signInWithEmailAndPassword(
    String email, String password) async {
  UserCredential user = await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: email, password: password);

  return user;
}
