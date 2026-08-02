import 'dart:async';
import 'dart:convert';

import 'package:clima_weather/models/forecast_model.dart';
import 'package:clima_weather/services/forecast_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final LayerLink _searchBarLink = LayerLink();

  bool isReloadHappend = false;
  late Timer ForecastLastUpdatedTimer;

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
    location: "Loading...",
  );

  String forecastLastUpdated = "Updating...";
  String formatForecastLastUpdated(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inMinutes < 1) {
      return "Just updated";
    }

    if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return "Last updated $minutes minute${minutes == 1 ? '' : 's'} ago";
    }

    if (difference.inHours < 12) {
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;

      if (minutes == 0) {
        return "Last updated $hours hour${hours == 1 ? '' : 's'} ago";
      }

      return "Last updated $hours hour${hours == 1 ? '' : 's'} "
          "and $minutes minute${minutes == 1 ? '' : 's'} ago";
    }

    if (difference.inHours < 24) {
      return "Last updated ${difference.inHours} hours ago";
    }

    return "Last updated more than a day ago";
  }

  Future<void> loadForecastLastUpdated() async {
    final prefs = await SharedPreferences.getInstance();

    final savedTime = prefs.getString("forecast_lastUpdated");

    if (savedTime == null) return;

    final dateTime = DateTime.parse(savedTime);

    setState(() {
      forecastLastUpdated = formatForecastLastUpdated(dateTime);
    });
  }

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

    loadForecastLastUpdated();

    ForecastLastUpdatedTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) {
        loadForecastLastUpdated();
      },
    );

    initializeForecast();
    loadForecastLastUpdated();
    loadCities();
    loadLastCity();
  }

  Future<void> loadCities() async {
    final String data = await rootBundle.loadString('assets/cities.json');

    cities = List<String>.from(
      jsonDecode(data),
    );
  }

  void updateSuggestions(String query) {
    if (query.isEmpty) {
      setState(() {
        suggestions = [];
      });
      return;
    }

    setState(() {
      suggestions = cities
          .where(
            (city) => city.toLowerCase().contains(query.toLowerCase()),
          )
          .take(8)
          .toList();
    });
  }

  // ======================================
  // LOCATION SUGGEST
  // ======================================
  List<String> cities = [];
  List<String> suggestions = [];

  // ======================================
  // SEARCH DATA
  // ======================================
  Future<void> initializeForecast() async {
    await loadCachedForecast();
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

    setState(() {
      forecastModel = ForecastModel(
        date1: forecastData["forecast"]["forecastday"][0]["date"],
        date2: forecastData["forecast"]["forecastday"][1]["date"],
        date3: forecastData["forecast"]["forecastday"][2]["date"],
        tempmin1: forecastData["forecast"]["forecastday"][0]["day"]
            ["mintemp_c"],
        tempmin2: forecastData["forecast"]["forecastday"][1]["day"]
            ["mintemp_c"],
        tempmin3: forecastData["forecast"]["forecastday"][2]["day"]
            ["mintemp_c"],
        tempmax1: forecastData["forecast"]["forecastday"][0]["day"]
            ["maxtemp_c"],
        tempmax2: forecastData["forecast"]["forecastday"][1]["day"]
            ["maxtemp_c"],
        tempmax3: forecastData["forecast"]["forecastday"][2]["day"]
            ["maxtemp_c"],
        maxwind1: forecastData["forecast"]["forecastday"][0]["day"]
            ["maxwind_kph"],
        maxwind2: forecastData["forecast"]["forecastday"][1]["day"]
            ["maxwind_kph"],
        maxwind3: forecastData["forecast"]["forecastday"][2]["day"]
            ["maxwind_kph"],
        icon1: iconPath1,
        icon2: iconPath2,
        icon3: iconPath3,
        location: forecastData["location"]["name"] +
            ", " +
            forecastData["location"]["country"],
      );
    });

    await ForecastCache.saveWeather(
      forecast_date1: forecastModel.date1,
      forecast_date2: forecastModel.date2,
      forecast_date3: forecastModel.date3,
      forecast_icon1: forecastModel.icon1!,
      forecast_icon2: forecastModel.icon2!,
      forecast_icon3: forecastModel.icon3!,
      forecast_maxwind1: forecastModel.maxwind1!,
      forecast_maxwind2: forecastModel.maxwind2!,
      forecast_maxwind3: forecastModel.maxwind3!,
      forecast_tempmax1: forecastModel.tempmax1!,
      forecast_tempmax2: forecastModel.tempmax2!,
      forecast_tempmax3: forecastModel.tempmax3!,
      forecast_tempmin1: forecastModel.tempmin1!,
      forecast_tempmin2: forecastModel.tempmin2!,
      forecast_tempmin3: forecastModel.tempmin3!,
      forecast_location: forecastModel.location!,
    );

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      "forecast_lastUpdated",
      DateTime.now().toIso8601String(),
    );

    final now = DateTime.now();
    setState(() {
      forecastLastUpdated = formatForecastLastUpdated(now);
    });

    reload();
  }

  void reload() {
    if (isReloadHappend == true) {
      Navigator.pop(context);
      isReloadHappend = false;
    }
  }

  Future<bool> loadCachedForecast() async {
    final cache = await ForecastCache.loadWeather();

    if (cache == null) {
      return false;
    }
    forecastModel = ForecastModel(
      icon1: cache["forecast_icon1"],
      icon2: cache["forecast_icon2"],
      icon3: cache["forecast_icon3"],
      maxwind1: cache["forecast_maxwind1"],
      maxwind2: cache["forecast_maxwind2"],
      maxwind3: cache["forecast_maxwind3"],
      tempmax1: cache["forecast_tempmax1"],
      tempmax2: cache["forecast_tempmax2"],
      tempmax3: cache["forecast_tempmax3"],
      tempmin1: cache["forecast_tempmin1"],
      tempmin2: cache["forecast_tempmin2"],
      tempmin3: cache["forecast_tempmin3"],
      date1: cache["forecast_date1"],
      date2: cache["forecast_date2"],
      date3: cache["forecast_date3"],
      location: cache["forecast_location"],
    );
    return true;
  }

  Future<void> loadLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCity = prefs.getString("forecast_last_city");

    if (savedCity != null && savedCity.isNotEmpty) {
      searchController.text = savedCity;
      city = savedCity;
    }
  }

  @override
  void dispose() {
    ForecastLastUpdatedTimer.cancel();
    searchController.dispose();
    super.dispose();
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
                            child: CompositedTransformTarget(
                              link: _searchBarLink,
                              child: Hero(
                                tag: "searchBar",
                                child: GlassContainer(
                                  blurStrength: 15,
                                  borderRadius: 30,
                                  child: SizedBox(
                                    height: 25,
                                    child: TextField(
                                      controller: searchController,
                                      onChanged: updateSuggestions,
                                      onSubmitted: (value) async {
                                        if (searchController.text == "") {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor:
                                                  Colors.transparent,
                                              elevation: 0,
                                              content: Container(
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  color: kGlassColor,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                    color: Colors.white
                                                        .withValues(
                                                            alpha: 0.15),
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
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          await prefs.setString(
                                              "forecast_last_city", city);
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
                          ),
                        ],
                      ),
                    ),

                    // Middle Widget
                    Expanded(
                      child: GlassContainer(
                        blurStrength: 15,
                        borderRadius: 30,
                        child: Column(
                          children: [
                            const SizedBox(height: 50),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_city,
                                  color: kMidLightColor,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  forecastModel.location ?? "Loading...",
                                  style: GoogleFonts.monda(
                                    fontSize: 20,
                                    color: kMidLightColor,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 100, 0, 80),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 80),
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
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ForecastDayCard(
                                          date: forecastModel.date1 ??
                                              "Loading...",
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
                                          date: forecastModel.date2 ??
                                              "Loading...",
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
                                          date: forecastModel.date3 ??
                                              "Loading...",
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
                            Text(
                              forecastLastUpdated,
                              style: GoogleFonts.monda(
                                fontSize: 14,
                                color: kTextColor.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          //SUGGESTION PANEL
          if (suggestions.isNotEmpty)
            Positioned(
              width: 280,
              child: CompositedTransformFollower(
                link: _searchBarLink,
                showWhenUnlinked: false,
                offset: const Offset(0, 60),
                child: Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: GlassContainer(
                      blurStrength: 15,
                      borderRadius: 20,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 250,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: suggestions.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: const Icon(Icons.location_on),
                              title: Text(
                                suggestions[index],
                                style: TextStyle(
                                  color: kHeadIconColor,
                                ),
                              ),
                              onTap: () {
                                city = suggestions[index];

                                searchController.text = city;

                                setState(() {
                                  suggestions.clear();
                                });

                                FocusScope.of(context).unfocus();

                                isReloadHappend = true;

                                showDialog(
                                  context: context,
                                  builder: (_) => const RefreshLoading(),
                                );

                                getForecastData();
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
