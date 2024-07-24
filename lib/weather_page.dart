import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:weather_app/theme/theme.dart';
import 'package:weather_app/theme/theme_provider.dart';
import 'package:weather_app/weather_model.dart';
import 'package:weather_app/weather_service.dart';


class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class GradientText extends StatelessWidget {
  const GradientText(
      {super.key, required this.text, required this.gradient, required this.textStyle});

  final String text;
  final Gradient gradient;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient
          .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(
        text,
        style: textStyle.copyWith(color: Colors.white),
      ),
    );
  }
}

class _WeatherPageState extends State<WeatherPage> {
  // API key
  final _weatherService = WeatherService('a82a7e846e5279da84dca24da92595a3');
  Weather? _weather;

  // Fetch weather
  _fetchWeather() async {
    // Get the current city
    String cityName = await _weatherService.getCurrentCity();

    // Get weather for city
    try {
      // ignore: non_constant_identifier_names
      final Weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = Weather;
      });
    } catch (e) {
      if (kDebugMode) {
        print('---------------------- Exception : $e ----------------------');
      }
    }
  }

  // Init state
  @override
  void initState() {
    super.initState();
    // Fetch weather on startup
    _fetchWeather();
  }

  // Define the convertUnixTimestampToDateTime method
  String convertUnixTimestamp(int unixTimestamp) {
    // Convert the Unix timestamp to a DateTime object
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);

    // Format the DateTime object to display only hours and minutes in a 12-hour clock format
    String formattedTime = DateFormat('h:mm a').format(dateTime);

    return formattedTime;
  }

  String getWeatherAnimation(String? mainCondition) {
    DateTime now = DateTime.now();
    if (mainCondition == null) {
      return 'assets/weather_animation/loader.json'; // Default weather condition
    }

    switch (mainCondition.toLowerCase()) {
      case 'clear':
        if (isHourInRange(now) && mainCondition.toLowerCase() == 'clear') {
          return 'assets/weather_animation/clear_night.json';
        } else {
          return 'assets/weather_animation/clear_day.json';
        }

      case 'clouds':
        if (isHourInRange(now) && mainCondition.toLowerCase() == 'clouds') {
          return 'assets/weather_animation/cloudy_night.json';
        } else {
          return 'assets/weather_animation/cloudy_day.json';
        }

      case 'mist':
      case 'smoke':
      case 'fog':
      case 'haze':
      case 'dust':
        if (isHourInRange(now) && mainCondition.toLowerCase() == 'mist') {
          return 'assets/weather_animation/mist_night.json';
        } else {
          return 'assets/weather_animation/mist_day.json';
        }

      case 'rain':
        if (isHourInRange(now) && mainCondition.toLowerCase() == 'rain') {
          return 'assets/weather_animation/rain_night.json';
        } else {
          return 'assets/weather_animation/rain_day.json';
        }

      case 'drizzle':
      case 'shower rain':
        if (isHourInRange(now) && mainCondition.toLowerCase() == 'drizzle') {
          return 'assets/weather_animation/partly_rain_night.json';
        } else {
          return 'assets/weather_animation/partly_rain_day.json';
        }

      case 'thunderstorm':
        if (isHourInRange(now) &&
            mainCondition.toLowerCase() == 'thunderstorm') {
          return 'assets/weather_animation/thunder_storm_night.json';
        } else {
          return 'assets/weather_animation/thunder_storm_day.json';
        }

      default:
        if (isHourInRange(now)) {
          return 'assets/weather_animation/clear_night.json';
        } else {
          return 'assets/weather_animation/clear_day.json';
        }
    }
  }

  int getHourFromUnixTimestamp(int unixTimestamp) {
    // Convert timestamp to DateTime
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000, isUtc: true);

    // Extract hour component
    int hour = dateTime.hour;

    return hour;
  }

  bool isHourInRange(DateTime dateTime) {
    int hour = dateTime.hour;
    return (hour >= 18 && hour <= 24) || (hour >= 0 && hour <= 5);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    Color backgroundColor1;
    Color backgroundColor2;
    DateTime now = DateTime.now();

    final themeProvider = Provider.of<ThemeProvider>(context);

    // Check if the current hour is within the specified range
    if (isHourInRange(now)) {
      backgroundColor1 = const Color.fromARGB(255, 192, 125, 207);
      backgroundColor2 = const Color.fromARGB(255, 95, 77, 176);
    } else {
      backgroundColor1 = const Color.fromARGB(255, 124, 177, 233);
      backgroundColor2 = const Color.fromARGB(255, 30, 100, 174);
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: backgroundColor1,
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.10,
              width: MediaQuery.of(context).size.width,
              color: backgroundColor2,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.06,
                      top: MediaQuery.of(context).size.height * 0.03,
                    ),
                    child: Row(
                      children: [
                        // IconButton(
                        //   icon: Icon(Icons.refresh),
                        //   onPressed: _fetchWeather,
                        // ),
                        Image.asset(
                          'assets/logo/Page_logo.png', // Provide your image path here
                          height: MediaQuery.of(context).size.height * 0.10,
                          width: MediaQuery.of(context).size.width * 0.10,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.02), // Add some space between image and text
                        const GradientText(
                          text: 'Weather',
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 192, 125, 207),
                              Color.fromARGB(255, 210, 162, 221),
                              Color.fromARGB(255, 146, 190, 237),
                              Color.fromARGB(255, 124, 177, 233),
                            ],
                          ),
                          textStyle: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.045,
                    right: MediaQuery.of(context).size.width * 0.06,
                    child: FlutterSwitch(
                      width: MediaQuery.of(context).size.width * 0.18,
                      height: MediaQuery.of(context).size.height * 0.035,
                      valueFontSize: 12,
                      //toggleSize: 25,
                      value: themeProvider.themeData == darkMode,
                      borderRadius: 30,
                      padding: 3.5,
                      showOnOff: true,
                      inactiveColor: Colors.grey.shade800,
                      activeColor: Colors.blue.shade200,
                      inactiveText: 'Dark',
                      activeText: 'Light',
                      inactiveTextColor: Colors.white,
                      activeTextColor: Colors.black,
                      inactiveToggleColor: Colors.grey.shade300,
                      activeToggleColor: Colors.yellow.shade800,
                      onToggle: (val) {
                        themeProvider.toggleTheme();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    backgroundColor2,
                    backgroundColor1,
                  ],
                ),
              ),
              margin: const EdgeInsets.only(top: 0),
              height: screenHeight * 0.58,
              width: screenWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weather?.mainCondition ?? "Weather",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${_weather?.temperature.round()}°C',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${((_weather?.temperature ?? 0) * 9 / 5 + 32).round()}°F',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Lottie.asset(getWeatherAnimation(_weather?.mainCondition),
                      height: screenHeight * 0.25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons
                            .location_on, // You can replace this with the icon you want
                        color: Colors.black,
                        size: 18,
                      ),
                      // Add some space between the icon and text
                      Text(
                        '${_weather?.cityName ?? "City"}, ${_weather?.country ?? "Country"}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Updated : ${convertUnixTimestamp(_weather?.forecastTime ?? 0)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal:
                            20), // Adjust the horizontal padding as needed

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Sunrise',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              convertUnixTimestamp(_weather?.sunRise ?? 0),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Sunset',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              convertUnixTimestamp(_weather?.sunSet ?? 0),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            WaveWidget(
              config: CustomConfig(
                colors: [
                  Theme.of(context)
                      .colorScheme
                      .tertiary, // Adjust opacity as desired
                  Theme.of(context)
                      .colorScheme
                      .secondary, // Adjust opacity as desired
                  Theme.of(context)
                      .colorScheme
                      .primary, // Adjust opacity as desired
                  Theme.of(context).colorScheme.surface,
                ],
                durations: [
                  19450, // Adjust duration to slow down the wave
                  19500, // Adjust duration to slow down the wave
                  19600, // Adjust duration to slow down the wave
                  19700, // Adjust duration to slow down the wave
                ],
                heightPercentages: [0.30, 0.35, 0.45, 0.65],
              ),
              size: Size(screenWidth, screenHeight * 0.07),
            ),
            Container(
              color: Theme.of(context).colorScheme.surface,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        //color: Colors.blue.shade200,
                        color: Theme.of(context).colorScheme.surface,
                        height: screenHeight * 0.125,
                        width: screenWidth * 0.50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.11,
                              width: MediaQuery.of(context).size.width * 0.11,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey
                                    .shade300, // Set background color to yellow
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/icons/celsius_logo.png', // Replace with your image path
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Feels Like   ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceTint,
                                  ),
                                ),
                                Text(
                                  '${(_weather?.tempFeelsLike.round() ?? 0)}°C',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceTint,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Theme.of(context).colorScheme.surface,
                        height: screenHeight * 0.125,
                        width: screenWidth * 0.50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.11,
                              width: MediaQuery.of(context).size.width * 0.11,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey
                                    .shade300, // Set background color to yellow
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/icons/humidity_logo.png', // Replace with your image path
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Humidity',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceTint,
                                  ),
                                ),
                                Text(
                                  '${(_weather?.humidity ?? 0)}%',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceTint,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        color: Theme.of(context).colorScheme.surface,
                        height: screenHeight * 0.125,
                        width: screenWidth * 0.50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.11,
                              width: MediaQuery.of(context).size.width * 0.11,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey
                                    .shade300, // Set background color to yellow
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/icons/wind_logo.png', // Replace with your image path
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Wind Speed',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceTint,
                                  ),
                                ),
                                Text(
                                  '${(_weather?.windSpeed ?? 0)} km/h',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceTint,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Theme.of(context).colorScheme.surface,
                        height: screenHeight * 0.125,
                        width: screenWidth * 0.50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.11,
                              width: MediaQuery.of(context).size.width * 0.11,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey
                                    .shade300, // Set background color to yellow
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/icons/visibility_logo.png', // Replace with your image path
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Visibility',
                                  style: TextStyle(
                                    fontSize: 16,
                                    //fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceTint,
                                  ),
                                ),
                                Text(
                                  '${(_weather?.visibility ?? 0) / 1000} Km',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceTint,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
