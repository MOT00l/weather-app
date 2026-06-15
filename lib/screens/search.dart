import 'package:clima_weather/components/app_background.dart';
import 'package:clima_weather/components/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/details_widget.dart';
import '../components/error_message.dart';
import '../components/loading_widget.dart';
import '../components/refresh_loading.dart';
import '../models/weather_models.dart';
import '../services/networking.dart';
import '../utilities/constants.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  bool isDataLoaded = true;
  bool isReloadHappend = false;
  late String name;
  late String city;
  late var searchData;
  late var iconSearchData;
  WeatherModel weatherModel = WeatherModel(
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

  @override
  void initState() {
    super.initState();
  }

  void getSearchedData() async {
    Future<dynamic> searchLocationWeather() async {
      String urirequest() {
        Uri request = Uri(
          scheme: "https",
          host: "api.weatherapi.com",
          path: "/v1/current.json",
          queryParameters: {
            "key": "2b47384e2a8e40f59b4171832250303",
            "q": city,
            "api": "yes"
          },
        );
        return request.toString();
      }

      NetworkHelper networkHelper = NetworkHelper(
        urirequest(),
      );

      var weatherData = await networkHelper.getData();

      return weatherData;
    }

    searchData = await searchLocationWeather();
    weatherModel = WeatherModel(
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
    );
    setState(() {
      bolbColor();
    });
    reload();
  }

  void bolbColor() {
    if (weatherModel.temperatur.round() >= 30) {
      kBolbOne = Color(0x60FF9800);
      kBolbTwo = Color(0x60FF3D00);
    } else if (weatherModel.temperatur.round() >= 20) {
      kBolbOne = Color(0x60FFDF4B);
      kBolbTwo = Color(0x6036D100);
    } else if (weatherModel.temperatur.round() >= 10) {
      kBolbOne = Color(0x6000BCD4);
      kBolbTwo = Color(0x602196F3);
    } else if (weatherModel.temperatur.round() < 10) {
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
        body: AppBackground(
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(6.5),
                  child: SizedBox(
                    width: 360,
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
                                    ScaffoldMessenger.of(context).showSnackBar(
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
                isErrorOccurd
                    ? ErrorMessage(title: searchTitle, message: searchMessage)
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
                                  weatherModel.location!,
                                  style: GoogleFonts.monda(
                                    fontSize: 20,
                                    color: kMidLightColor,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 15),
                            Text(
                              "${weatherModel.temperatur!.round()}°",
                              style: GoogleFonts.daysOne(
                                fontSize: 80,
                                color: kIconColor,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              weatherModel.description!.toUpperCase(),
                              style: GoogleFonts.monda(
                                fontSize: 20,
                                color: kMidLightColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GlassContainer(
                    blurStrength: 15,
                    borderRadius: 30,
                    child: SizedBox(
                      height: 60,
                      width: 350,
                      child: Row(
                        children: [
                          Expanded(
                            child: isErrorOccurd
                                ? DetailsWidget(
                                    text: "0%",
                                    detailText: "FEELS LIKE",
                                    color: kHeadIconColor,
                                    colorDetail: kTextColor,
                                  )
                                : DetailsWidget(
                                    text: "${weatherModel.feelslike!.round()}°",
                                    detailText: "FEELS LIKE",
                                    color: kHeadIconColor,
                                    colorDetail: kTextColor,
                                  ),
                          ),
                          Expanded(
                            child: isErrorOccurd
                                ? DetailsWidget(
                                    text: "0%",
                                    detailText: "HUMIDITY",
                                    color: kHeadIconColor,
                                    colorDetail: kTextColor,
                                  )
                                : DetailsWidget(
                                    text: "${weatherModel.humidity!}%",
                                    detailText: "HUMIDITY",
                                    color: kHeadIconColor,
                                    colorDetail: kTextColor,
                                  ),
                          ),
                          Expanded(
                            child: isErrorOccurd
                                ? DetailsWidget(
                                    text: "0",
                                    detailText: "WIND",
                                    color: kHeadIconColor,
                                    colorDetail: kTextColor,
                                  )
                                : DetailsWidget(
                                    text: "${weatherModel.wind!.round()}",
                                    detailText: "WIND",
                                    color: kHeadIconColor,
                                    colorDetail: kTextColor,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
