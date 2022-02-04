import 'package:app/login/login_page.dart';
import 'package:app/register/register_sheep_orally.dart';
import 'package:app/register_user/register_user_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'map/map_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      initialRoute: RegisterSheepOrallyWidget.route, //TODO: LoginPage.route,
      routes: {
        LoginPage.route: (context) => const LoginPage(),
        RegisterUserPage.route: (context) => const RegisterUserPage(),
        Map.route: (context) => const Material(child: Map()),
        RegisterSheepOrallyWidget.route: (context) =>
            const RegisterSheepOrallyWidget(),
      },
    );
  }
}
