import 'package:app/utils/other.dart';
import 'package:app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';

const tripOverviewNumberTextStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
const tripOverviewDescriptionTextStyle = TextStyle(fontSize: 20);
const double verticalRowSpace = 5;
const double verticalTypeSpace = 20;
const double horizontalRowSpace = 15;

class TripOverview extends StatelessWidget {
  const TripOverview(
      {required this.totalSheepAmount, required this.lambAmount, Key? key})
      : super(key: key);

  final int totalSheepAmount;
  final int lambAmount;

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
                  children: const [
                    Image(
                      image: AssetImage('images/sheep.png'),
                      height: 30,
                    ),
                    Image(
                      image: AssetImage('images/sheep.png'),
                      height: 40,
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
                    height: 40,
                  ))),
          const SizedBox(width: horizontalRowSpace),
          Text('${totalSheepAmount - lambAmount}',
              style: tripOverviewNumberTextStyle),
          const SizedBox(width: horizontalRowSpace),
          const Text('Sauer', style: tripOverviewDescriptionTextStyle),
        ]),
        const SizedBox(height: 10 + verticalRowSpace),
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
                    SizedBox(width: 5)
                  ])),
          const SizedBox(width: horizontalRowSpace),
          Text('$lambAmount', style: tripOverviewNumberTextStyle),
          const SizedBox(width: horizontalRowSpace),
          const Text('Lam', style: tripOverviewDescriptionTextStyle),
        ]),
      ],
    );
  }
}
