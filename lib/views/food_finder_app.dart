import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_finder/models/venues_db.dart';
import 'package:food_finder/helpers/weather_checker.dart';
import 'package:food_finder/views/header.dart';
import 'package:food_finder/views/venue_list.dart';
import 'package:food_finder/weather_conditions.dart';
import 'package:provider/provider.dart';
import 'package:food_finder/providers/position_provider.dart';
import 'package:food_finder/providers/weather_provider.dart';
import 'dart:async';




class FoodFinderApp extends StatefulWidget {
  final VenuesDB venues;

  const FoodFinderApp({super.key, required this.venues});

  @override
  State<FoodFinderApp> createState() => _FoodFinderAppState();
}



class _FoodFinderAppState extends State<FoodFinderApp> {
  late final Timer _checkerTimer;
  late final WeatherChecker _weatherChecker;

  @override
  initState(){
    super.initState();
    final singleUseWeatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    _weatherChecker = WeatherChecker(singleUseWeatherProvider);

    // This way we don't have to wait a minute from after
    // the app starts to first attempt a weather check.
    Future.delayed(const Duration(seconds: 4), () {
      _weatherChecker.fetchAndUpdateCurrentSeattleWeather();
      singleUseWeatherProvider.isLoaded = true;
    });

    _checkerTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      _weatherChecker.fetchAndUpdateCurrentSeattleWeather();
      singleUseWeatherProvider.isLoaded = true;
    });
  }

  @override 
  dispose(){
    _checkerTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        home: SafeArea(
            child: Scaffold(
              // This is how you can consume from two providers at once without 
              // needing to nest Consumers inside each other 
              body: Consumer2<PositionProvider, WeatherProvider>(
                builder: (context, positionProvider, weatherProvider, child) {
                  if (positionProvider.status) {
                    _weatherChecker.updateLocation(positionProvider.latitude, positionProvider.longitude);
                  }
                  if (!positionProvider.status) {
                    return WeatherHeader(weatherProvider.condition, 200, 200); // Maximum possible coordinates are 180 so this default is fine
                  } else {
                    return Container(
                      child: Column(children: [WeatherHeader(weatherProvider.condition, positionProvider.latitude, positionProvider.longitude), 
                      VenueList(widget.venues.nearestTo(latitude: positionProvider.latitude, longitude: positionProvider.longitude, condition: WeatherCondition.sunny).toList(), positionProvider.latitude, positionProvider.longitude)]),
                    );
                  }
                } 
              ),
            ),
          )
    );
  }
}
