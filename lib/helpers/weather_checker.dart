import 'dart:convert';
import 'package:food_finder/providers/weather_provider.dart';
import 'package:http/http.dart' as http;
import 'package:food_finder/weather_conditions.dart';

class WeatherChecker {
  final WeatherProvider weatherProvider;
  double _latitude = 200; // Allen Center is here, per Google Maps; default location prior to loading
  double _longitude = 200;

  WeatherChecker(this.weatherProvider);

  updateLocation(double latitude, double longitude) {
    _latitude = latitude;
    _longitude = longitude;
  }

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
      // TODO(optional): Find a way to have the UI let the user know that we haven't been able to update data successfully
    } finally {
      client.close();
    }
  }

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
