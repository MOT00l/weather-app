import 'package:flutter/material.dart';

const apiKey = '76a735efdbbce487f88fe731ef4570a8';

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
dynamic kTextColor = Colors.white;
dynamic kGlassColor = Colors.white;
dynamic kGlassBorder = Colors.white;
dynamic kGradientOne = Color(0xFFFDFDFD);
dynamic kGradientTwo = Color(0xFFF5F5F7);
dynamic kGradientThree = Color(0xFFEDEEF1);
dynamic kBolbOne = Color(0x403B82F6);
dynamic kBolbTwo = Color(0x408B5CF6);

Icon iconMode = Icon(
  Icons.nights_stay,
  color: kMidLightColor,
);
bool? themeBool;
bool? iconModeStatus;

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

class Resourses {
  static dynamic kMidLightColor = Colors.white60;
  static dynamic kOverlayColor = Colors.white10;
  static dynamic kDarkColor = Colors.white24;
  static dynamic kIconColor = Colors.white;
  static dynamic kCardColor = Colors.white12;
  static dynamic kHeadIconColor = Colors.white60;
  static dynamic kLoadColor = Colors.white;
  static dynamic kLoadingColor = Colors.black;
}

class SearchError {
  String searchTitle = "No Data Found";
  String searchMessage =
      "Please search a city name to begin seeing the condition of that location";
}
