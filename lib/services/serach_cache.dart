import 'package:shared_preferences/shared_preferences.dart';

class SearchCache {
  static Future<void> saveWeather({
    required double search_temp,
    required double search_feelsLike,
    required int search_humidity,
    required double search_wind,
    required String search_location,
    required String search_description,
    required String search_icon,
    required double search_tempmin,
    required double search_tempmax,
    required double search_pressure,
    required int search_chanceofrain,
    required double search_uv,
    required String search_winddir,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble("search_temp", search_temp);
    await prefs.setDouble("search_feelsLike", search_feelsLike);
    await prefs.setInt("search_humidity", search_humidity);
    await prefs.setDouble("search_wind", search_wind);

    await prefs.setString("search_location", search_location);
    await prefs.setString("search_description", search_description);
    await prefs.setString("search_icon", search_icon);

    await prefs.setDouble("search_tempmin", search_tempmin);
    await prefs.setDouble("search_tempmax", search_tempmax);
    await prefs.setDouble("search_pressure", search_pressure);
    await prefs.setInt("search_chanceofrain", search_chanceofrain);
    await prefs.setDouble("search_uv", search_uv);
    await prefs.setString("search_winddir", search_winddir);

    await prefs.setInt(
      "search_lastUpdate",
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  static Future<Map<String, dynamic>?> loadWeather() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey("search_temp")) {
      return null;
    }

    return {
      "search_temp": prefs.getDouble("search_temp"),
      "search_feelsLike": prefs.getDouble("search_feelsLike"),
      "search_humidity": prefs.getInt("search_humidity"),
      "search_wind": prefs.getDouble("search_wind"),
      "search_location": prefs.getString("search_location"),
      "search_description": prefs.getString("search_description"),
      "search_icon": prefs.getString("search_icon"),
      "search_lastUpdate": prefs.getInt("search_lastUpdate"),
      "search_tempmin": prefs.getDouble("search_tempmin"),
      "search_tempmax": prefs.getDouble("search_tempmax"),
      "search_pressure": prefs.getDouble("search_pressure"),
      "search_chanceofrain": prefs.getInt("search_chanceofrain"),
      "search_uv": prefs.getDouble("search_uv"),
      "search_winddir": prefs.getString("search_winddir"),
    };
  }
}
