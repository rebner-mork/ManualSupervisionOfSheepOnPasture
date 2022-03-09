import 'package:flutter/material.dart';

class EndTripDialog extends StatelessWidget {
  const EndTripDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        title: const Text("Avslutt oppsynstur og last opp data?"),
        children: [
          const Icon(Icons.wifi),
          const Text("Tilkoblet nettverk"),
          SimpleDialogOption(
              child: const Text("Fortsett oppsynstur"),
              onPressed: () => Navigator.pop(context, false)),
          SimpleDialogOption(
            child: const Text("Avslutt oppsynstur"),
            onPressed: () => Navigator.pop(context, true),
          )
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
