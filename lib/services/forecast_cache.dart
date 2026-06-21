import 'package:shared_preferences/shared_preferences.dart';

class ForecastCache {
  static Future<void> saveWeather({
    required String forecast_date1,
    required String forecast_date2,
    required String forecast_date3,
    required double forecast_tempmin1,
    required double forecast_tempmin2,
    required double forecast_tempmin3,
    required double forecast_tempmax1,
    required double forecast_tempmax2,
    required double forecast_tempmax3,
    required double forecast_maxwind1,
    required double forecast_maxwind2,
    required double forecast_maxwind3,
    required String forecast_icon1,
    required String forecast_icon2,
    required String forecast_icon3,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("forecast_date1", forecast_date1);
    await prefs.setString("forecast_date2", forecast_date2);
    await prefs.setString("forecast_date3", forecast_date3);

    await prefs.setString("forecast_icon1", forecast_icon1);
    await prefs.setString("forecast_icon2", forecast_icon2);
    await prefs.setString("forecast_icon3", forecast_icon3);

    await prefs.setDouble("forecast_tempmin1", forecast_tempmin1);
    await prefs.setDouble("forecast_tempmin2", forecast_tempmin2);
    await prefs.setDouble("forecast_tempmin3", forecast_tempmin3);

    await prefs.setDouble("forecast_tempmax1", forecast_tempmax1);
    await prefs.setDouble("forecast_tempmax2", forecast_tempmax2);
    await prefs.setDouble("forecast_tempmax3", forecast_tempmax3);

    await prefs.setDouble("forecast_maxwind1", forecast_maxwind1);
    await prefs.setDouble("forecast_maxwind2", forecast_maxwind2);
    await prefs.setDouble("forecast_maxwind3", forecast_maxwind3);
    await prefs.setInt(
      "forecast_lastUpdate",
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  static Future<Map<String, dynamic>?> loadWeather() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      "forecast_date1": prefs.getString("forecast_date1"),
      "forecast_date2": prefs.getString("forecast_date2"),
      "forecast_date3": prefs.getString("forecast_date3"),
      "forecast_icon1": prefs.getString("forecast_icon1"),
      "forecast_icon2": prefs.getString("forecast_icon2"),
      "forecast_icon3": prefs.getString("forecast_icon3"),
      "forecast_tempmin1": prefs.getDouble("forecast_tempmin1"),
      "forecast_tempmin2": prefs.getDouble("forecast_tempmin2"),
      "forecast_tempmin3": prefs.getDouble("forecast_tempmin3"),
      "forecast_tempmax1": prefs.getDouble("forecast_tempmax1"),
      "forecast_tempmax2": prefs.getDouble("forecast_tempmax2"),
      "forecast_tempmax3": prefs.getDouble("forecast_tempmax3"),
      "forecast_maxwind1": prefs.getDouble("forecast_maxwind1"),
      "forecast_maxwind2": prefs.getDouble("forecast_maxwind2"),
      "forecast_maxwind3": prefs.getDouble("forecast_maxwind3"),
    };
  }
}
