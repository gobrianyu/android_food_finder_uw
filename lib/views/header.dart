import 'package:flutter/material.dart';
import 'package:food_finder/weather_conditions.dart';

class WeatherHeader extends StatelessWidget {
  final WeatherCondition condition;
  final double latitude;
  final double longitude;
  const WeatherHeader(this.condition, this.latitude, this.longitude, {super.key});

  @override
  Widget build(BuildContext context) {
    final String roundedLatitude = latitude.toStringAsFixed(2);
    final String roundedLongitude = longitude.toStringAsFixed(2);
    IconData weatherIcon;
    String conditionText = '';
    switch (condition) {
      case WeatherCondition.gloomy:
        weatherIcon = Icons.cloud_outlined;
        conditionText = 'Gloomy';
      case WeatherCondition.sunny:
        weatherIcon = Icons.wb_sunny_outlined;
        conditionText = 'Sunny';
      case WeatherCondition.rainy:
        weatherIcon = Icons.water_drop_outlined;
        conditionText = 'Rainy';
      default: weatherIcon = Icons.question_mark;
    }


    return Container(
      padding: EdgeInsets.all(20),
      height: 100,
      color: Color.fromARGB(255, 126, 189, 241), 
      child: Row(children: 
        [Expanded(flex:8, child: Builder(
          builder: (context) {
            if (latitude > 180) {
              return Column(children:[Text('Loading'), Text('Location')], mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start);
            } else {
              return Column(children:[Text('Current Location:', style: TextStyle(fontWeight: FontWeight.bold)), Text('$roundedLatitude, $roundedLongitude')], mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start,);
            }
          }
        )), Expanded(flex:5, child:
        Container(child: Icon(weatherIcon, color: Colors.black, size: 40), alignment: Alignment.centerRight,)),Expanded(flex:4, child: Builder(builder: (context) {
          if (conditionText == '') {
            return Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text('  Loading', style: TextStyle(fontSize: 15)), Text('  Weather', style: TextStyle(fontSize: 15))]);  
          }
          return Text('   $conditionText', style: TextStyle(fontSize: 18));
        } ))]));
  }
}