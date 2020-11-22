import 'package:flutter/material.dart';

import 'generate_route.dart';

void main() {
  // TODO: Firebase initialize
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'VillageBoard',
      initialRoute: '/Splash',
      onGenerateRoute: GenerateRoute.generateRoute,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.lightBlue,
      ),
    );
  }
}