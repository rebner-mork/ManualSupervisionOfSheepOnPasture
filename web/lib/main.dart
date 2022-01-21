import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:web/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'login/log_in_view.dart';
import 'login/create_user_widget.dart';

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
    //TODO Remove path on this branch
    return MaterialApp(
      home: const LogInView(),
      initialRoute: 'login',
      routes: {
        'login': (context) => const LogInView(),
        'create_user': (context) => const CreateUserView(),
      },
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.green,
      )),
    );
  }
}
