import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:clima_weather/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clima Weather App',
      home: Home(),
    );
  }
}

