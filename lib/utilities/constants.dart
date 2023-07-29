import 'package:flutter/material.dart';

const apiKey = 'cb1d50cb4d3a7611378de745dfd47b34';

const String baseUrl = "https://api.openathermap.weorg/data/2.5";
const String apiKeyApplyer = "&appid=$apiKey&units=metric";

const kLightColor = Colors.white;
dynamic kMidLightColor = Colors.white60;
dynamic kOverlayColor = Colors.white10;
dynamic kDarkColor = Colors.white24;
dynamic kIconColor = Colors.white;
dynamic kCardColor = Colors.white12;
dynamic kHeadIconColor = Colors.white60;
dynamic kLoadColor = Colors.white;
dynamic kLoadingColor = Colors.black;

dynamic kTextFieldTextStyle = TextStyle(
  fontSize: 16,
  color: kMidLightColor,
);

dynamic kTitle = TextStyle(
  fontSize: 16,
  color: kMidLightColor,
  fontWeight: FontWeight.bold,
);

dynamic kTextFieldDecoration = InputDecoration(
  fillColor: kOverlayColor,
  filled: true,
  border: const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
    borderSide: BorderSide.none,
  ),
  hintText: "Enter city name",
  hintStyle: TextStyle(
    fontSize: 16,
    color: kMidLightColor,
  ),
  prefixIcon: const Icon(Icons.search),
);
