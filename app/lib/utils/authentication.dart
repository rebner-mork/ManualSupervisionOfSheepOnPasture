import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String?> createUser(
    String name, String email, String password, String phone) async {
  try {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    await users.add({'name': name, 'email': email, 'phone': phone});
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
