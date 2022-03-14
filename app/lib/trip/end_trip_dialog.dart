import 'package:app/utils/styles.dart';
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
            color: Colors.grey,
          ),
          const Center(
            child: Text("Tilkoblet nettverk"),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SimpleDialogOption(
                child: Center(
                    child: Text("Nei, fortsett",
                        style: cancelDialogButtonTextStyle)),
                onPressed: () => Navigator.pop(context, false)),
            SimpleDialogOption(
              child: Center(
                  child: Text(
                "Ja, avslutt",
                style: okDialogButtonTextStyle,
              )),
              onPressed: () => Navigator.pop(context, true),
            ),
          ])
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
