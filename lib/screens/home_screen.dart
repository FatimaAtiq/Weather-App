import 'package:flutter/material.dart';
import '../data/local/recent_cities_store.dart';
import 'weather_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  final _store = RecentCitiesStore();
  List<String> _recent = [];

  @override
  void initState() {
    super.initState();
    _loadRecent();
  }

  Future<void> _loadRecent() async {
    final list = await _store.load();
    setState(() => _recent = list);
  }

  void _openCity(String city) async {
    await _store.saveCity(city);
    await _loadRecent();

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => WeatherDetailsScreen(city: city)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weather Forecast")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF2DD4BF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Weather Forecast", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  const Text("Search a city to see current weather & 3-day forecast",
                      style: TextStyle(fontSize: 13, color: Colors.white70)),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: "Search city (e.g., Lahore)",
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.arrow_forward_rounded),
                        onPressed: () => _openCity(_controller.text),
                      ),
                    ),
                    onSubmitted: (v) => _openCity(v),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),
            Row(
              children: [
                const Text("Recent", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const Spacer(),
                TextButton.icon(
                  onPressed: () async {
                    await _store.clear();
                    await _loadRecent();
                  },
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  label: const Text("Clear"),
                ),
              ],
            ),
            const SizedBox(height: 8),

            if (_recent.isNotEmpty) ...[
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _recent.take(8).map((city) {
                  return InkWell(
                    onTap: () => _openCity(city),
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111A33),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on_rounded, size: 16, color: Colors.white70),
                          const SizedBox(width: 6),
                          Text(city, style: const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
            ],

            Expanded(
              child: _recent.isEmpty
                  ? const Center(child: Text("No recent cities", style: TextStyle(color: Colors.white60)))
                  : ListView.builder(
                itemCount: _recent.length,
                itemBuilder: (context, i) {
                  final city = _recent[i];
                  return Card(
                    child: ListTile(
                      onTap: () => _openCity(city),
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.location_city_rounded),
                      ),
                      title: Text(city, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: const Text("Tap to view details"),
                      trailing: const Icon(Icons.chevron_right_rounded),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
