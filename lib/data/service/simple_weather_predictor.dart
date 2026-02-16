class SimpleWeatherPredictor {
  // Linear regression coefficients: nextTemp = a*temp + b*humidity + c*wind + d
  final double a;
  final double b;
  final double c;
  final double d;

  SimpleWeatherPredictor({this.a = 0.7, this.b = 0.1, this.c = -0.05, this.d = 2.0});

  /// Predict next day's temperature in Celsius
  double predictNextTemp(double tempC, int humidity, double windSpeed) {
    return a * tempC + b * humidity + c * windSpeed + d;
  }
}
