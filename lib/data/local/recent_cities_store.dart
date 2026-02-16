import 'package:shared_preferences/shared_preferences.dart';

class RecentCitiesStore {
  static const _key = "recent_cities";

  Future<List<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  Future<void> saveCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_key) ?? [];

    final clean = city.trim();
    if (clean.isEmpty) return;

    current.removeWhere((c) => c.toLowerCase() == clean.toLowerCase());
    current.insert(0, clean);

    final limited = current.take(10).toList();
    await prefs.setStringList(_key, limited);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
