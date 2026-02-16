class GeoLocation {
  final String name;
  final double lat;
  final double lon;
  final String? country;

  GeoLocation({required this.name, required this.lat, required this.lon, this.country});

  factory GeoLocation.fromJson(Map<String, dynamic> json) {
    return GeoLocation(
      name: (json['name'] ?? '').toString(),
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      country: json['country']?.toString(),
    );
  }
}

class WeatherNow {
  final double tempC;
  final int humidity;
  final double windSpeed;
  final String description;
  final String icon;

  WeatherNow({
    required this.tempC,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
  });

  factory WeatherNow.fromJson(Map<String, dynamic> json) {
    final weather0 = (json['weather'] as List).isNotEmpty ? (json['weather'] as List).first : {};
    return WeatherNow(
      tempC: (json['temp'] as num).toDouble(),
      humidity: (json['humidity'] as num).toInt(),
      windSpeed: (json['wind_speed'] as num).toDouble(),
      description: (weather0['description'] ?? 'No description').toString(),
      icon: (weather0['icon'] ?? '01d').toString(),
    );
  }
}

class ForecastDay {
  final DateTime date;
  final double minC;
  final double maxC;
  final String icon;
  final String description;

  ForecastDay({
    required this.date,
    required this.minC,
    required this.maxC,
    required this.icon,
    required this.description,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    final weather0 = (json['weather'] as List).isNotEmpty ? (json['weather'] as List).first : {};
    return ForecastDay(
      date: DateTime.fromMillisecondsSinceEpoch(((json['dt'] as num).toInt()) * 1000),
      minC: ((json['temp']['min'] as num).toDouble()),
      maxC: ((json['temp']['max'] as num).toDouble()),
      icon: (weather0['icon'] ?? '01d').toString(),
      description: (weather0['description'] ?? 'No description').toString(),
    );
  }
}

class WeatherBundle {
  final GeoLocation location;
  final WeatherNow now;
  final List<ForecastDay> next3Days;

  WeatherBundle({required this.location, required this.now, required this.next3Days});
}
