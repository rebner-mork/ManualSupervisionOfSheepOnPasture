import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

const String email = 'test@gmail.com';
const String password = '12345678';
const String phone = password;
const String farmName = 'Reppesgård';
const Map<String, Map<String, Map<String, double>>> validMaps = {
  'Hjertnesskogen': {
    'northWest': {'latitude': 59.125678, 'longitude': 10.210824},
    'southEast': {'latitude': 59.124544, 'longitude': 10.214976}
  },
  'Gon': {
    'northWest': {'latitude': 59.021541, 'longitude': 10.070096},
    'southEast': {'latitude': 59.018361, 'longitude': 10.078612}
  }
};

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

Future<void> setUpFarm(
    {Map<String, Map<String, Map<String, double>>>? maps = validMaps}) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  CollectionReference farmCollection =
      FirebaseFirestore.instance.collection('farms');
  DocumentReference farmDoc = farmCollection.doc(uid);

  await farmDoc.get();

  farmDoc.set({
    'maps': maps,
    'ties': null,
    'eartags': null,
    'personnel': [email],
    'name': farmName,
    'address': null
  });

  CollectionReference personnelCollection =
      FirebaseFirestore.instance.collection('personnel');
  DocumentReference personnelDoc = personnelCollection.doc(email);

  await personnelDoc.get();
  personnelDoc.set({
    'farms': [uid]
  });
}
