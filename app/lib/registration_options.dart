import 'package:app/utils/styles.dart';
import 'package:flutter/material.dart';

class RegistrationOptions extends StatefulWidget {
  const RegistrationOptions({Key? key}) : super(key: key);

  @override
  State<RegistrationOptions> createState() => _RegistrationOptionsState();
}

class _RegistrationOptionsState extends State<RegistrationOptions> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 20),
      children: [
        Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              'Registrer',
              style: drawerHeadlineTextStyle,
              textAlign: TextAlign.center,
            )),
        const RegistrationTypeListTile(
            text: 'Sau', assetImageName: 'images/sheep_white.png'),
        const RegistrationTypeListTile(
            text: 'Skade', assetImageName: 'images/sheep_injured.png'),
        const RegistrationTypeListTile(
            text: 'Død', assetImageName: 'images/sheep_dead.png'),
        const RegistrationTypeListTile(
            text: 'Rovdyr', assetImageName: 'images/predator.png'),
        const RegistrationTypeListTile(
            text: 'Notat', assetImageName: 'images/note.png'),
      ],
    );
  }
}

class RegistrationTypeListTile extends StatelessWidget {
  const RegistrationTypeListTile(
      {required this.text, required this.assetImageName, Key? key})
      : super(key: key);

  final String text;
  final String assetImageName;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 30),
        child: InkWell(
            child: DecoratedBox(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Flexible(
                        child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Image(
                              image: AssetImage(assetImageName),
                              width: 60,
                            ))),
                    const SizedBox(width: 25),
                    Flexible(
                        child: Text(
                      text,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ))
                  ],
                ))));
  }
}
