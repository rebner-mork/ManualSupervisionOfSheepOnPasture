import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web/main_tabs/main_tabs.dart';
import 'package:web/my_page/define_map/define_map_page.dart';
import 'firebase_options.dart';
import 'package:web/register/register_user_page.dart';
import 'package:web/firebase_options.dart';
import 'login/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
          MainTabs.route: (context) => const MainTabs(),
          DefineMapPage.route: (context) => const DefineMapPage()
        },
        onUnknownRoute: (settings) => MaterialPageRoute(
            builder: (context) =>
                const Material(child: Text('Unknown route'))));
  }
}
