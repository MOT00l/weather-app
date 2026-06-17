import 'package:shared_preferences/shared_preferences.dart';

class WeatherCache {
  static Future<void> saveWeather({
    required double temp,
    required double feelsLike,
    required int humidity,
    required double wind,
    required String location,
    required String description,
    required String icon,
    required double tempmin,
    required double tempmax,
    required int pressure,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble("temp", temp);
    await prefs.setDouble("feelsLike", feelsLike);
    await prefs.setInt("humidity", humidity);
    await prefs.setDouble("wind", wind);

    await prefs.setString("location", location);
    await prefs.setString("description", description);
    await prefs.setString("icon", icon);

    await prefs.setDouble("tempmin", tempmin);
    await prefs.setDouble("tempmax", tempmax);
    await prefs.setInt("pressure", pressure);
  }

  static Future<Map<String, dynamic>?> loadWeather() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey("temp")) {
      return null;
    }

    return {
      "temp": prefs.getDouble("temp"),
      "feelsLike": prefs.getDouble("feelsLike"),
      "humidity": prefs.getInt("humidity"),
      "wind": prefs.getDouble("wind"),
      "location": prefs.getString("location"),
      "description": prefs.getString("description"),
      "icon": prefs.getString("icon"),
      "lastUpdate": prefs.getInt("lastUpdate"),
      "tempmin": prefs.getDouble("tempmin"),
      "tempmax": prefs.getDouble("tempmax"),
      "pressure": prefs.getInt("pressure"),
    };
  }
}
