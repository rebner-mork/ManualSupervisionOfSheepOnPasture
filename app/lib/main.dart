import 'package:app/login/login_page.dart';
import 'package:app/map/map_widget.dart';
import 'package:app/register_user/register_user_page.dart';
import 'package:app/trip/start_trip_page.dart';
import 'package:app/utils/map_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // TODO: remove
  await downloadTiles(
      LatLng(63.420366, 10.396880), LatLng(63.415151, 10.410580), 15, 18);

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
      initialRoute: MapWidget.route, // TODO: LoginPage.route,
      routes: {
        LoginPage.route: (context) => const LoginPage(),
        RegisterUserPage.route: (context) => const RegisterUserPage(),
        StartTripPage.route: (context) => const StartTripPage(),
        MapWidget.route: (context) => MapWidget(
            LatLng(63.420366, 10.396880), LatLng(63.415151, 10.410580))
      },
    );
  }
}
