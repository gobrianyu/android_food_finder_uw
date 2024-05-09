import 'dart:convert';
import 'package:food_finder/providers/weather_provider.dart';
import 'package:http/http.dart' as http;
import 'package:food_finder/weather_conditions.dart';

// This class represents a weather checker. It stores coordinates for a location,
// call an API to check the current weather at that location, and update the stored
// location to a new coordinate pair.
class WeatherChecker {
  final WeatherProvider weatherProvider;
  double _latitude = 200; // Default coordinates prior to loading; this is ok because these are invalid coordinates on a map.
  double _longitude = 200;

  WeatherChecker(this.weatherProvider);


  // Updates latitude and longitude with given values.
  // Parameters:
  // - double latitude: new latitude
  // - double longitude: new longitude
  updateLocation(double latitude, double longitude) {
    _latitude = latitude;
    _longitude = longitude;
  }


  // Fetches and updates the weather from an API at the provided latitude and longitude.
  fetchAndUpdateCurrentSeattleWeather() async {
    var client = http.Client();
    try {
      final gridResponse = await client.get(
          Uri.parse('https://api.weather.gov/points/$_latitude,$_longitude'));
      final gridParsed = (jsonDecode(gridResponse.body));
      final String? forecastURL = gridParsed['properties']?['forecast'];
      if (forecastURL == null) {
        // do nothing
      } else {
        final weatherResponse = await client.get(Uri.parse(forecastURL));
        final weatherParsed = jsonDecode(weatherResponse.body);
        final currentPeriod = weatherParsed['properties']?['periods']?[0];
        if (currentPeriod != null) {
          final temperature = currentPeriod['temperature'];
          final shortForecast = currentPeriod['shortForecast'];
          print(
              'Got the weather at ${DateTime.now()}. $temperature F and $shortForecast');
          if (temperature != null && shortForecast != null) {
            final condition = _shortForecastToCondition(shortForecast);
            weatherProvider.updateWeather(temperature, condition);
          }
        }
      }
    } catch (_) {
      // Catch implemented further down in a different class.
    } finally {
      client.close();
    }
  }


  // Simplifies the weather condition to one of four possible conditions:
  // rainy, gloomy, sunny, and unknown.
  WeatherCondition _shortForecastToCondition(String shortForecast) {
    final lowercased = shortForecast.toLowerCase();
    if (lowercased.startsWith('rain') || lowercased.startsWith('showers')) {
      return WeatherCondition.rainy;
    } else if (lowercased.startsWith('sun') || lowercased.startsWith('partly') || lowercased.startsWith('clear')) {
      return WeatherCondition.sunny;
    }
    return WeatherCondition.gloomy;
  }
}
