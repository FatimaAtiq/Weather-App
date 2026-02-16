import 'package:flutter/material.dart';
import '../data/models/weather_models.dart';

String iconUrl(String icon) {
  if (icon.startsWith("//")) return "https:$icon";
  return icon;
}


class WeatherInfoCards extends StatelessWidget {
  final WeatherNow now;
  const WeatherInfoCards({super.key, required this.now});

  Widget _miniCard(String title, String value, IconData icon) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.white70),
              const SizedBox(height: 10),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _miniCard("Humidity", "${now.humidity}%", Icons.water_drop_rounded),
        const SizedBox(width: 10),
        _miniCard("Wind", "${now.windSpeed.toStringAsFixed(1)} m/s", Icons.air_rounded),
      ],
    );
  }
}


class Forecast3Days extends StatelessWidget {
  final List<ForecastDay> days;
  const Forecast3Days({super.key, required this.days});

  String _dayName(DateTime d) {
    const names = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return names[d.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Next 3 Days", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...days.map((d) {
              return Row(
                children: [
                  SizedBox(width: 44, child: Text(_dayName(d.date))),
                  Image.network(iconUrl(d.icon), width: 36, height: 36),
                  const SizedBox(width: 8),
                  Expanded(child: Text(d.description)),
                  Text("${d.minC.toStringAsFixed(0)}° / ${d.maxC.toStringAsFixed(0)}°"),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
