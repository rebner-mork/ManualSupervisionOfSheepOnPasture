import 'package:flutter/material.dart';

class EndTripDialog extends StatelessWidget {
  const EndTripDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        title: const Text(
          "Avslutt og last opp oppsynstur?",
          textAlign: TextAlign.center,
        ),
        children: [
          const SizedBox(
            height: 10,
          ),
          const Icon(
            Icons.wifi,
            size: 80,
            color: Colors.green,
          ),
          const Center(
            child: Text("Tilkoblet nettverk"),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SimpleDialogOption(
              child: const Center(
                  child: Text(
                "Avslutt",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              )),
              onPressed: () => Navigator.pop(context, true),
            ),
            SimpleDialogOption(
                child: const Center(
                    child: Text("Fortsett",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20))),
                onPressed: () => Navigator.pop(context, false))
          ]),
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
