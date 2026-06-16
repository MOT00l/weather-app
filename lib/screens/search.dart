import 'dart:ui';

import 'package:clima_weather/components/app_background.dart';
import 'package:clima_weather/components/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/details_widget.dart';
import '../components/error_message.dart';
import '../components/loading_widget.dart';
import '../components/refresh_loading.dart';
import '../models/drang_handle.dart';
import '../models/search_models.dart';
import '../services/networking.dart';
import '../utilities/constants.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  bool isDataLoaded = true;
  bool isReloadHappend = false;
  late String name;
  late String city;
  late var searchData;
  late var iconSearchData;
  SearchModel searchModel = SearchModel(
    temperatur: 0,
    feelslike: 0,
    humidity: 0,
    wind: 0,
    location: "Loading...",
    description: "Loading...",
    icon: "assets/weather-icons/wi-time-1.svg",
  );
  int code = 0;
  bool isErrorOccurd = true;
  String? title, message;
  SearchError? searchError;
  String searchTitle = SearchError().searchTitle;
  String searchMessage = SearchError().searchMessage;
  final snackBar = SnackBar(
    content: Text(
      "No City Name Was Given",
      style: TextStyle(color: kTextColor),
    ),
    duration: Duration(seconds: 3),
    backgroundColor: kIconColor,
  );

  late AnimationController detailsController;

  @override
  void initState() {
    super.initState();

    detailsController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    );
  }

  @override
  void dispose() {
    detailsController.dispose();
    super.dispose();
  }

  void getSearchedData() async {
    Future<dynamic> searchLocationWeather() async {
      String urirequest() {
        Uri request = Uri(
          scheme: "https",
          host: "api.weatherapi.com",
          path: "/v1/forecast.json",
          queryParameters: {
            "key": "2b47384e2a8e40f59b4171832250303",
            "q": city,
            "api": "yes"
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

    searchData = await searchLocationWeather();
    searchModel = SearchModel(
      temperatur: searchData["current"]["temp_c"],
      location: searchData["location"]["name"] +
          ", " +
          searchData["location"]["country"],
      description: searchData["current"]["condition"]["text"],
      feelslike: searchData["current"]["feelslike_c"],
      humidity: searchData["current"]["humidity"],
      wind: searchData["current"]["wind_kph"],
      lat: searchData["location"]["lat"],
      lon: searchData["location"]["lon"],
      tempmin: searchData["forecast"]["forecastday"][0]["day"]["mintemp_c"],
      tempmax: searchData["forecast"]["forecastday"][0]["day"]["maxtemp_c"],
      pressure: searchData["current"]["pressure_mb"],
      chanceofrain: searchData["current"]["chance_of_rain"],
      uv: searchData["current"]["uv"],
      winddir: searchData["current"]["wind_dir"],
    );
    setState(() {
      bolbColor();
    });
    reload();
  }

  void bolbColor() {
    if (searchModel.temperatur.round() >= 30) {
      kBolbOne = Color(0x60FF9800);
      kBolbTwo = Color(0x60FF3D00);
    } else if (searchModel.temperatur.round() >= 20) {
      kBolbOne = Color(0x60FFDF4B);
      kBolbTwo = Color(0x6036D100);
    } else if (searchModel.temperatur.round() >= 10) {
      kBolbOne = Color(0x6000BCD4);
      kBolbTwo = Color(0x602196F3);
    } else if (searchModel.temperatur.round() < 10) {
      kBolbOne = Color(0x602196F3);
      kBolbTwo = Color(0x603F51B5);
    } else {
      kBolbOne = Color(0x403B82F6);
      kBolbTwo = Color(0x408B5CF6);
    }
    isDataLoaded = true;
    isErrorOccurd = false;
  }

  void reload() {
    if (isReloadHappend == true) {
      Navigator.pop(context);
      isReloadHappend = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isDataLoaded) {
      return const LoadingWidget();
    } else {
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
                      Padding(
                        padding: const EdgeInsets.all(6.5),
                        child: SizedBox(
                          width: 360,

                          // Top Row
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: GlassContainer(
                                  blurStrength: 15,
                                  borderRadius: 30,
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: kHeadIconColor,
                                  ),
                                ),
                              ),
                              Expanded(
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
                                          getSearchedData();
                                        }
                                      },
                                      style: TextStyle(
                                        color: kHeadIconColor,
                                      ),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.search),
                                        prefixIconColor: kHeadIconColor,
                                        contentPadding:
                                            EdgeInsets.fromLTRB(20, 0, 0, 10),
                                        border: InputBorder.none,
                                        hintText: "Enter a city name",
                                        hintStyle: GoogleFonts.monda(
                                          fontSize: 17,
                                          color: kHeadIconColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Middle Widget
                      isErrorOccurd
                          ? ErrorMessage(
                              title: searchTitle,
                              message: searchMessage,
                            )
                          : Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.location_city,
                                        color: kMidLightColor,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        searchModel.location!,
                                        style: GoogleFonts.monda(
                                          fontSize: 20,
                                          color: kMidLightColor,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    "${searchModel.temperatur!.round()}°",
                                    style: GoogleFonts.daysOne(
                                      fontSize: 80,
                                      color: kIconColor,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    searchModel.description!.toUpperCase(),
                                    style: GoogleFonts.monda(
                                      fontSize: 20,
                                      color: kMidLightColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      SizedBox(
                        height: 100,
                        width: 450,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Weather Bottom Sheet
            Padding(
              padding: EdgeInsets.only(bottom: 25),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: WeatherBottomSheet(
                  controller: detailsController,
                  searchModel: searchModel,
                  isErrorOccurd: isErrorOccurd,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

class WeatherBottomSheet extends StatelessWidget {
  final AnimationController controller;
  final SearchModel searchModel;
  final bool isErrorOccurd;
  const WeatherBottomSheet({
    super.key,
    required this.controller,
    required this.searchModel,
    required this.isErrorOccurd,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final t = controller.value;

        return GestureDetector(
          onTap: () {
            if (controller.value == 0) {
              controller.forward();
            } else {
              controller.reverse();
            }
          },
          onVerticalDragUpdate: (details) {
            controller.value =
                (controller.value - details.delta.dy / 400).clamp(0.0, 1.0);
          },
          onVerticalDragEnd: (details) {
            final velocity = details.primaryVelocity ?? 0;

            if (velocity < -500) {
              controller.forward();
            } else if (velocity > 500) {
              controller.reverse();
            } else {
              if (controller.value > 0.5) {
                controller.forward();
              } else {
                controller.reverse();
              }
            }
          },
          child: GlassContainer(
            borderRadius: lerpDouble(
              30,
              30,
              t,
            )!,
            child: SizedBox(
              width: lerpDouble(
                350,
                MediaQuery.of(context).size.width - 24,
                t,
              ),
              height: lerpDouble(
                80,
                350,
                t,
              ),
              child: Stack(
                children: [
                  Transform.translate(
                    offset: Offset(
                      0,
                      -20 * t,
                    ),
                    child: Opacity(
                      opacity: 1 - t,
                      child: CompactContent(
                        searchModel: searchModel,
                        isErrorOccurd: isErrorOccurd,
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(
                      0,
                      20 * (1 - t),
                    ),
                    child: Opacity(
                      opacity: t,
                      child: ExpandedContent(
                        searchModel: searchModel,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CompactContent extends StatelessWidget {
  final SearchModel searchModel;
  final bool isErrorOccurd;

  const CompactContent({
    super.key,
    required this.searchModel,
    required this.isErrorOccurd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DragHandle(),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Expanded(
              child: DetailsWidget(
                text: "${searchModel.feelslike?.round() ?? 0}°",
                detailText: "FEELS LIKE",
                color: kHeadIconColor,
                colorDetail: kTextColor,
              ),
            ),
            Expanded(
              child: DetailsWidget(
                text: "${searchModel.humidity ?? 0}%",
                detailText: "HUMIDITY",
                color: kHeadIconColor,
                colorDetail: kTextColor,
              ),
            ),
            Expanded(
              child: DetailsWidget(
                text: "${searchModel.wind?.round() ?? 0}",
                detailText: "WIND",
                color: kHeadIconColor,
                colorDetail: kTextColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ExpandedContent extends StatelessWidget {
  final SearchModel searchModel;

  const ExpandedContent({
    super.key,
    required this.searchModel,
  });

  String getWindDirection() {
    switch (searchModel.winddir?.toUpperCase() ?? "Loading") {
      case "N":
        return "North";
      case "NNE":
        return "North NE";
      case "NE":
        return "Northeast";
      case "ENE":
        return "East NE";

      case "E":
        return "East";
      case "ESE":
        return "East SE";
      case "SE":
        return "Southeast";
      case "SSE":
        return "South SE";

      case "S":
        return "South";
      case "SSW":
        return "South SW";
      case "SW":
        return "Southwest";
      case "WSW":
        return "West SW";

      case "W":
        return "West";
      case "WNW":
        return "West NW";
      case "NW":
        return "Northwest";
      case "NNW":
        return "North NW";

      default:
        return searchModel.winddir ?? "Loading";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const DragHandle(),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: DetailsWidget(
                  text: "${searchModel.feelslike?.round() ?? 0}°",
                  detailText: "FEELS LIKE",
                  color: kHeadIconColor,
                  colorDetail: kTextColor,
                ),
              ),
              Expanded(
                child: DetailsWidget(
                  text: "${searchModel.humidity ?? 0}%",
                  detailText: "HUMIDITY",
                  color: kHeadIconColor,
                  colorDetail: kTextColor,
                ),
              ),
              Expanded(
                child: DetailsWidget(
                  text: "${searchModel.wind?.round() ?? 0}",
                  detailText: "WIND",
                  color: kHeadIconColor,
                  colorDetail: kTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: DetailsWidget(
                  text: "${searchModel.tempmax?.round() ?? 0}°",
                  detailText: "MAX \n TEMPERATURE",
                  color: kHeadIconColor,
                  colorDetail: kTextColor,
                ),
              ),
              Expanded(
                child: DetailsWidget(
                  text: "${searchModel.tempmin?.round() ?? 0}°",
                  detailText: "MIN \n TEMPERATURE",
                  color: kHeadIconColor,
                  colorDetail: kTextColor,
                ),
              ),
              Expanded(
                child: DetailsWidget(
                  text: "${searchModel.pressure?.round() ?? 0}",
                  detailText: "\n PRESSURE",
                  color: kHeadIconColor,
                  colorDetail: kTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: DetailsWidget(
                  text: "${searchModel.uv?.round() ?? 0}",
                  detailText: "\n UV",
                  color: kHeadIconColor,
                  colorDetail: kTextColor,
                ),
              ),
              Expanded(
                child: DetailsWidget(
                  text: getWindDirection(),
                  detailText: "WIND DIRECTION",
                  color: kHeadIconColor,
                  colorDetail: kTextColor,
                ),
              ),
              Expanded(
                child: DetailsWidget(
                  text: "${searchModel.chanceofrain?.round() ?? 0}%",
                  detailText: "CHANCE OF \n RAIN",
                  color: kHeadIconColor,
                  colorDetail: kTextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
