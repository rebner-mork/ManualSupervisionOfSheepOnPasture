import 'package:flutter/material.dart';

class CreateUserView extends StatelessWidget {
  const CreateUserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.yellow,
        child: ElevatedButton(
          child: const Text("Gå tilbake"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
