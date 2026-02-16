import 'package:flutter/material.dart';
import '../data/models/weather_models.dart';
import '../data/service/weather_service.dart';
import '../data/service/simple_weather_predictor.dart';
import '../data/local/user_preferences.dart';
import '../widgets/fade_in.dart';
import '../widgets/weather_cards.dart';

class WeatherDetailsScreen extends StatefulWidget {
  final String city;
  const WeatherDetailsScreen({super.key, required this.city});

  @override
  State<WeatherDetailsScreen> createState() => _WeatherDetailsScreenState();
}

class _WeatherDetailsScreenState extends State<WeatherDetailsScreen> {
  final _service = WeatherService();
  WeatherBundle? _bundle;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final data = await _service.fetchCityWeather(widget.city);
      setState(() {
        _bundle = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll("Exception:", "").trim();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.city)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : (_error != null)
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Error: $_error", textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _load, child: const Text("Retry")),
            ],
          ),
        ),
      )
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    final bundle = _bundle!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current weather HERO
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF2DD4BF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                Image.network(
                  iconUrl(bundle.now.icon),
                  width: 56,
                  height: 56,
                  errorBuilder: (_, __, ___) => const Icon(Icons.cloud, size: 46),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${bundle.location.name}${bundle.location.country != null ? ", ${bundle.location.country}" : ""}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${bundle.now.tempC.toStringAsFixed(1)}°C",
                        style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 2),
                      Text(bundle.now.description, style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Weather info cards
          WeatherInfoCards(now: bundle.now),

          const SizedBox(height: 14),

          // Predicted next-day temperature using ML model
          FutureBuilder<UserPreferences>(
            future: UserPreferences.load(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();
              final prefs = snapshot.data!;
              final predictor = SimpleWeatherPredictor();
              double nextTempC = predictor.predictNextTemp(
                bundle.now.tempC,
                bundle.now.humidity,
                bundle.now.windSpeed,
              );

              String displayTemp;
              if (prefs.tempUnit == "F") {
                final nextTempF = nextTempC * 9 / 5 + 32;
                displayTemp = "${nextTempF.toStringAsFixed(1)}°F";
              } else {
                displayTemp = "${nextTempC.toStringAsFixed(1)}°C";
              }

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.thermostat_rounded, size: 36),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Predicted Tomorrow", style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(displayTemp, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 14),

          // Forecast for next 3 days
          Forecast3Days(days: bundle.next3Days),
        ],
      ),
    );
  }
}
