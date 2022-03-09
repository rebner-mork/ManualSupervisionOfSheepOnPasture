import 'package:flutter/material.dart';

class EndTripDialog extends StatelessWidget {
  const EndTripDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        title: const Text("Avslutt og last opp data?"),
        children: [
          const SizedBox(
            height: 10,
          ),
          const Icon(
            Icons.wifi,
            size: 80,
            color: Colors.grey,
          ),
          const Center(
            child: Text("Tilkoblet nettverk"),
          ),
          const SizedBox(
            height: 30,
          ),
          SimpleDialogOption(
            child: const Center(
                child: Text(
              "Avslutt oppsynstur",
              style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            )),
            onPressed: () => Navigator.pop(context, true),
          ),
          SimpleDialogOption(
              child: const Center(child: Text("Fortsett oppsynstur")),
              onPressed: () => Navigator.pop(context, false)),
        ]);
  }
}

Future<bool> showEndTripDialog(BuildContext context) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const EndTripDialog();
      });
}
