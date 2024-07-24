class Weather {
  final String cityName;
  final String country;
  final double temperature;
  final String mainCondition;
  final int sunRise;
  final int sunSet;
  final int forecastTime;
  final double tempFeelsLike;
  final int humidity;
  final num windSpeed;
  final int visibility;

  Weather({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.mainCondition,
    required this.sunRise,
    required this.sunSet,
    required this.forecastTime,
    required this.tempFeelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.visibility,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        cityName: json['name'],
        country: json['sys']['country'],
        temperature: json['main']['temp'].toDouble(),
        mainCondition: json['weather'][0]['main'],
        sunRise: json['sys']['sunrise'],
        sunSet: json['sys']['sunset'],
        forecastTime: json['dt'],
        tempFeelsLike: json['main']['feels_like'].toDouble(),
        humidity: json['main']['humidity'],
        windSpeed: json['wind']['speed'],
        visibility: json['visibility']);
  }
}
