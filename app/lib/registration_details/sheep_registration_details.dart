import 'package:app/utils/constants.dart';
import 'package:app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';

class SheepRegistrationDetails extends StatelessWidget {
  SheepRegistrationDetails({required this.registration, Key? key})
      : super(key: key) {
    numberWidth = registration['sheep'] < 10
        ? horizontalRowSpace
        : registration['sheep'] < 100
            ? doubleDigitsWidth
            : tripleDigitsWidth;
  }

  final Map<String, dynamic> registration;
  late final double numberWidth;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.fromLTRB(
          registration.keys.length > 10 ? 10.0 : 30.0, 32.0, 0.0, 16.0),
      title: Text(
          registration.keys.length > 10
              ? 'Nærregistrert sau'
              : 'Avstandsregistrert sau',
          style: dialogHeadlineTextStyle,
          textAlign: TextAlign.center),
      children: [
        Column(children: [
          SheepColumn(registration: registration, numberWidth: numberWidth),
          if (registration.keys.length > 10)
            const SizedBox(width: 25, height: verticalTypeSpace),
          EartagTieColumn(registration: registration, numberWidth: numberWidth)
        ])
      ],
    );
  }
}

class SheepColumn extends StatelessWidget {
  const SheepColumn(
      {required this.registration, required this.numberWidth, Key? key})
      : super(key: key);

  final Map<String, dynamic> registration;
  final double numberWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
                width: 70,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Icon(RpgAwesome.sheep,
                          size: iconSize - 10, color: Colors.grey),
                      Icon(RpgAwesome.sheep, size: iconSize, color: Colors.grey)
                    ])),
            const SizedBox(width: horizontalRowSpace),
            SizedBox(
                width: numberWidth,
                child: Text('${registration['sheep']}',
                    style: registrationDetailsNumberTextStyle,
                    textAlign: TextAlign.center)),
            const SizedBox(width: horizontalRowSpace),
            const Text('Sauer & Lam',
                style: registrationDetailsDescriptionTextStyle),
          ],
        ),
        const SizedBox(height: verticalRowSpace),
        Row(children: [
          const SizedBox(
              width: 70,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(RpgAwesome.sheep,
                      size: iconSize, color: Colors.grey))),
          const SizedBox(width: horizontalRowSpace),
          SizedBox(
              width: numberWidth,
              child: Text('${registration['sheep'] - registration['lambs']}',
                  style: registrationDetailsNumberTextStyle,
                  textAlign: TextAlign.center)),
          const SizedBox(width: horizontalRowSpace),
          const Text('Sauer', style: registrationDetailsDescriptionTextStyle),
        ]),
        const SizedBox(height: verticalRowSpace + 5),
        Row(children: [
          SizedBox(
              width: 70,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Icon(RpgAwesome.sheep, size: iconSize, color: Colors.grey),
                    SizedBox(width: 2.5)
                  ])),
          const SizedBox(width: horizontalRowSpace),
          SizedBox(
              width: numberWidth,
              child: Text('${registration['lambs']}',
                  style: registrationDetailsNumberTextStyle,
                  textAlign: TextAlign.center)),
          const SizedBox(width: horizontalRowSpace),
          const Text('Lam', style: registrationDetailsDescriptionTextStyle),
        ]),
        const SizedBox(height: verticalTypeSpace),
        Row(children: [
          SizedBox(
              width: 70,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                      width: iconSize + 3,
                      color: Colors.grey.shade400,
                      child: const Icon(
                        RpgAwesome.sheep,
                        color: Colors.white,
                        size: iconSize,
                      )))),
          const SizedBox(width: horizontalRowSpace),
          SizedBox(
              width: numberWidth,
              child: Text('${registration['white']}',
                  style: registrationDetailsNumberTextStyle,
                  textAlign: TextAlign.center)),
          const SizedBox(width: horizontalRowSpace),
          const Text('Hvite', style: registrationDetailsDescriptionTextStyle),
        ]),
        const SizedBox(height: verticalRowSpace),
        Row(children: [
          const SizedBox(
              width: 70,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    RpgAwesome.sheep,
                    color: Colors.brown,
                    size: iconSize,
                  ))),
          const SizedBox(width: horizontalRowSpace),
          SizedBox(
              width: numberWidth,
              child: Text('${registration['brown']}',
                  style: registrationDetailsNumberTextStyle,
                  textAlign: TextAlign.center)),
          const SizedBox(width: horizontalRowSpace),
          const Text('Brune', style: registrationDetailsDescriptionTextStyle),
        ]),
        const SizedBox(height: verticalRowSpace),
        Row(children: [
          const SizedBox(
              width: 70,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    RpgAwesome.sheep,
                    color: Colors.black,
                    size: iconSize,
                  ))),
          const SizedBox(width: horizontalRowSpace),
          SizedBox(
              width: numberWidth,
              child: Text('${registration['black']}',
                  style: registrationDetailsNumberTextStyle,
                  textAlign: TextAlign.center)),
          const SizedBox(width: horizontalRowSpace),
          const Text('Svarte', style: registrationDetailsDescriptionTextStyle),
        ]),
        const SizedBox(height: verticalRowSpace),
        Row(children: [
          const SizedBox(
              width: 70,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    RpgAwesome.sheep,
                    color: Colors.black,
                    size: iconSize,
                  ))),
          const SizedBox(width: horizontalRowSpace),
          SizedBox(
              width: numberWidth,
              child: Text('${registration['blackHead']}',
                  style: registrationDetailsNumberTextStyle,
                  textAlign: TextAlign.center)),
          const SizedBox(width: horizontalRowSpace),
          const Text('Svarte hoder',
              style: registrationDetailsDescriptionTextStyle),
        ]),
      ],
    );
  }
}

class EartagTieColumn extends StatelessWidget {
  EartagTieColumn(
      {required this.registration, required this.numberWidth, Key? key})
      : super(key: key) {
    eartagKeys = [];
    tieKeys = [];

    possibleEartagColorStringToKey.values.map((String eartagKey) {
      if (registration.containsKey(eartagKey)) {
        eartagKeys.add(eartagKey);
      }
    }).toList();

    possibleTieColorStringToKey.values.map((String tieKey) {
      if (registration.containsKey(tieKey)) {
        tieKeys.add(tieKey);
      }
    }).toList();
  }

  final Map<String, dynamic> registration;
  final double numberWidth;
  late final List<String> eartagKeys;
  late final List<String> tieKeys;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ...eartagKeys.map((String eartagKey) => Row(
            children: [
              SizedBox(
                  width: 70,
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.local_offer,
                          size: iconSize,
                          color: Color(int.parse(
                              possibleEartagColorStringToKey.keys.firstWhere(
                                  (element) =>
                                      possibleEartagColorStringToKey[element] ==
                                      eartagKey),
                              radix: 16))))),
              const SizedBox(width: horizontalRowSpace),
              SizedBox(
                  width: numberWidth,
                  child: Text('${registration[eartagKey]}',
                      style: registrationDetailsNumberTextStyle,
                      textAlign: TextAlign.center)),
              const SizedBox(width: horizontalRowSpace),
              Text(
                  '${colorValueStringToColorStringGuiPlural[possibleEartagColorStringToKey.keys.firstWhere((element) => possibleEartagColorStringToKey[element] == eartagKey)]}',
                  style: registrationDetailsDescriptionTextStyle),
              const SizedBox(height: verticalRowSpace + 30),
            ],
          )),
      const SizedBox(height: verticalTypeSpace),
      ...tieKeys.map((String tieKey) => Row(
            children: [
              SizedBox(
                  width: 70,
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(FontAwesome5.black_tie,
                          size: iconSize - 2,
                          color: Color(int.parse(
                              possibleTieColorStringToKey.keys.firstWhere(
                                  (element) =>
                                      possibleTieColorStringToKey[element] ==
                                      tieKey),
                              radix: 16))))),
              const SizedBox(width: horizontalRowSpace),
              SizedBox(
                  width: numberWidth,
                  child: Text('${registration[tieKey]}',
                      style: registrationDetailsNumberTextStyle,
                      textAlign: TextAlign.center)),
              const SizedBox(width: horizontalRowSpace),
              Text(
                  '${colorValueStringToColorStringGuiPlural[possibleTieColorStringToKey.keys.firstWhere((element) => possibleTieColorStringToKey[element] == tieKey)]}',
                  style: registrationDetailsDescriptionTextStyle),
              const SizedBox(height: verticalRowSpace + 30 + 2),
            ],
          )),
    ]);
  }
}
