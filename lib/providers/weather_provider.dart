import 'package:flutter/material.dart';
import 'package:food_finder/weather_conditions.dart';

// This class represents a weather provider. Receives updated
// weather information and notifies its listeners.
class WeatherProvider extends ChangeNotifier {
  int tempInFarenheit = 0;
  WeatherCondition condition = WeatherCondition.unknown; // Weather condition is set to unknown be default.
  bool isLoaded = false; // True when weather information has been updated and is not unknown.

  // Updates weather condition to provided weather condition.
  // Parameters:
  // - int newTempFarenheit: template parameter (that's also incorrectly spelled); not used in app
  // - WeatherCondition newCondition: new weather condition to set to
  updateWeather(int newTempFarenheit, WeatherCondition newCondition){
    tempInFarenheit = newTempFarenheit;
    condition = newCondition;
    isLoaded = (condition != WeatherCondition.unknown); // isLoaded is true if newCondition is not unknown.
    notifyListeners(); // Notifying listeners
  }
}