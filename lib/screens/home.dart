import 'dart:ui';

import 'package:clima_weather/components/app_background.dart';
import 'package:clima_weather/components/error_message.dart';
import 'package:clima_weather/components/glass_container.dart';
import 'package:clima_weather/models/weather_models.dart';
import 'package:clima_weather/screens/info.dart';
import 'package:clima_weather/screens/search.dart';
import 'package:clima_weather/services/weather.dart';
import 'package:clima_weather/utilities/constants.dart';
import 'package:clima_weather/utilities/weather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/details_widget.dart';
import '../components/refresh_loading.dart';
import '../models/themes.dart';
import '../services/weather_cache.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isDataLoaded = false;
  bool isErrorOccurd = false;
  double? latitude;
  double? longitude;
  GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
  LocationPermission? permission;
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
  Weather weather = Weather();
  var weatherData;
  String? title, message;
  bool isReloadHappend = false;
  Icon iconMode = Icon(
    Icons.nights_stay,
    color: kMidLightColor,
  );
  bool? themeBool;
  bool? iconModeStatus;
  bool menuOpen = false;
  bool isDetailsExpanded = false;
  bool showDetailsCard = false;

  @override
  void initState() {
    super.initState();
    initializeWeather();
    userThemeCall();
  }

  Future<void> initializeWeather() async {
    await loadCachedWeather();

    getPremission();
  }

  ///# GetPremission
  ///
  /// this function will check if app has accses to gps and if the app doesn't
  /// it will grant the premission from user.
  void getPremission() async {
    permission = await geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await geolocatorPlatform.requestPermission();
      if (permission != LocationPermission.denied) {
        if (permission == LocationPermission.deniedForever) {
        } else {
          getLocation();
        }
      } else {
        getLocation();
      }
    } else {
      getLocation();
    }
  }

  ///# GetLocation
  ///
  /// this function will do two things:
  /// 1. it will check if app have accses to user current location.
  /// 2. it will get all the data that app need from [getLocationWeather] function.
  void getLocation() async {
    // if (!await geolocatorPlatform.isLocationServiceEnabled()) {
    //   setState(() {
    //     isErrorOccurd = true;
    //     isDataLoaded = true;
    //     title = "Location is turned off";
    //     message =
    //         "Please enable the location service to see weather condition for your location";
    //     return;
    //   });
    // }
    await geolocatorPlatform.isLocationServiceEnabled();

    try {
      weatherData = await weather.getLocationWeather();
    } catch (e) {
      await loadCachedWeather();
      bolbColor();
      return;
    }
    code = weatherData["weather"][0]["id"];
    weatherModel = WeatherModel(
      temperatur: weatherData["main"]["temp"],
      feelslike: weatherData["main"]["feels_like"],
      humidity: weatherData["main"]["humidity"],
      wind: weatherData["wind"]["speed"],
      icon:
          "assets/weather-icons/${getIconsPreFix(code)}${kWeatherIcons[code.toString()]!["icon"]}.svg",
      location: weatherData["name"] + ", " + weatherData["sys"]["country"],
      description: weatherData["weather"][0]["description"],
    );

    await WeatherCache.saveWeather(
      temp: weatherModel.temperatur,
      feelsLike: weatherModel.feelslike!,
      humidity: weatherModel.humidity!,
      wind: weatherModel.wind!,
      location: weatherModel.location!,
      description: weatherModel.description!,
      icon: weatherModel.icon!,
    );

    // await WidgetService.updateWidget(
    //   temp: weatherModel!.temperatur.round().toString(),
    //   description: weatherModel!.description!,
    //   location: weatherModel!.location!,
    // );

    setState(() {
      bolbColor();
    });
    reload();
  }

  void bolbColor() {
    if (weatherModel.temperatur!.round() >= 30) {
      kBolbOne = Color(0x60FF9800);
      kBolbTwo = Color(0x60FF3D00);
    } else if (weatherModel.temperatur!.round() >= 20) {
      kBolbOne = Color(0x60FFDF4B);
      kBolbTwo = Color(0x6036D100);
    } else if (weatherModel.temperatur!.round() >= 10) {
      kBolbOne = Color(0x6000BCD4);
      kBolbTwo = Color(0x602196F3);
    } else if (weatherModel.temperatur!.round() < 10) {
      kBolbOne = Color(0x602196F3);
      kBolbTwo = Color(0x603F51B5);
    } else {
      kBolbOne = Color(0x403B82F6);
      kBolbTwo = Color(0x408B5CF6);
    }
    isDataLoaded = true;
    isErrorOccurd = false;
  }

  /// LightMode
  ///
  /// With this function user can switch into lightmode.
  void lightSwitch() {
    kOverlayColor = ThemeClass().lightBackgroundColor;
    kIconColor = ThemeClass().lightPrimaryTextColor;
    kMidLightColor = ThemeClass().lightPrimaryTextColor;
    kCardColor = ThemeClass().lightSecondaryTextColor;
    kDarkColor = ThemeClass().lightDetailTextColor;
    kHeadIconColor = ThemeClass().lightIconColor;
    kLoadColor = ThemeClass().lightLoadColor;
    kLoadingColor = ThemeClass().lightLoadingColor;
    kTextColor = ThemeClass().lightTextColor;
    kGlassColor = ThemeClass().lightGlassColor;
    kGradientOne = ThemeClass().lightGradientOne;
    kGradientTwo = ThemeClass().lightGradientTwo;
    kGradientThree = ThemeClass().lightGradientThree;
  }

  /// DarkMode
  ///
  /// With this function user can switch into darkmode.
  void darkSwitch() {
    kOverlayColor = ThemeClass().darkBackgroundColor;
    kIconColor = ThemeClass().darkPrimeryColor;
    kMidLightColor = ThemeClass().darkPrimaryTextColor;
    kCardColor = ThemeClass().darkSecondaryTextColor;
    kDarkColor = ThemeClass().darkDetailTextColor;
    kHeadIconColor = ThemeClass().darkIconColor;
    kLoadColor = ThemeClass().darkLoadColor;
    kLoadingColor = ThemeClass().darkLoadingColor;
    kTextColor = ThemeClass().darkTextColor;
    kGlassColor = ThemeClass().darkGlassColor;
    kGradientOne = ThemeClass().darkGradientOne;
    kGradientTwo = ThemeClass().darkGradientTwo;
    kGradientThree = ThemeClass().darkGradientThree;
  }

  void reload() {
    if (isReloadHappend == true) {
      Navigator.pop(context);
      isReloadHappend = false;
    }
  }

  void userTheme(bool themeMode) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("ThemeMode", themeMode);
  }

  void userThemeCall() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    themeBool = preferences.getBool("ThemeMode");
    if (themeBool == true) {
      iconMode = const Icon(
        Icons.nights_stay,
        color: Colors.white60,
      );
      iconModeStatus = true;
      darkSwitch();
    } else {
      iconMode = const Icon(
        Icons.light_mode,
        color: Color(0xFFFAFAFA),
      );
      iconModeStatus = false;
      lightSwitch();
    }
  }

  void theme() {
    setState(
      () {
        if (iconModeStatus == true) {
          iconMode = const Icon(
            Icons.light_mode,
            color: Color(0xFFFAFAFA),
          );
          iconModeStatus = false;
          userTheme(iconModeStatus!);
          lightSwitch();
        } else {
          iconMode = const Icon(
            Icons.nights_stay,
            color: Colors.white60,
          );
          iconModeStatus = true;
          userTheme(iconModeStatus!);
          darkSwitch();
        }
      },
    );
  }

  Future<bool> loadCachedWeather() async {
    final cache = await WeatherCache.loadWeather();

    if (cache == null) {
      return false;
    }

    weatherModel = WeatherModel(
      temperatur: cache["temp"],
      feelslike: cache["feelsLike"],
      humidity: cache["humidity"],
      wind: cache["wind"],
      location: cache["location"],
      description: cache["description"],
      icon: cache["icon"],
    );

    setState(() {
      isDataLoaded = true;
      isErrorOccurd = false;
    });

    return true;
  }

  void closeDetailsCard() {
    setState(() {
      isDetailsExpanded = false;
    });

    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        if (!mounted) return;

        setState(() {
          showDetailsCard = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                menuOpen = !menuOpen;
                              });
                              // _key.currentState?.openDrawer();
                            },
                            child: GlassContainer(
                              blurStrength: 15,
                              borderRadius: 30,
                              child: Tooltip(
                                message: "Will Open The Menu",
                                child: Icon(
                                  Icons.menu,
                                  color: kHeadIconColor,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(),
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SearchPage(),
                                  ),
                                );
                              },
                              child: GlassContainer(
                                blurStrength: 15,
                                borderRadius: 30,
                                child: Tooltip(
                                  message: "Will Navigate To Search Page",
                                  child: Icon(
                                    Icons.search,
                                    color: kHeadIconColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    isErrorOccurd
                        ? ErrorMessage(title: title!, message: message!)
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
                                const SizedBox(height: 25),
                                SvgPicture.asset(
                                  weatherModel.icon!,
                                  height: 280,
                                  colorFilter: ColorFilter.mode(
                                    kIconColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                Text(
                                  "${weatherModel.temperatur!.round()}°",
                                  style: GoogleFonts.daysOne(
                                    fontSize: 80,
                                    color: kIconColor,
                                  ),
                                ),
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
                    if (!showDetailsCard)
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              showDetailsCard = true;
                            });

                            Future.delayed(
                              const Duration(milliseconds: 10),
                              () {
                                if (!mounted) return;

                                setState(() {
                                  isDetailsExpanded = true;
                                });
                              },
                            );
                          },
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
                                            text:
                                                "${weatherModel.feelslike!.round()}°",
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
                                            text:
                                                "${weatherModel.wind!.round()}",
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
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (menuOpen)
            GestureDetector(
              onTap: () {
                setState(() {
                  menuOpen = false;
                });
              },
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: menuOpen ? 1 : 0,
                child: Container(
                  color: Colors.black54,
                ),
              ),
            ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            top: menuOpen ? 0 : -320,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 20,
                      sigmaY: 20,
                    ),
                    child: GlassContainer(
                      blurStrength: 15,
                      borderRadius: 30,
                      child: Column(
                        children: [
                          menuItem(
                            Icons.nights_stay,
                            "Theme",
                          ),
                          menuItem(
                            Icons.refresh,
                            "Refresh",
                          ),
                          menuItem(
                            Icons.info_outline,
                            "About",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (showDetailsCard)
            GestureDetector(
              onTap: () {
                closeDetailsCard();
              },
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: isDetailsExpanded ? 1 : 0,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 10,
                    sigmaY: 10,
                  ),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.25),
                  ),
                ),
              ),
            ),
          if (showDetailsCard)
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: isDetailsExpanded ? 0 : 1,
                  end: isDetailsExpanded ? 1 : 0,
                ),
                duration: const Duration(
                  milliseconds: 500,
                ),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(
                      0,
                      lerpDouble(
                        250,
                        0,
                        value,
                      )!,
                    ),
                    child: GlassContainer(
                      blurStrength: 15,
                      borderRadius: 30 + (10 * value),
                      child: SizedBox(
                        width: lerpDouble(
                          350,
                          320,
                          value,
                        ),
                        height: lerpDouble(
                          60,
                          420,
                          value,
                        ),
                        child: Opacity(
                          opacity: value,
                          child: Column(
                            children: [
                              SizedBox(height: 20),
                              Text(
                                "Weather Details",
                                style: GoogleFonts.monda(
                                  color: kHeadIconColor,
                                  fontSize: 22,
                                ),
                              ),
                              SizedBox(height: 20),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      detailRow(
                                        "Temperature",
                                        "${weatherModel.temperatur!.round()}°",
                                      ),
                                      detailRow(
                                        "Feels Like",
                                        "${weatherModel.feelslike!.round()}°",
                                      ),
                                      detailRow(
                                        "Humidity",
                                        "${weatherModel.humidity}%",
                                      ),
                                      detailRow(
                                        "Wind Speed",
                                        "${weatherModel.wind!.round()} km/h",
                                      ),
                                      detailRow(
                                        "Location",
                                        weatherModel.location!,
                                      ),
                                      detailRow(
                                        "Condition",
                                        weatherModel.description!,
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
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget menuItem(
    IconData icon,
    String title,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      onTap: () {
        if (title == "Theme") {
          theme();
        }

        if (title == "Refresh") {
          isReloadHappend = true;

          showDialog(
            context: context,
            builder: (context) => const RefreshLoading(),
          );

          getPremission();
        }

        if (title == "About") {
          showDialog(
            context: context,
            builder: (context) => const Info(),
          );
        }

        setState(() {
          menuOpen = false;
        });
      },
    );
  }
}

Widget detailRow(
  String title,
  String value,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      vertical: 12,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.monda(
            color: kTextColor,
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.monda(
            color: kHeadIconColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
