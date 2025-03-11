import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  WeatherModel? weatherModel;
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
    searchCall();
  }

  void getSearchedData() async {
    setState(() {});
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
      lon: searchData["location"]["lat"],
    );

    setState(
      () {
        isDataLoaded = true;
        isErrorOccurd = false;
      },
    );
    reload();
    searchCall();
  }

  void reload() {
    if (isReloadHappend == true) {
      Navigator.pop(context);
      isReloadHappend = false;
    }
  }

  void searchSave(String data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("wLocation", data);
  }

  void searchCall() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    weatherModel?.location = preferences.getString("wLocation");
    print(weatherModel?.location);
  }

  @override
  Widget build(BuildContext context) {
    if (!isDataLoaded) {
      return const LoadingWidget();
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kOverlayColor,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(6.5),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 57.0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: kCardColor,
                            child: Icon(
                              Icons.arrow_back,
                              color: kHeadIconColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: kCardColor,
                        child: Center(
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 10.5),
                              border: InputBorder.none,
                              hintText: "Enter a city name",
                              hintStyle: GoogleFonts.monda(
                                fontSize: 17,
                                color: kHeadIconColor,
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.clear),
                                color: kHeadIconColor,
                                onPressed: () {
                                  searchController.clear();
                                },
                              ),
                              prefixIcon: IconButton(
                                icon: const Icon(Icons.search),
                                color: kHeadIconColor,
                                onPressed: () {
                                  if (searchController.text == "") {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
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
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
                                weatherModel?.location ??
                                    "Enter Your City Name",
                                style: GoogleFonts.monda(
                                  fontSize: 20,
                                  color: kMidLightColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Text(
                            "${weatherModel?.temperatur.round()}°",
                            style: GoogleFonts.daysOne(
                              fontSize: 80,
                              color: kIconColor,
                            ),
                          ),
                          Text(
                            weatherModel?.description!.toUpperCase() ??
                                "no data",
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
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: kCardColor,
                  child: SizedBox(
                    height: 90,
                    child: Row(
                      children: [
                        Expanded(
                          child: isErrorOccurd
                              ? DetailsWidget(
                                  text: "0%",
                                  detailText: "FEELS LIKE",
                                  color: kHeadIconColor,
                                  colorDetail: kDarkColor)
                              : DetailsWidget(
                                  text: "${weatherModel?.feelslike!.round()}°",
                                  detailText: "FEELS LIKE",
                                  color: kHeadIconColor,
                                  colorDetail: kDarkColor,
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: VerticalDivider(
                            thickness: 1,
                            color: kDarkColor,
                          ),
                        ),
                        Expanded(
                          child: isErrorOccurd
                              ? DetailsWidget(
                                  text: "0%",
                                  detailText: "FEELS LIKE",
                                  color: kHeadIconColor,
                                  colorDetail: kDarkColor)
                              : DetailsWidget(
                                  text: "${weatherModel?.humidity!}%",
                                  detailText: "HUMIDITY",
                                  color: kHeadIconColor,
                                  colorDetail: kDarkColor,
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: VerticalDivider(
                            thickness: 1,
                            color: kDarkColor,
                          ),
                        ),
                        Expanded(
                          child: isErrorOccurd
                              ? DetailsWidget(
                                  text: "0%",
                                  detailText: "FEELS LIKE",
                                  color: kHeadIconColor,
                                  colorDetail: kDarkColor)
                              : DetailsWidget(
                                  text: "${weatherModel?.wind!.round()}",
                                  detailText: "WIND",
                                  color: kHeadIconColor,
                                  colorDetail: kDarkColor,
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
      );
    }
  }
}
