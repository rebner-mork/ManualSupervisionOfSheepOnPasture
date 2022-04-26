import 'package:app/utils/constants.dart';
import 'package:app/utils/styles.dart';
import 'package:flutter/material.dart';

class RegistrationOptions extends StatefulWidget {
  const RegistrationOptions(
      {required this.ties, required this.onRegisterOptionSelected, Key? key})
      : super(key: key);

  final Map<String, int?> ties;
  final Function(RegistrationType) onRegisterOptionSelected;

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
          onPressed: () {
            Navigator.of(context).pop();
            widget.onRegisterOptionSelected(RegistrationType.sheep);
          },
        ),
        RegistrationTypeListTile(
            text: 'Skade',
            assetImageName: 'images/sheep_injured.png',
            onPressed: () {
              Navigator.of(context).pop();
              widget.onRegisterOptionSelected(RegistrationType.injury);
            }),
        RegistrationTypeListTile(
            text: 'Kadaver',
            assetImageName: 'images/sheep_dead.png',
            onPressed: () {
              Navigator.of(context).pop();
              widget.onRegisterOptionSelected(RegistrationType.cadaver);
            }),
        RegistrationTypeListTile(
            text: 'Rovdyr',
            assetImageName: 'images/predator.png',
            onPressed: () {}),
        RegistrationTypeListTile(
            text: 'Notat',
            assetImageName: 'images/note.png',
            onPressed: () {
              Navigator.of(context).pop();
              widget.onRegisterOptionSelected(RegistrationType.note);
            }),
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
        child: Container(
            decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(blurRadius: 2, offset: Offset(0, 2))
                ]),
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                    highlightColor: Colors.green.shade700,
                    onTap: onPressed,
                    child: Row(
                      children: [
                        Flexible(
                            child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Image(
                                  image: AssetImage(assetImageName),
                                  width: 55,
                                ))),
                        Expanded(
                            child: Text(
                          text,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ))
                      ],
                    )))));
  }
}
