import 'package:app/register/injured_sheep.dart';
import 'package:app/utils/styles.dart';
import 'package:flutter/material.dart';

class RegistrationOptions extends StatefulWidget {
  const RegistrationOptions({required this.ties, Key? key}) : super(key: key);

  final Map<String, int?> ties;

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
        RegistrationTypeListTile(
          text: 'Sau',
          assetImageName: 'images/sheep.png',
          onPressed: () {},
        ),
        RegistrationTypeListTile(
            text: 'Skade',
            assetImageName: 'images/sheep_injured.png',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegisterInjuredSheep(
                            ties: widget.ties,
                          )));
            }),
        RegistrationTypeListTile(
            text: 'Kadaver',
            assetImageName: 'images/sheep_dead.png',
            onPressed: () {}),
        RegistrationTypeListTile(
            text: 'Rovdyr',
            assetImageName: 'images/predator.png',
            onPressed: () {}),
        RegistrationTypeListTile(
            text: 'Notat', assetImageName: 'images/note.png', onPressed: () {}),
      ],
    );
  }
}

class RegistrationTypeListTile extends StatelessWidget {
  const RegistrationTypeListTile(
      {required this.text,
      required this.assetImageName,
      required this.onPressed,
      Key? key})
      : super(key: key);

  final String text;
  final String assetImageName;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 30),
        child: Ink(
            decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(blurRadius: 3, offset: Offset(0, 2))
                ]),
            child: InkWell(
                highlightColor: Colors.green.shade700,
                onTap: onPressed,
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
