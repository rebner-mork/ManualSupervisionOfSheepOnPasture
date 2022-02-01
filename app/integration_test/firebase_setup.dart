import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

const String email = 'test@gmail.com';
const String password = '12345678';
const String phone = password;

Future<void> firebaseSetup(
    {bool createUser = false, bool signIn = false}) async {
  await Firebase.initializeApp();

  String host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  FirebaseAuth.instance.useAuthEmulator(host, 9099);
  FirebaseFirestore.instance.useFirestoreEmulator('10.0.2.2', 8080);

  if (createUser) {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (_) {}
    if (!signIn) {
      await FirebaseAuth.instance.signOut();
    }
  }
  if (signIn) {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }
}
