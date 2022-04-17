import 'package:app/login/login_page.dart';
import 'package:app/providers/settings_provider.dart';
import 'package:app/sign_up/sign_up_page.dart';
import 'package:app/trip/start_trip_page.dart';
import 'package:app/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setConstants();
  await Firebase.initializeApp();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => SettingsProvider())
  ], child: const MyApp()));
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)),
      initialRoute: LoginPage.route,
      routes: {
        LoginPage.route: (context) => LoginPage(context),
        SignUpPage.route: (context) => const SignUpPage(),
        StartTripPage.route: (context) => const StartTripPage(),
      },
    );
  }
}
