import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

Future<void> firebaseSetup() async {
  await Firebase.initializeApp();

  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: 'test@gmail.com', password: '12345678');
  } on FirebaseAuthException catch (_) {
  } on Exception catch (e) {
    debugPrint(e.toString());
  }

  await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: 'test@gmail.com', password: '12345678');
}
