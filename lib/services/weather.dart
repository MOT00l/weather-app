import 'package:clima_weather/services/location.dart';
import 'package:clima_weather/services/networking.dart';

import '../utilities/constants.dart';

/// Weather Network Manager
///
/// By this class, developer can call [getLocationWeather] to fetch some weather
/// data by specific [Location].
class Weather {
  /// # Get Weather By Location
  ///
  /// Gets latest weather cordinations by Api class.
  ///
  /// __Note__: Keep in touch about [open weathr api](https://google.com)
  ///
  /// - Supports from Async function.
  /// - Can use a lot of time.

  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();

    String urirequest() {
      Uri request = Uri(
        scheme: "https",
        host: "api.openweathermap.org",
        path: "/data/2.5/weather",
        queryParameters: {
          "lat": location.latitude.toString(),
          "lon": location.longitude.toString(),
          "appid": apiKey,
          "units": "metric",
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
}