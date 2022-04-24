import 'package:app/utils/constants.dart';
import 'package:app/utils/other.dart';
import 'package:app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';

const tripOverviewNumberTextStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
const tripOverviewDescriptionTextStyle = TextStyle(fontSize: 20);
const double verticalRowSpace = 5;
const double verticalTypeSpace = 20;
const double horizontalRowSpace = 15;

class TripOverview extends StatelessWidget {
  const TripOverview(
      {required this.totalSheepAmount,
      required this.lambAmount,
      required this.registeredEartags,
      required this.registeredTies,
      Key? key})
      : super(key: key);

  final int totalSheepAmount;
  final int lambAmount;
  final Map<String, Object> registeredEartags;
  final Map<String, Object> registeredTies;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 20),
      children: [
        Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              'Oversikt',
              style: drawerHeadlineTextStyle,
              textAlign: TextAlign.center,
            )),
        Row(children: [
          SizedBox(
              width: 90,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Image(
                      image: AssetImage('images/sheep.png'),
                      height: 30,
                    ),
                    Image(
                      image: AssetImage('images/sheep.png'),
                      height: 35,
                    )
                  ])),
          const SizedBox(width: horizontalRowSpace),
          Text('$totalSheepAmount', style: tripOverviewNumberTextStyle),
          const SizedBox(width: horizontalRowSpace),
          const Text('Sauer & Lam', style: tripOverviewDescriptionTextStyle),
        ]),
        const SizedBox(height: verticalRowSpace),
        Row(children: [
          const SizedBox(
              width: 90,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Image(
                    image: AssetImage('images/sheep.png'),
                    height: 35,
                  ))),
          const SizedBox(width: horizontalRowSpace),
          Text('${totalSheepAmount - lambAmount}',
              style: tripOverviewNumberTextStyle),
          const SizedBox(width: horizontalRowSpace),
          const Text('Sauer', style: tripOverviewDescriptionTextStyle),
        ]),
        const SizedBox(height: verticalRowSpace + 5),
        Row(children: [
          SizedBox(
              width: 90,
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
          Text('$lambAmount', style: tripOverviewNumberTextStyle),
          const SizedBox(width: horizontalRowSpace),
          const Text('Lam', style: tripOverviewDescriptionTextStyle),
        ]),
        const SizedBox(height: verticalTypeSpace + 5),
        ...registeredEartags.entries
            .map((MapEntry<String, Object> eartagMapEntry) => Row(
                  children: [
                    SizedBox(
                        width: 90,
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.local_offer,
                                size: 30,
                                color:
                                    colorStringToColor[eartagMapEntry.key]))),
                    const SizedBox(width: horizontalRowSpace),
                    Text('${eartagMapEntry.value}',
                        style: tripOverviewNumberTextStyle),
                    const SizedBox(width: horizontalRowSpace),
                    Text(
                        '${colorValueStringToColorStringGuiPlural[eartagMapEntry.key]}',
                        style: tripOverviewDescriptionTextStyle),
                    const SizedBox(height: verticalRowSpace + 30),
                  ],
                ))
            .toList(),
        const SizedBox(height: verticalTypeSpace),
        ...registeredTies.entries
            .map((MapEntry<String, Object> tieMapEntry) => Row(
                  children: [
                    SizedBox(
                        width: 90,
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(FontAwesome5.black_tie,
                                size: 30,
                                color: colorStringToColor[tieMapEntry.key]))),
                    const SizedBox(width: horizontalRowSpace),
                    Text('${tieMapEntry.value}',
                        style: tripOverviewNumberTextStyle),
                    const SizedBox(width: horizontalRowSpace),
                    Text(
                        '${colorValueStringToColorStringGuiPlural[tieMapEntry.key]}',
                        style: tripOverviewDescriptionTextStyle),
                    const SizedBox(height: verticalRowSpace + 30),
                  ],
                ))
            .toList(),
      ],
    );
  }
}
