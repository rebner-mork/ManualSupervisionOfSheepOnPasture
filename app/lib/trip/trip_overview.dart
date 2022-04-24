import 'package:app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';

const tripOverviewNumberTextStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
const tripOverviewDescriptionTextStyle = TextStyle(fontSize: 20);
double verticalRowSpace = 5;
double verticalTypeSpace = 20;

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
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(children: [
            const Icon(RpgAwesome.sheep, size: 30),
            SizedBox(height: verticalRowSpace),
            const Icon(RpgAwesome.sheep, size: 30),
            SizedBox(height: verticalRowSpace),
            const Icon(RpgAwesome.sheep, size: 24),
            SizedBox(height: verticalTypeSpace),
          ]),
          const SizedBox(width: 15),
          Column(
            children: [
              Text('$totalSheepAmount', style: tripOverviewNumberTextStyle),
              SizedBox(height: verticalRowSpace),
              Text('${totalSheepAmount - lambAmount}',
                  style: tripOverviewNumberTextStyle),
              SizedBox(height: verticalRowSpace),
              Text('$lambAmount', style: tripOverviewNumberTextStyle),
              SizedBox(height: verticalTypeSpace),
            ],
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Sauer totalt',
                  style: tripOverviewDescriptionTextStyle),
              SizedBox(height: verticalRowSpace),
              const Text('Sauer', style: tripOverviewDescriptionTextStyle),
              SizedBox(height: verticalRowSpace),
              const Text('Lam', style: tripOverviewDescriptionTextStyle),
              SizedBox(height: verticalTypeSpace),
            ],
          )
        ])
      ],
    );
  }
}
