import 'package:flutter/material.dart';
import 'login/log_in_view.dart';
import 'login/create_user_widget.dart';

void main() {
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
