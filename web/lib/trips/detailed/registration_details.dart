import 'package:flutter/material.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:web/utils/other.dart';

class RegistrationDetails extends StatelessWidget {
  RegistrationDetails({required this.registration, Key? key})
      : super(key: key) {
    switch (registration['type']) {
      case 'sheep':
        title = 'Registrert sau';
        break;
      case 'injuredSheep':
        title = 'Registrert saueskade';
        break;
      case 'cadaver':
        title = 'Registrert kadaver';
        break;
      case 'predator':
        title = 'Registrert rovdyr';
        break;
      case 'note':
        title = 'Registrert notat';
        break;
    }
  }

  final Map<String, dynamic> registration;
  late final String title;

  @override
  Widget build(BuildContext context) {
    switch (registration['type']) {
      case 'sheep':
        return SheepRegistrationDetails(registration: registration);
        title = 'Registrert sau';
        break;
      case 'injuredSheep':
        title = 'Registrert saueskade';
        break;
      case 'cadaver':
        title = 'Registrert kadaver';
        break;
      case 'predator':
        title = 'Registrert rovdyr';
        break;
      case 'note':
        title = 'Registrert notat';
        break;
    }

    return const SimpleDialog(children: [Text('Det har skjedd en feil')]);

    /*return SimpleDialog(
      title: Text(title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    );*/
  }
}

const TextStyle dialogHeadlineTextStyle =
    TextStyle(fontSize: 22, fontWeight: FontWeight.bold);

const double iconSize = 35;

const double verticalRowSpace = 5;
const double verticalTypeSpace = 20;
const double horizontalRowSpace = 15;

const TextStyle registrationDetailsNumberTextStyle =
    TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
const TextStyle registrationDetailsDescriptionTextStyle =
    TextStyle(fontSize: 22);

final double doubleDigitsWidth =
    textSize('99', registrationDetailsNumberTextStyle).width + 5;
final double tripleDigitsWidth =
    textSize('999', registrationDetailsNumberTextStyle).width + 5;

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
      title: const Text('Registrert sau',
          style: dialogHeadlineTextStyle, textAlign: TextAlign.center),
      children: [
        const Padding(padding: EdgeInsets.only(top: 20)),
        Row(
          children: [
            SizedBox(
                width: 80,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Image(
                        image: AssetImage('images/sheep.png'),
                        height: 30,
                        filterQuality: FilterQuality.high,
                      ),
                      Image(
                        image: AssetImage('images/sheep.png'),
                        height: iconSize,
                        filterQuality: FilterQuality.high,
                      )
                    ])),
            const SizedBox(width: horizontalRowSpace),
            SizedBox(
                width: numberWidth,
                child: Text('${registration['sheep']}',
                    style: registrationDetailsNumberTextStyle)),
            const SizedBox(width: horizontalRowSpace),
            const Text('Sauer & Lam',
                style: registrationDetailsDescriptionTextStyle),
          ],
        ),
        const SizedBox(height: verticalRowSpace),
        Row(children: [
          const SizedBox(
              width: 80,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Image(
                    image: AssetImage('images/sheep.png'),
                    height: iconSize,
                  ))),
          const SizedBox(width: horizontalRowSpace),
          SizedBox(
              width: numberWidth,
              child: Text('${registration['sheep'] - registration['lambs']}',
                  style: registrationDetailsNumberTextStyle)),
          const SizedBox(width: horizontalRowSpace),
          const Text('Sauer', style: registrationDetailsDescriptionTextStyle),
        ]),
        const SizedBox(height: verticalRowSpace + 5),
        Row(children: [
          SizedBox(
              width: 80,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Image(
                      image: AssetImage('images/sheep.png'),
                      height: 30,
                    ),
                    SizedBox(width: 2.5)
                  ])),
          const SizedBox(width: horizontalRowSpace),
          SizedBox(
              width: numberWidth,
              child: Text('${registration['lambs']}',
                  style: registrationDetailsNumberTextStyle)),
          const SizedBox(width: horizontalRowSpace),
          const Text('Lam', style: registrationDetailsDescriptionTextStyle),
        ]),
        const SizedBox(height: verticalTypeSpace),
        Row(children: [
          SizedBox(
              width: 80,
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
                  style: registrationDetailsNumberTextStyle)),
          const SizedBox(width: horizontalRowSpace),
          const Text('Hvite', style: registrationDetailsDescriptionTextStyle),
        ]),
        const SizedBox(height: verticalRowSpace),
        Row(children: [
          const SizedBox(
              width: 80,
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
                  style: registrationDetailsNumberTextStyle)),
          const SizedBox(width: horizontalRowSpace),
          const Text('Brune', style: registrationDetailsDescriptionTextStyle),
        ]),
        const SizedBox(height: verticalRowSpace),
        Row(children: [
          const SizedBox(
              width: 80,
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
                  style: registrationDetailsNumberTextStyle)),
          const SizedBox(width: horizontalRowSpace),
          const Text('Svarte', style: registrationDetailsDescriptionTextStyle),
        ]),
        const SizedBox(height: verticalRowSpace),
        Row(children: [
          const SizedBox(
              width: 80,
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
                  style: registrationDetailsNumberTextStyle)),
          const SizedBox(width: horizontalRowSpace),
          const Text('Svart hode',
              style: registrationDetailsDescriptionTextStyle),
        ]),
      ],
    );
  }
}
