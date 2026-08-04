import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryService {
  static const _historyKey = "recent_searches";

  static Future<List<String>> getRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(_historyKey) ?? [];
  }

  static Future<void> addSearch(String city) async {
    final prefs = await SharedPreferences.getInstance();

    final history = prefs.getStringList(_historyKey) ?? [];

    history.removeWhere(
      (item) => item.toLowerCase() == city.toLowerCase(),
    );

    history.insert(0, city);

    if (history.length > 5) {
      history.removeLast();
    }

    await prefs.setStringList(
      _historyKey,
      history,
    );
  }

  static Future<void> removeSearch(String city) async {
    final prefs = await SharedPreferences.getInstance();

    final history = prefs.getStringList(_historyKey) ?? [];

    history.removeWhere(
      (item) => item.toLowerCase() == city.toLowerCase(),
    );

    await prefs.setStringList(
      _historyKey,
      history,
    );
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_historyKey);
  }
}
