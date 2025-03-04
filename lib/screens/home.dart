import 'package:clima_weather/components/error_message.dart';
import 'package:clima_weather/components/loading_widget.dart';
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
import 'package:sidebarx/sidebarx.dart';

import '../components/details_widget.dart';
import '../components/refresh_loading.dart';
import '../models/themes.dart';

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
  WeatherModel? weatherModel;
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
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getPremission();
    userThemeCall();
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
    if (!await geolocatorPlatform.isLocationServiceEnabled()) {
      setState(() {
        isErrorOccurd = true;
        isDataLoaded = true;
        title = "Location is turned off";
        message =
            "Please enable the location service to see weather condition for your location";
        return;
      });
    }
    weatherData = await weather.getLocationWeather();
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
    setState(() {
      isDataLoaded = true;
      isErrorOccurd = false;
    });
    reload();
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

  @override
  Widget build(BuildContext context) {
    if (!isDataLoaded) {
      return const LoadingWidget();
    } else {
      return Scaffold(
        key: _key,
        drawer: Padding(
          padding: EdgeInsets.fromLTRB(0, 33, 0, 0),
          child: SidebarX(
            controller: _controller,
            theme: SidebarXTheme(
              // width: 100,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xff353535),
                borderRadius: BorderRadius.circular(20),
              ),
              itemTextPadding: const EdgeInsets.only(left: 12),
              selectedItemTextPadding: const EdgeInsets.only(left: 12),
              textStyle: TextStyle(
                color: Colors.white,
              ),
              selectedTextStyle: const TextStyle(color: Colors.white),
              iconTheme: IconThemeData(
                color: Colors.white,
                size: 20,
              ),
              selectedIconTheme: const IconThemeData(
                color: Colors.white,
                size: 20,
              ),
            ),
            extendedTheme: const SidebarXTheme(
              width: 110,
              decoration: BoxDecoration(
                color: Color(0xff353535),
              ),
            ),
            items: [
              SidebarXItem(
                icon: Icons.nights_stay,
                label: "Theme",
                onTap: () {
                  theme();
                },
              ),
              SidebarXItem(
                icon: Icons.refresh,
                label: "Refresh",
                onTap: () {
                  isReloadHappend = true;
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      context = context;
                      return const RefreshLoading();
                    },
                  );
                  getPremission();
                  getLocation();
                },
              ),
              SidebarXItem(
                icon: Icons.info_outline,
                label: "About",
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      context = context;
                      return const Info();
                    },
                  );
                },
              ),
            ],
          ),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: kOverlayColor,
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      top: 10,
                    ),
                    child: SizedBox(
                      height: 57.0,
                      width: 85,
                      child: GestureDetector(
                        onTap: () {
                          _key.currentState?.openDrawer();
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: kCardColor,
                          child: Icon(
                            Icons.menu,
                            color: kHeadIconColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 8.0,
                      top: 10,
                    ),
                    child: Center(
                      child: SizedBox(
                        height: 57.0,
                        width: 85,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SearchPage(),
                              ),
                            );
                          },
                          child: Tooltip(
                            message: "Will Navigate To Search Page",
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: kCardColor,
                              child: Icon(
                                Icons.search,
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
                                weatherModel?.location! ?? "no data",
                                style: GoogleFonts.monda(
                                  fontSize: 20,
                                  color: kMidLightColor,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 25),
                          SvgPicture.asset(
                            weatherModel!.icon!,
                            height: 280,
                            colorFilter: ColorFilter.mode(
                              kIconColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          Text(
                            "${weatherModel?.temperatur!.round()}°",
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
                          child: DetailsWidget(
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
                          child: DetailsWidget(
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
                          child: DetailsWidget(
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
// class SecondRoute extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Second Route'),
//         automaticallyImplyLeading: false,
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Go back!'),
//         ),
//       ),
//     );
//   }
// }

// class Menu extends StatefulWidget {
//   const Menu({super.key});

//   @override
//   State<Menu> createState() => _MenuState();
// }

// class _MenuState extends State<Menu> {
//   @override
//   void initState() {
//     super.initState();
//     // userThemeCall();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 60,
//       child: GestureDetector(
//         onTap: () => showPopover(
//           bodyBuilder: (context) => const MenuItems(),
//           context: context,
//           width: 150,
//           height: 100,
//           backgroundColor: kOverlayColor,
//         ),
//         child: const Icon(Icons.menu),
//       ),
//     );
//   }
// }

// class MenuItems extends StatefulWidget {
//   const MenuItems({super.key});

//   @override
//   State<MenuItems> createState() => _MenuItemsState();
// }

// class _MenuItemsState extends State<MenuItems> {
//   /// LightMode
//   ///
//   /// With this function user can switch into lightmode.
//   void lightSwitch() {
//     kOverlayColor = ThemeClass().lightBackgroundColor;
//     kIconColor = ThemeClass().lightPrimaryTextColor;
//     kMidLightColor = ThemeClass().lightPrimaryTextColor;
//     kCardColor = ThemeClass().lightSecondaryTextColor;
//     kDarkColor = ThemeClass().lightDetailTextColor;
//     kHeadIconColor = ThemeClass().lightIconColor;
//     kLoadColor = ThemeClass().lightLoadColor;
//     kLoadingColor = ThemeClass().lightLoadingColor;
//   }

//   /// DarkMode
//   ///
//   /// With this function user can switch into darkmode.
//   void darkSwitch() {
//     kOverlayColor = ThemeClass().darkBackgroundColor;
//     kIconColor = ThemeClass().darkPrimeryColor;
//     kMidLightColor = ThemeClass().darkPrimaryTextColor;
//     kCardColor = ThemeClass().darkSecondaryTextColor;
//     kDarkColor = ThemeClass().darkDetailTextColor;
//     kHeadIconColor = ThemeClass().darkIconColor;
//     kLoadColor = ThemeClass().darkLoadColor;
//     kLoadingColor = ThemeClass().darkLoadingColor;
//   }

//   void userTheme(bool themeMode) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     preferences.setBool("ThemeMode", themeMode);
//   }

//   void userThemeCall() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     themeBool = preferences.getBool("ThemeMode");
//     if (themeBool == true) {
//       iconMode = const Icon(
//         Icons.nights_stay,
//         color: Colors.white60,
//       );
//       iconModeStatus = true;
//       darkSwitch();
//     } else {
//       iconMode = const Icon(
//         Icons.light_mode,
//         color: Color(0xFFFAFAFA),
//       );
//       iconModeStatus = false;
//       lightSwitch();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(5.0),
//           child: SizedBox(
//             child: GestureDetector(
//               child: const Icon(Icons.dark_mode),
//               onTap: () {
//                 setState(
//                   () {
//                     if (iconModeStatus == true) {
//                       iconMode = const Icon(
//                         Icons.light_mode,
//                         color: Color(0xFFFAFAFA),
//                       );
//                       iconModeStatus = false;
//                       userTheme(iconModeStatus!);
//                       lightSwitch();
//                       print("cock");
//                     } else {
//                       iconMode = const Icon(
//                         Icons.nights_stay,
//                         color: Colors.white60,
//                       );
//                       iconModeStatus = true;
//                       userTheme(iconModeStatus!);
//                       darkSwitch();
//                       print("lock");
//                     }
//                   },
//                 );
//               },
//             ),
//           ),
//         ),
//         Container(
//           height: 50,
//           color: Colors.red,
//         ),
//       ],
//     );
//   }
// }
