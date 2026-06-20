import 'package:clima_weather/models/forecast_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/app_background.dart';
import '../components/glass_container.dart';
import '../components/refresh_loading.dart';
import '../components/temperature_graph.dart';
import '../models/forecast_card.dart';
import '../services/networking.dart';
import '../utilities/constants.dart';
import '../utilities/search_icons.dart';

class ForeCastPage extends StatefulWidget {
  const ForeCastPage({super.key});

  @override
  State<ForeCastPage> createState() => _ForeCastPageState();
}

class _ForeCastPageState extends State<ForeCastPage> {
  final TextEditingController searchController = TextEditingController();

  bool isReloadHappend = false;

  late String city;
  late var forecastData;

  ForecastModel forecastModel = ForecastModel(
    date1: "Loading...",
    date2: "Loading...",
    date3: "Loading...",
    icon1: "assets/weather-icons/wi-time-1.svg",
    icon2: "assets/weather-icons/wi-time-1.svg",
    icon3: "assets/weather-icons/wi-time-1.svg",
    maxwind1: 0,
    maxwind2: 0,
    maxwind3: 0,
    tempmax1: 0,
    tempmax2: 0,
    tempmax3: 0,
    tempmin1: 0,
    tempmin2: 0,
    tempmin3: 0,
  );
  final snackBar = SnackBar(
    content: Text(
      "No City Name Was Given",
      style: TextStyle(color: kTextColor),
    ),
    duration: Duration(seconds: 3),
    backgroundColor: kIconColor,
  );

  @override
  void initState() {
    super.initState();
  }

  void getForecastData() async {
    Future<dynamic> searchForecastWeather() async {
      String urirequest() {
        Uri request = Uri(
          scheme: "https",
          host: "api.weatherapi.com",
          path: "/v1/forecast.json",
          queryParameters: {
            "key": "2b47384e2a8e40f59b4171832250303",
            "q": city,
            "days": "3",
            "api": "yes",
            "alerts": "no",
          },
        );
        print(request);
        return request.toString();
      }

      NetworkHelper networkHelper = NetworkHelper(
        urirequest(),
      );

      var weatherData = await networkHelper.getData();

      return weatherData;
    }

    forecastData = await searchForecastWeather();
    final code1 =
        forecastData["forecast"]["forecastday"][0]["day"]["condition"]["code"];
    final code2 =
        forecastData["forecast"]["forecastday"][1]["day"]["condition"]["code"];
    final code3 =
        forecastData["forecast"]["forecastday"][2]["day"]["condition"]["code"];
    final iconPath1 =
        "assets/weather-icons/${getWeatherApiPrefix(code1)}${kWeatherApiIcons[code1.toString()]!["icon"]}.svg";
    final iconPath2 =
        "assets/weather-icons/${getWeatherApiPrefix(code2)}${kWeatherApiIcons[code2.toString()]!["icon"]}.svg";
    final iconPath3 =
        "assets/weather-icons/${getWeatherApiPrefix(code3)}${kWeatherApiIcons[code3.toString()]!["icon"]}.svg";

    forecastModel = ForecastModel(
      date1: forecastData["forecast"]["forecastday"][0]["date"],
      date2: forecastData["forecast"]["forecastday"][1]["date"],
      date3: forecastData["forecast"]["forecastday"][2]["date"],
      tempmin1: forecastData["forecast"]["forecastday"][0]["day"]["mintemp_c"],
      tempmin2: forecastData["forecast"]["forecastday"][1]["day"]["mintemp_c"],
      tempmin3: forecastData["forecast"]["forecastday"][2]["day"]["mintemp_c"],
      tempmax1: forecastData["forecast"]["forecastday"][0]["day"]["maxtemp_c"],
      tempmax2: forecastData["forecast"]["forecastday"][1]["day"]["maxtemp_c"],
      tempmax3: forecastData["forecast"]["forecastday"][2]["day"]["maxtemp_c"],
      maxwind1: forecastData["forecast"]["forecastday"][0]["day"]
          ["maxwind_kph"],
      maxwind2: forecastData["forecast"]["forecastday"][1]["day"]
          ["maxwind_kph"],
      maxwind3: forecastData["forecast"]["forecastday"][2]["day"]
          ["maxwind_kph"],
      icon1: iconPath1,
      icon2: iconPath2,
      icon3: iconPath3,
    );

    reload();
  }

  void reload() {
    if (isReloadHappend == true) {
      Navigator.pop(context);
      isReloadHappend = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kOverlayColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: AppBackground(
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      width: 360,

                      // Top Row
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Hero(
                              tag: "menuButton",
                              child: GlassContainer(
                                blurStrength: 15,
                                borderRadius: 30,
                                child: Icon(
                                  Icons.arrow_back,
                                  color: kHeadIconColor,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Hero(
                              tag: "searchBar",
                              child: GlassContainer(
                                blurStrength: 15,
                                borderRadius: 30,
                                child: SizedBox(
                                  height: 25,
                                  child: TextField(
                                    controller: searchController,
                                    onSubmitted: (value) {
                                      if (searchController.text == "") {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Colors.transparent,
                                            elevation: 0,
                                            content: Container(
                                              height: 60,
                                              decoration: BoxDecoration(
                                                color: kGlassColor,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.15),
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  const SizedBox(width: 12),
                                                  Icon(
                                                    Icons.close,
                                                    color: kHeadIconColor,
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Text(
                                                      "The Field Is Empty!",
                                                      style: TextStyle(
                                                        color: kHeadIconColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        isReloadHappend = true;
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            context = context;
                                            return const RefreshLoading();
                                          },
                                        );
                                        city = searchController.text;
                                        getForecastData();
                                      }
                                    },
                                    style: TextStyle(
                                      color: kHeadIconColor,
                                    ),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.calendar_today),
                                      prefixIconColor: kHeadIconColor,
                                      contentPadding:
                                          EdgeInsets.fromLTRB(20, 0, 0, 10),
                                      border: InputBorder.none,
                                      hintText: "Search forecast city",
                                      hintStyle: GoogleFonts.monda(
                                        fontSize: 15,
                                        color: kHeadIconColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Middle Widget
                    Expanded(
                      child: Center(
                        child: GlassContainer(
                          blurStrength: 15,
                          borderRadius: 30,
                          child: SizedBox(
                            width: 360,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 40,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 250),
                                      child: CustomPaint(
                                        painter: TemperatureGraphPainter(
                                          maxTemps: [
                                            forecastModel.tempmax1 ?? 0,
                                            forecastModel.tempmax2 ?? 0,
                                            forecastModel.tempmax3 ?? 0,
                                          ],
                                          minTemps: [
                                            forecastModel.tempmin1 ?? 0,
                                            forecastModel.tempmin2 ?? 0,
                                            forecastModel.tempmin3 ?? 0,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ForecastDayCard(
                                        date:
                                            forecastModel.date1 ?? "Loading...",
                                        icon: forecastModel.icon1 ??
                                            "assets/weather-icons/wi-time-1.svg",
                                        maxTemp:
                                            "${forecastModel.tempmax1?.round() ?? 0}°",
                                        minTemp:
                                            "${forecastModel.tempmin1?.round() ?? 0}°",
                                        maxWind:
                                            "${forecastModel.maxwind1?.round() ?? 0}",
                                      ),
                                    ),
                                    Expanded(
                                      child: ForecastDayCard(
                                        date:
                                            forecastModel.date2 ?? "Loading...",
                                        icon: forecastModel.icon2 ??
                                            "assets/weather-icons/wi-time-1.svg",
                                        maxTemp:
                                            "${forecastModel.tempmax2?.round() ?? 0}°",
                                        minTemp:
                                            "${forecastModel.tempmin2?.round() ?? 0}°",
                                        maxWind:
                                            "${forecastModel.maxwind2?.round() ?? 0}",
                                      ),
                                    ),
                                    Expanded(
                                      child: ForecastDayCard(
                                        date:
                                            forecastModel.date3 ?? "Loading...",
                                        icon: forecastModel.icon3 ??
                                            "assets/weather-icons/wi-time-1.svg",
                                        maxTemp:
                                            "${forecastModel.tempmax3?.round() ?? 0}°",
                                        minTemp:
                                            "${forecastModel.tempmin3?.round() ?? 0}°",
                                        maxWind:
                                            "${forecastModel.maxwind3?.round() ?? 0}",
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
