import 'package:flutter/material.dart';

import '../screens/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        backgroundColor: Colors.black87
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Colors.black87
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: AuthScreen(),
    );
  }
}

