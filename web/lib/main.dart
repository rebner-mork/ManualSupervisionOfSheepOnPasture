import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:web/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'login/login_page.dart';

void main() async {
  await dotenv.load(fileName: "../.env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoginPage(),
      initialRoute: 'login',
      routes: {
        'login': (context) => const LoginPage(),
      },
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.green,
      )),
    );
  }
}
