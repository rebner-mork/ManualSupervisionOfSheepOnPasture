import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String?> createUser(
    String name, String email, String password, String phone) async {
  try {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    log('Bruker registrert: ' + user.toString());

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    await users.add({'name': name, 'email': email, 'phone': phone}).then(
        (value) => log('Telefonnummer lagt til i users/' + value.id));
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'E-posten er allerede i bruk';
      case 'invalid-email':
        return 'Skriv gyldig e-post';
      case 'weak-password':
        return 'Skriv sterkere passord';
    }
  }

  return null;
}

Future<String> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return '';
  } on FirebaseAuthException {
    return "E-post og/eller passord er ugyldig";
  } catch (e) {
    return "Noe gikk galt";
  }
}
