import '../models/weather_models.dart';
import '../provider/weather_api.dart';

class WeatherService {
  final WeatherApi _api = WeatherApi();

  Future<WeatherBundle> fetchCityWeather(String city) {
    return _api.getWeatherForCity(city);
  }
}
