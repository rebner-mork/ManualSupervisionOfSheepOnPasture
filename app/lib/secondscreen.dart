import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key, required this.userCredential})
      : super(key: key);
  final UserCredential userCredential;

  @override
  _State createState() => _State();
}

class _State extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(FirebaseAuth.instance.currentUser!.email.toString() +
              widget.userCredential.user!.email.toString())),
    );
  }
}
