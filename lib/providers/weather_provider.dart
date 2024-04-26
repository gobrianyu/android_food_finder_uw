import 'package:flutter/material.dart';
import 'package:food_finder/weather_conditions.dart';

class WeatherProvider extends ChangeNotifier {
  int tempInFarenheit = 0;
  WeatherCondition condition = WeatherCondition.unknown;
  bool isLoaded = false;

  updateWeather(int newTempFarenheit, WeatherCondition newCondition){
    tempInFarenheit = newTempFarenheit;
    condition = newCondition;
    notifyListeners();
  }
}