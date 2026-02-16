import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  String tempUnit; // "C" or "F"

  UserPreferences({this.tempUnit = "C"});

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      tempUnit: json['tempUnit'] ?? "C",
    );
  }

  Map<String, dynamic> toJson() => {
    'tempUnit': tempUnit,
  };

  static const _key = "user_preferences";

  /// Load preferences from SharedPreferences
  static Future<UserPreferences> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString != null) {
      return UserPreferences.fromJson(json.decode(jsonString));
    }
    return UserPreferences(); // default: Celsius
  }

  /// Save preferences to SharedPreferences
  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, json.encode(toJson()));
  }
}
