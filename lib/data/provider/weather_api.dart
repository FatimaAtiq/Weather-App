import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_models.dart';

const String weatherApiKey = "1a5d368cd2be485987b102052260801";

class WeatherApi {
  final http.Client _client = http.Client();

  Future<WeatherBundle> getWeatherForCity(String city) async {
    final uri = Uri.parse(
      "https://api.weatherapi.com/v1/forecast.json"
          "?key=$weatherApiKey&q=${Uri.encodeComponent(city)}&days=3&aqi=no&alerts=no",
    );

    print("WEATHERAPI KEY = $weatherApiKey");
    print("REQUEST = $uri");

    final res = await _client.get(uri);

    print("STATUS = ${res.statusCode}");
    print("BODY = ${res.body}");

    if (res.statusCode != 200) {
      throw Exception("Weather fetch failed (${res.statusCode}): ${res.body}");
    }

    final data = json.decode(res.body) as Map<String, dynamic>;
    final loc = data['location'] as Map<String, dynamic>;
    final current = data['current'] as Map<String, dynamic>;
    final forecastDays = (data['forecast']['forecastday'] as List).cast<Map<String, dynamic>>();

    final location = GeoLocation(
      name: loc['name'].toString(),
      lat: (loc['lat'] as num).toDouble(),
      lon: (loc['lon'] as num).toDouble(),
      country: loc['country']?.toString(),
    );

    final now = WeatherNow(
      tempC: (current['temp_c'] as num).toDouble(),
      humidity: (current['humidity'] as num).toInt(),
      windSpeed: ((current['wind_kph'] as num).toDouble()) / 3.6,
      description: (current['condition']['text'] ?? 'No description').toString(),
      icon: (current['condition']['icon'] ?? '').toString(),
    );

    final next3 = forecastDays.map((d) {
      final day = d['day'] as Map<String, dynamic>;
      final condition = day['condition'] as Map<String, dynamic>;

      return ForecastDay(
        date: DateTime.parse(d['date'].toString()),
        minC: (day['mintemp_c'] as num).toDouble(),
        maxC: (day['maxtemp_c'] as num).toDouble(),
        icon: (condition['icon'] ?? '').toString(),
        description: (condition['text'] ?? 'No description').toString(),
      );
    }).toList();

    return WeatherBundle(location: location, now: now, next3Days: next3);
  }
}
