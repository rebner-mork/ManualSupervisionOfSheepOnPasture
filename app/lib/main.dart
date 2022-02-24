import 'package:app/login/login_page.dart';
import 'package:app/register/register_sheep_orally.dart';
import 'package:app/register/register_sheep.dart';
import 'package:app/register_user/register_user_page.dart';
import 'package:app/trip/start_trip_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'map/map_widget.dart';
import 'package:latlong2/latlong.dart';

import "utils/map_utils.dart";
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //TODO Temporary
  await downloadTiles(
      LatLng(63.420017, 10.394660),
      LatLng(63.415472, 10.411244),
      OfflineZoomLevels.min,
      OfflineZoomLevels.max);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  _MyAppState();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)),
      initialRoute: LoginPage.route,
      routes: {
        LoginPage.route: (context) => const LoginPage(),
        RegisterUserPage.route: (context) => const RegisterUserPage(),
        StartTripPage.route: (context) => const StartTripPage(),
        Map.route: (context) =>
            Map(LatLng(63.420017, 10.394660), LatLng(63.415472, 10.411244)),
        RegisterSheep.route: (context) => const RegisterSheep('fileName'),
        RegisterSheepOrally.route: (context) =>
            const RegisterSheepOrally('filename'),
      },
    );
  }
}
