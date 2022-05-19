import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web/login_or_sign_up/login_or_sign_up_page.dart';
import 'package:web/main_tabs/main_tabs.dart';
import 'firebase_options.dart';
import 'package:web/firebase_options.dart';

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
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)),
        initialRoute: LoginOrSignUpPage.route,
        routes: {
          LoginOrSignUpPage.route: (context) => const LoginOrSignUpPage(),
          MainTabs.route: (context) => const MainTabs()
        },
        onUnknownRoute: (settings) => MaterialPageRoute(
            builder: (context) =>
                const Material(child: Text('Unknown route'))));
  }
}
