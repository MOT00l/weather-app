import 'dart:ui';

import 'package:clima_weather/components/app_background.dart';
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
import '../models/drang_handle.dart';
import '../models/themes.dart';
import '../services/weather_cache.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
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
    tempmin: 0,
    tempmax: 0,
    pressure: 0,
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

  // ======================================
  // DETAILS CARD ANIMATION
  // ======================================
  late AnimationController detailsController;

  // ======================================
  // LAST UPDATE
  // ======================================
  String lastUpdated = "Updating...";
  String formatLastUpdated(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return "Last updated: $hour:$minute";
  }

  @override
  void initState() {
    super.initState();

    detailsController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    );

    initializeWeather();
    userThemeCall();
    loadLastUpdated();
  }

// ======================================
// WEATHER DATA
// ======================================
  Future<void> initializeWeather() async {
    await loadCachedWeather();

    getPremission();
  }

// ======================================
// LAST UPDATE
// ======================================
  Future<void> loadLastUpdated() async {
    final prefs = await SharedPreferences.getInstance();

    final savedTime = prefs.getString("lastUpdated");

    if (savedTime == null) return;

    final dateTime = DateTime.parse(savedTime);

    setState(() {
      lastUpdated = formatLastUpdated(dateTime);
    });
  }

  @override
  void dispose() {
    detailsController.dispose();
    super.dispose();
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
      tempmin: weatherData["main"]["temp_min"],
      tempmax: weatherData["main"]["temp_max"],
      pressure: weatherData["main"]["pressure"],
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

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      "lastUpdated",
      DateTime.now().toIso8601String(),
    );

    // await WidgetService.updateWidget(
    //   temp: weatherModel!.temperatur.round().toString(),
    //   description: weatherModel!.description!,
    //   location: weatherModel!.location!,
    // );

    final now = DateTime.now();

    setState(() {
      lastUpdated = formatLastUpdated(now);
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

  // ======================================
  // THEME MANAGEMENT
  // ======================================

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kOverlayColor,
      body: Stack(
        children: [
          // Main Weather Content
          Positioned.fill(
            child: AppBackground(
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      width: 360,

                      //Top Row
                      child: Row(
                        children: [
                          // Menu Button
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                menuOpen = !menuOpen;
                              });
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

                          //Search Page Button
                          GestureDetector(
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
                        ],
                      ),
                    ),

                    //Middle Widgets
                    Expanded(
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
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 800),
                            child: SvgPicture.asset(
                              weatherModel.icon!,
                              height: 280,
                              colorFilter: ColorFilter.mode(
                                kIconColor,
                                BlendMode.srcIn,
                              ),
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
                          const SizedBox(height: 8),
                          Text(
                            lastUpdated,
                            style: GoogleFonts.monda(
                              fontSize: 16,
                              color: kTextColor.withOpacity(0.7),
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

          // Menu Backdrop
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

          // Slide Down Menu
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

          // Weather Bottom Sheet
          Padding(
            padding: EdgeInsets.only(bottom: 25),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: WeatherBottomSheet(
                controller: detailsController,
                weatherModel: weatherModel,
                isErrorOccurd: isErrorOccurd,
              ),
            ),
          ),
        ],
      ),
    );
  }

// Menu Items
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

// Expanded Detail Row
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

class WeatherBottomSheet extends StatelessWidget {
  final AnimationController controller;
  final WeatherModel weatherModel;
  final bool isErrorOccurd;
  const WeatherBottomSheet({
    super.key,
    required this.controller,
    required this.weatherModel,
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
                250,
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
                        weatherModel: weatherModel,
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
                        weatherModel: weatherModel,
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
  final WeatherModel weatherModel;
  final bool isErrorOccurd;

  const CompactContent({
    super.key,
    required this.weatherModel,
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
                text: "${weatherModel.feelslike?.round() ?? 0}°",
                detailText: "FEELS LIKE",
                color: kHeadIconColor,
                colorDetail: kTextColor,
              ),
            ),
            Expanded(
              child: DetailsWidget(
                text: "${weatherModel.humidity ?? 0}%",
                detailText: "HUMIDITY",
                color: kHeadIconColor,
                colorDetail: kTextColor,
              ),
            ),
            Expanded(
              child: DetailsWidget(
                text: "${weatherModel.wind?.round() ?? 0}",
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
  final WeatherModel weatherModel;

  const ExpandedContent({
    super.key,
    required this.weatherModel,
  });

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
                  text: "${weatherModel.feelslike?.round() ?? 0}°",
                  detailText: "FEELS LIKE",
                  color: kHeadIconColor,
                  colorDetail: kTextColor,
                ),
              ),
              Expanded(
                child: DetailsWidget(
                  text: "${weatherModel.humidity ?? 0}%",
                  detailText: "HUMIDITY",
                  color: kHeadIconColor,
                  colorDetail: kTextColor,
                ),
              ),
              Expanded(
                child: DetailsWidget(
                  text: "${weatherModel.wind?.round() ?? 0}",
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
                  text: "${weatherModel.tempmax?.round() ?? 0}°",
                  detailText: "MAX \n TEMPERATURE",
                  color: kHeadIconColor,
                  colorDetail: kTextColor,
                ),
              ),
              Expanded(
                child: DetailsWidget(
                  text: "${weatherModel.tempmin?.round() ?? 0}°",
                  detailText: "MIN \n TEMPERATURE",
                  color: kHeadIconColor,
                  colorDetail: kTextColor,
                ),
              ),
              Expanded(
                child: DetailsWidget(
                  text: "${weatherModel.pressure ?? 0}",
                  detailText: "\n PRESSURE",
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
