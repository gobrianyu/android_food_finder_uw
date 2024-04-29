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
      padding: const EdgeInsets.all(20),
      height: 100,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 241, 229, 126),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 4,
              blurRadius: 7,
              offset: Offset(0, 2),
            )
          ]
      ),
      child: Row(
        children: [
          Expanded(
            flex:8,
            child: Builder(
              builder: (context) {
                if (latitude > 180) {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text('Loading'), Text('Location')],
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Current Location:', style: TextStyle(fontWeight: FontWeight.bold)), 
                            Text('$roundedLatitude, $roundedLongitude')
                    ],
                  );
                }
              }
            )
          ),
          Expanded(
            flex: 5,
            child: Container(
              alignment: Alignment.centerRight,
              child: Icon(weatherIcon, color: Colors.black, size: 40),
            )
          ),
          Expanded(
            flex: 4,
            child: Builder(
              builder: (context) {
                if (conditionText == '') {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Text('  Loading', style: TextStyle(fontSize: 15)),
                        Text('  Weather', style: TextStyle(fontSize: 15)),
                    ]
                  );  
                }
                return Text('   $conditionText', style: const TextStyle(fontSize: 18));
              }
            )
          )
        ],
      )
    );
  }
}