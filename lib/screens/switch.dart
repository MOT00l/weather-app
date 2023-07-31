import 'package:clima_weather/screens/home.dart';
import 'package:clima_weather/screens/search.dart';
import 'package:flutter/material.dart';

class SwitchPage extends StatefulWidget {
  const SwitchPage({super.key});

  @override
  State<SwitchPage> createState() => _SwitchPageState();
}

class _SwitchPageState extends State<SwitchPage> {
  int index = 0;

  final pages = [
    const Home(),
    const SearchPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return pages[index];
  }
}
